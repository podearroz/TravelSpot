# Integração com Supabase - TravelSpot

Este documento detalha como o TravelSpot integra com o Supabase, incluindo autenticação, REST APIs, Storage e configurações.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Configuração Inicial](#configuração-inicial)
- [Autenticação](#autenticação)
- [REST API (Chopper)](#rest-api-chopper)
- [Storage (Upload de Imagens)](#storage-upload-de-imagens)
- [Endpoints](#endpoints)
- [Estrutura de Dados](#estrutura-de-dados)
- [Interceptors e Headers](#interceptors-e-headers)

---

## Visão Geral

O TravelSpot usa o Supabase como backend-as-a-service, integrando:

1. **Supabase Auth**: Sistema de autenticação com email/senha
2. **Supabase Database**: PostgreSQL com REST API automática
3. **Supabase Storage**: Armazenamento de imagens de lugares
4. **Chopper HTTP Client**: Cliente REST customizado para chamadas à API

### Arquitetura de Integração

```
┌─────────────────────┐
│   Flutter App       │
│                     │
│  ┌──────────────┐  │
│  │   BLoC       │  │
│  └──────┬───────┘  │
│         │          │
│  ┌──────▼───────┐  │
│  │ Repository   │  │
│  └──────┬───────┘  │
│         │          │
│  ┌──────▼───────────────────┐
│  │  Supabase Service        │
│  │  ┌─────────────────────┐ │
│  │  │ Supabase Client     │ │  ← Auth
│  │  └─────────────────────┘ │
│  │  ┌─────────────────────┐ │
│  │  │ Chopper REST Client │ │  ← API Calls
│  │  └─────────────────────┘ │
│  │  ┌─────────────────────┐ │
│  │  │ Storage Service     │ │  ← Images
│  │  └─────────────────────┘ │
│  └──────────────────────────┘
└──────────┬──────────┘
           │
           ▼
    ┌─────────────┐
    │  Supabase   │
    │             │
    │  - Auth     │
    │  - Database │
    │  - Storage  │
    └─────────────┘
```

---

## Configuração Inicial

### 1. Dependências (pubspec.yaml)

```yaml
dependencies:
  supabase_flutter: ^2.0.0  # Cliente oficial Supabase
  chopper: ^7.0.0           # HTTP client para REST API
```

### 2. Inicialização (main.dart)

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase
  await Supabase.initialize(
    url: 'https://seu-projeto.supabase.co',
    anonKey: 'sua-anon-key-aqui',
  );
  
  runApp(const MyApp());
}
```

### 3. Obter Credenciais

1. Acesse [supabase.com](https://supabase.com)
2. Crie/acesse seu projeto
3. Vá em **Settings → API**
4. Copie:
   - **Project URL** → `url`
   - **Project API key (anon/public)** → `anonKey`

---

## Autenticação

### Serviço de Autenticação

**Arquivo**: `lib/feature/auth/data/repository/supabase_auth_repository_impl.dart`

O Supabase Auth é acessado através do cliente oficial:

```dart
final client = Supabase.instance.client;

// Registrar usuário
final response = await client.auth.signUp(
  email: email,
  password: password,
  data: {'name': name}, // Metadata adicional
);

// Login
final response = await client.auth.signInWithPassword(
  email: email,
  password: password,
);

// Logout
await client.auth.signOut();

// Obter usuário atual
final user = client.auth.currentUser;

// Obter sessão atual
final session = client.auth.currentSession;
```

### Fluxo de Autenticação

```
┌─────────────┐
│   Login     │
└──────┬──────┘
       │
       ▼
┌──────────────────────────┐
│ signInWithPassword()     │
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│ Supabase retorna:        │
│ - User                   │
│ - Session                │
│ - Access Token (JWT)     │
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│ Token salvo localmente   │
│ (usado em req seguintes) │
└──────────────────────────┘
```

### Headers de Autenticação

Todas as requisições autenticadas incluem:

```
Authorization: Bearer <access_token>
```

O token JWT é renovado automaticamente pelo Supabase Client.

---

## REST API (Chopper)

### Por que Chopper?

Usamos **Chopper** em vez de chamar diretamente a REST API do Supabase porque:

1. ✅ **Type-safety**: Definições de API tipadas
2. ✅ **Interceptors**: Adicionar headers, logging, auth automaticamente
3. ✅ **Conversões**: JSON ↔ Models automático
4. ✅ **Centralização**: Todas as chamadas em um lugar

### Configuração do Cliente REST

**Arquivo**: `lib/core/services/supabase_rest_client.dart`

```dart
class SupabaseRestClient {
  static ChopperClient? _restClient;
  static ChopperClient? _storageClient;
  static GlobalKey<NavigatorState>? _navigatorKey;

  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  static ChopperClient get restClient {
    if (_restClient != null) return _restClient!;

    final baseUrl = Supabase.instance.client.supabaseUrl;

    _restClient = ChopperClient(
      baseUrl: Uri.parse('$baseUrl/rest/v1'),
      services: [
        PlacesApiService.create(),
        FavoritesApiService.create(),
        ReviewsApiService.create(),
        // ... outros services
      ],
      interceptors: [
        // Auth error interceptor (primeiro na cadeia)
        if (_navigatorKey != null)
          AuthErrorInterceptor(_navigatorKey!),
        
        // Auth interceptor (adiciona headers)
        _SupabaseAuthInterceptor(),
        
        // Logging (desenvolvimento)
        if (kDebugMode) HttpLoggingInterceptor(),
      ],
      converter: const JsonConverter(),
    );

    return _restClient!;
  }
}
```

### Interceptor de Autenticação

**Classe**: `_SupabaseAuthInterceptor`

```dart
class _SupabaseAuthInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = applyHeaders(
      chain.request,
      {
        'apikey': Supabase.instance.client.supabaseKey,
        'Authorization': 'Bearer ${_getToken()}',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      },
    );

    return chain.proceed(request);
  }

  String _getToken() {
    final session = Supabase.instance.client.auth.currentSession;
    return session?.accessToken ?? Supabase.instance.client.supabaseKey;
  }
}
```

### Como Funciona

1. **Request criado** → Chopper service define endpoint
2. **Interceptor Auth** → Adiciona headers (apikey, Bearer token)
3. **Request enviado** → Para Supabase REST API
4. **Response recebido** → Converter JSON → Model
5. **Interceptor Error** → Detecta 401/403 e redireciona para sessão expirada

---

## Storage (Upload de Imagens)

### Configuração do Bucket

**No Supabase Dashboard**:

1. Vá em **Storage**
2. Crie bucket `places`
3. Configure políticas (RLS):

```sql
-- Permitir leitura pública
CREATE POLICY "Public read access"
ON storage.objects FOR SELECT
USING (bucket_id = 'places');

-- Permitir upload autenticado
CREATE POLICY "Authenticated users can upload"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'places' 
  AND auth.role() = 'authenticated'
);
```

### Upload de Imagens

**Arquivo**: `lib/core/services/supabase_service.dart`

```dart
Future<String> uploadPlaceImage(Uint8List bytes, String fileName) async {
  try {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniqueFileName = '${timestamp}_$fileName';
    
    // Upload para bucket 'places'
    final path = await _client.storage
        .from('places')
        .uploadBinary(
          uniqueFileName,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: false,
          ),
        );

    // Obter URL pública
    final publicUrl = _client.storage
        .from('places')
        .getPublicUrl(uniqueFileName);

    return publicUrl;
  } catch (e) {
    throw Exception('Erro no upload: $e');
  }
}
```

### Fluxo de Upload

```
┌──────────────────┐
│ Usuário seleciona│
│ imagem (picker)  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Crop da imagem   │
│ (image_cropper)  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Converter para   │
│ Uint8List        │
└────────┬─────────┘
         │
         ▼
┌──────────────────────────┐
│ uploadPlaceImage()       │
│  - Gera nome único       │
│  - Upload para bucket    │
│  - Retorna URL pública   │
└────────┬─────────────────┘
         │
         ▼
┌──────────────────┐
│ Salvar URL no    │
│ banco (places)   │
└──────────────────┘
```

---

## Endpoints

### Base URL

```
https://seu-projeto.supabase.co/rest/v1
```

### Headers Obrigatórios

```http
apikey: <sua-anon-key>
Authorization: Bearer <access-token-ou-anon-key>
Content-Type: application/json
```

---

### 1. Places (Lugares)

#### GET `/places`
Listar todos os lugares com joins

**Service**: `PlacesApiService.getPlaces()`

**Request**:
```http
GET /rest/v1/places?select=*,place_type:place_types(*),cuisines:place_cuisines(cuisine:cuisines(*))
```

**Query Parameters**:
- `select`: Campos a retornar (suporta joins com `:`)
- `limit`: Número máximo de resultados
- `offset`: Paginação

**Response** (200):
```json
[
  {
    "id": "uuid",
    "name": "Restaurante Exemplo",
    "description": "Descrição do lugar",
    "address": "Rua Exemplo, 123",
    "latitude": -23.5505,
    "longitude": -46.6333,
    "photo_url": "https://...storage.../image.jpg",
    "created_at": "2025-11-16T10:00:00Z",
    "place_type": {
      "id": "uuid",
      "name": "Restaurante"
    },
    "cuisines": [
      {
        "cuisine": {
          "id": "uuid",
          "name": "Italiana"
        }
      }
    ]
  }
]
```

#### POST `/places`
Criar novo lugar

**Service**: `PlacesApiService.createPlace()`

**Request**:
```http
POST /rest/v1/places
Content-Type: application/json
Prefer: return=representation

{
  "name": "Novo Restaurante",
  "description": "Descrição opcional",
  "address": "Rua Nova, 456",
  "latitude": -23.5505,
  "longitude": -46.6333,
  "type_id": "uuid-do-tipo",
  "photo_url": "https://...storage.../foto.jpg"
}
```

**Response** (201):
```json
[
  {
    "id": "novo-uuid",
    "name": "Novo Restaurante",
    // ... demais campos
  }
]
```

#### GET `/places?id=eq.<uuid>`
Obter lugar específico

**Service**: `PlacesApiService.getPlaceById()`

**Request**:
```http
GET /rest/v1/places?id=eq.abc123&select=*,place_type:place_types(*),cuisines:place_cuisines(cuisine:cuisines(*))
```

**Response** (200):
```json
[
  {
    "id": "abc123",
    "name": "Lugar Específico",
    // ... campos completos
  }
]
```

---

### 2. Place Types (Tipos de Lugares)

#### GET `/place_types`
Listar tipos de lugares

**Service**: `PlacesApiService.getPlaceTypes()`

**Request**:
```http
GET /rest/v1/place_types?select=*
```

**Response** (200):
```json
[
  {
    "id": "uuid-1",
    "name": "Restaurante"
  },
  {
    "id": "uuid-2",
    "name": "Café"
  },
  {
    "id": "uuid-3",
    "name": "Bar"
  }
]
```

---

### 3. Cuisines (Culinárias)

#### GET `/cuisines`
Listar tipos de culinária

**Service**: `PlacesApiService.getCuisines()`

**Request**:
```http
GET /rest/v1/cuisines?select=*
```

**Response** (200):
```json
[
  {
    "id": "uuid-1",
    "name": "Italiana"
  },
  {
    "id": "uuid-2",
    "name": "Japonesa"
  },
  {
    "id": "uuid-3",
    "name": "Brasileira"
  }
]
```

---

### 4. Favorites (Favoritos)

#### GET `/favorites?user_id=eq.<user-id>`
Listar favoritos do usuário

**Service**: `FavoritesApiService.getUserFavorites()`

**Request**:
```http
GET /rest/v1/favorites?user_id=eq.abc123&select=*
Authorization: Bearer <access-token>
```

**Response** (200):
```json
[
  {
    "id": "fav-uuid-1",
    "user_id": "abc123",
    "place_id": "place-uuid-1",
    "created_at": "2025-11-16T10:00:00Z"
  }
]
```

#### POST `/favorites`
Adicionar favorito

**Service**: `FavoritesApiService.addFavorite()`

**Request**:
```http
POST /rest/v1/favorites
Authorization: Bearer <access-token>
Content-Type: application/json
Prefer: return=representation

{
  "user_id": "abc123",
  "place_id": "place-uuid-1"
}
```

**Response** (201):
```json
[
  {
    "id": "novo-fav-uuid",
    "user_id": "abc123",
    "place_id": "place-uuid-1",
    "created_at": "2025-11-16T11:00:00Z"
  }
]
```

#### DELETE `/favorites?user_id=eq.<user-id>&place_id=eq.<place-id>`
Remover favorito

**Service**: `FavoritesApiService.removeFavorite()`

**Request**:
```http
DELETE /rest/v1/favorites?user_id=eq.abc123&place_id=eq.place-uuid-1
Authorization: Bearer <access-token>
Prefer: return=representation
```

**Response** (200):
```json
[
  {
    "id": "fav-uuid-removido",
    // ... campos do favorito removido
  }
]
```

---

### 5. Reviews (Avaliações)

#### GET `/reviews?place_id=eq.<place-id>`
Listar avaliações de um lugar

**Service**: `ReviewsApiService.getPlaceReviews()`

**Request**:
```http
GET /rest/v1/reviews?place_id=eq.place-uuid-1&select=*&order=created_at.desc
```

**Response** (200):
```json
[
  {
    "id": "review-uuid-1",
    "place_id": "place-uuid-1",
    "author_id": "user-uuid-1",
    "rating": 5,
    "comment": "Excelente lugar!",
    "created_at": "2025-11-16T10:00:00Z"
  },
  {
    "id": "review-uuid-2",
    "place_id": "place-uuid-1",
    "author_id": "user-uuid-2",
    "rating": 4,
    "comment": "Muito bom",
    "created_at": "2025-11-15T15:30:00Z"
  }
]
```

#### POST `/reviews`
Adicionar avaliação

**Service**: `ReviewsApiService.addReview()`

**Request**:
```http
POST /rest/v1/reviews
Authorization: Bearer <access-token>
Content-Type: application/json
Prefer: return=representation

{
  "place_id": "place-uuid-1",
  "author_id": "user-uuid-1",
  "rating": 5,
  "comment": "Excelente lugar!"
}
```

**Response** (201):
```json
[
  {
    "id": "novo-review-uuid",
    "place_id": "place-uuid-1",
    "author_id": "user-uuid-1",
    "rating": 5,
    "comment": "Excelente lugar!",
    "created_at": "2025-11-16T11:30:00Z"
  }
]
```

---

### 6. Place Cuisines (Relação Lugar-Culinária)

#### POST `/place_cuisines`
Associar culinária a um lugar

**Service**: `PlacesApiService.addPlaceCuisine()`

**Request**:
```http
POST /rest/v1/place_cuisines
Authorization: Bearer <access-token>
Content-Type: application/json

{
  "place_id": "place-uuid-1",
  "cuisine_id": "cuisine-uuid-1"
}
```

**Response** (201):
```json
[
  {
    "place_id": "place-uuid-1",
    "cuisine_id": "cuisine-uuid-1"
  }
]
```

---

## Estrutura de Dados

### Schema do Banco

```sql
-- Users (gerenciado pelo Supabase Auth)
auth.users (
  id UUID PRIMARY KEY,
  email TEXT UNIQUE,
  created_at TIMESTAMP
)

-- Place Types
place_types (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE
)

-- Cuisines
cuisines (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE
)

-- Places
places (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  address TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  type_id UUID REFERENCES place_types(id),
  photo_url TEXT,
  created_at TIMESTAMP DEFAULT NOW()
)

-- Place-Cuisine (Many-to-Many)
place_cuisines (
  place_id UUID REFERENCES places(id) ON DELETE CASCADE,
  cuisine_id UUID REFERENCES cuisines(id) ON DELETE CASCADE,
  PRIMARY KEY (place_id, cuisine_id)
)

-- Favorites
favorites (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  place_id UUID REFERENCES places(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, place_id)
)

-- Reviews
reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  place_id UUID REFERENCES places(id) ON DELETE CASCADE,
  author_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT NOW()
)
```

### Políticas RLS (Row Level Security)

```sql
-- Places: público pode ler, autenticados podem criar
ALTER TABLE places ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can read places"
ON places FOR SELECT
USING (true);

CREATE POLICY "Authenticated can create places"
ON places FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

-- Favorites: usuários só veem seus próprios favoritos
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own favorites"
ON favorites FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can create own favorites"
ON favorites FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own favorites"
ON favorites FOR DELETE
USING (auth.uid() = user_id);

-- Reviews: público pode ler, autenticados podem criar
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can read reviews"
ON reviews FOR SELECT
USING (true);

CREATE POLICY "Authenticated can create reviews"
ON reviews FOR INSERT
WITH CHECK (auth.uid() = author_id);
```

---

## Interceptors e Headers

### 1. AuthErrorInterceptor

**Propósito**: Detectar erros de autenticação (401/403) e redirecionar para tela de sessão expirada.

**Arquivo**: `lib/core/services/auth_error_interceptor.dart`

```dart
class AuthErrorInterceptor implements Interceptor {
  final GlobalKey<NavigatorState> navigatorKey;

  AuthErrorInterceptor(this.navigatorKey);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final response = await chain.proceed(chain.request);

    // Detectar erro de autenticação
    if (response.statusCode == 401 || response.statusCode == 403) {
      _navigateToSessionExpired();
    }

    return response;
  }

  void _navigateToSessionExpired() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/session-expired',
        (route) => false,
      );
    }
  }
}
```

### 2. HttpLoggingInterceptor

**Propósito**: Logar requisições e respostas durante desenvolvimento.

```dart
class HttpLoggingInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;
    
    print('→ ${request.method} ${request.url}');
    print('  Headers: ${request.headers}');
    if (request.body != null) {
      print('  Body: ${request.body}');
    }

    final response = await chain.proceed(request);

    print('← ${response.statusCode} ${request.url}');
    print('  Body: ${response.body}');

    return response;
  }
}
```

### 3. Header `Prefer: return=representation`

Este header garante que o Supabase retorne o objeto criado/modificado na resposta:

```dart
final headers = {
  'Prefer': 'return=representation',
};
```

**Sem o header**:
```json
// Response vazio ou status 204
```

**Com o header**:
```json
[
  {
    "id": "uuid-criado",
    "name": "Objeto criado",
    // ... campos completos
  }
]
```

---

## Tratamento de Erros

### Códigos HTTP Comuns

| Código | Significado | Ação |
|--------|-------------|------|
| 200 | Success | Processar resposta |
| 201 | Created | Objeto criado com sucesso |
| 204 | No Content | Ação bem-sucedida sem retorno |
| 400 | Bad Request | Validar dados enviados |
| 401 | Unauthorized | Token inválido/expirado → Sessão expirada |
| 403 | Forbidden | Sem permissão → Sessão expirada |
| 404 | Not Found | Recurso não existe |
| 409 | Conflict | Violação de constraint (ex: favorito duplicado) |
| 500 | Server Error | Erro no servidor Supabase |

### Exemplo de Tratamento

```dart
try {
  final response = await _apiService.getPlaces();
  
  if (response.isSuccessful && response.body != null) {
    return response.body!;
  } else {
    throw Exception('Erro ao buscar lugares: ${response.statusCode}');
  }
} on SocketException {
  throw Exception('Sem conexão com internet');
} catch (e) {
  throw Exception('Erro inesperado: $e');
}
```

---

## Exemplos de Uso Completo

### Criar Lugar com Imagem e Culinárias

```dart
// 1. Upload da imagem
final imageUrl = await supabaseService.uploadPlaceImage(
  imageBytes,
  'foto.jpg',
);

// 2. Criar o lugar
final createRequest = {
  'name': 'Novo Restaurante',
  'description': 'Ótimo restaurante italiano',
  'address': 'Rua das Flores, 100',
  'latitude': -23.5505,
  'longitude': -46.6333,
  'type_id': restauranteTypeId,
  'photo_url': imageUrl,
};

final placeResponse = await placesApiService.createPlace(createRequest);
final newPlace = placeResponse.body!.first;

// 3. Associar culinárias
for (final cuisineId in selectedCuisineIds) {
  await placesApiService.addPlaceCuisine({
    'place_id': newPlace.id,
    'cuisine_id': cuisineId,
  });
}

// 4. Recarregar lista de places
emit(PlaceAddedState(newPlace));
```

### Favoritar Lugar

```dart
// Verificar se já é favorito
final favorites = await favoritesApiService.getUserFavorites(userId);
final isFavorite = favorites.body?.any(
  (fav) => fav.placeId == placeId
) ?? false;

if (!isFavorite) {
  // Adicionar favorito
  await favoritesApiService.addFavorite({
    'user_id': userId,
    'place_id': placeId,
  });
  
  emit(FavoriteAddedState(placeId));
}
```

---

## Configuração de Desenvolvimento vs Produção

### Desenvolvimento

```dart
// Habilitar logs
const bool kDebugMode = true;

// Interceptors incluem logging
interceptors: [
  if (kDebugMode) HttpLoggingInterceptor(),
  // ...
]
```

### Produção

```dart
// Desabilitar logs
const bool kDebugMode = false;

// Usar variáveis de ambiente
final supabaseUrl = Platform.environment['SUPABASE_URL']!;
final supabaseKey = Platform.environment['SUPABASE_KEY']!;

// Remover botões de teste
// (ex: botão de sessão expirada em places_list_page.dart)
```

---

## Recursos Adicionais

### Documentação Oficial

- [Supabase Docs](https://supabase.com/docs)
- [Supabase Flutter](https://supabase.com/docs/reference/dart/introduction)
- [REST API Reference](https://supabase.com/docs/guides/api)
- [Storage Reference](https://supabase.com/docs/guides/storage)
- [Chopper Documentation](https://pub.dev/packages/chopper)

### Ferramentas Úteis

- **Postman/Insomnia**: Testar endpoints manualmente
- **Supabase Dashboard**: Visualizar dados, logs, storage
- **Flutter DevTools**: Debug de requisições HTTP

### Queries Úteis no Supabase

```sql
-- Ver todos os lugares com tipo e culinárias
SELECT 
  p.*,
  pt.name as place_type_name,
  array_agg(c.name) as cuisines
FROM places p
LEFT JOIN place_types pt ON p.type_id = pt.id
LEFT JOIN place_cuisines pc ON p.id = pc.place_id
LEFT JOIN cuisines c ON pc.cuisine_id = c.id
GROUP BY p.id, pt.name;

-- Ver favoritos de um usuário com detalhes do lugar
SELECT 
  f.*,
  p.name as place_name,
  p.photo_url
FROM favorites f
JOIN places p ON f.place_id = p.id
WHERE f.user_id = '<user-uuid>';

-- Calcular rating médio de cada lugar
SELECT 
  p.id,
  p.name,
  AVG(r.rating) as avg_rating,
  COUNT(r.id) as review_count
FROM places p
LEFT JOIN reviews r ON p.id = r.place_id
GROUP BY p.id, p.name
ORDER BY avg_rating DESC;
```

---

## Troubleshooting

### Erro 401 em todas as requisições

**Problema**: Token não está sendo enviado.

**Solução**: Verificar se `_SupabaseAuthInterceptor` está adicionando header Authorization.

### Erro 403 "Row level security policy violation"

**Problema**: Políticas RLS bloqueando ação.

**Solução**: Verificar políticas no Supabase Dashboard → Authentication → Policies.

### Upload de imagem retorna 404

**Problema**: Bucket não existe ou nome incorreto.

**Solução**: Criar bucket `places` no Storage e verificar nome.

### Interceptor de sessão expirada não funciona

**Problema**: `navigatorKey` não foi configurado.

**Solução**: Chamar `SupabaseRestClient.setNavigatorKey()` no `main.dart`.

---

**Última atualização**: 16/11/2025
