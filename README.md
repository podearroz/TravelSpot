# TravelSpot

Aplicativo Flutter para descobrir, avaliar e favoritar lugares interessantes. Desenvolvido com arquitetura limpa, BLoC pattern e integração com Supabase.

## 📱 Funcionalidades

### Autenticação
- ✅ Login e registro com email/senha
- ✅ Detecção automática de sessão expirada
- ✅ Logout com limpeza de sessão
- ✅ Navegação sem login (modo exploração)

### Gerenciamento de Lugares
- ✅ Listagem de lugares com cards modernos (imagem 16:9)
- ✅ Skeleton/shimmer loading durante carregamento
- ✅ Placeholder para lugares sem imagem
- ✅ Adicionar novos lugares com:
  - Nome (obrigatório)
  - Endereço (obrigatório)
  - Descrição
  - Tipo de lugar
  - Tipos de culinária
  - Coordenadas geográficas (opcional)
  - Upload de imagem com crop
- ✅ Detalhes do lugar com SliverAppBar e Hero animation
- ✅ Visualização de tipo, rating, descrição, localização e culinárias

### Sistema de Favoritos
- ✅ Adicionar/remover lugares dos favoritos
- ✅ Página de favoritos com navegação para detalhes
- ✅ Sincronização automática com Supabase
- ✅ Requer autenticação

### Sistema de Avaliações
- ✅ Visualizar avaliações de lugares
- ✅ Adicionar avaliação (nota de 1-5 estrelas + comentário)
- ✅ Feedback visual da nota (Muito ruim → Excelente)
- ✅ Requer autenticação

### Internacionalização
- ✅ Suporte a Português (pt) e Inglês (en)
- ✅ Todas as strings da UI traduzidas
- ✅ Mensagens de erro e validação localizadas

### UX/UI
- ✅ Design moderno e responsivo
- ✅ Tema claro/escuro
- ✅ Animações e transições suaves
- ✅ Estados de loading, erro e vazio

## 🏗️ Arquitetura

### Estrutura de Pastas
```
lib/
├── core/                      # Configurações e utilitários centrais
│   ├── di/                    # Dependency Injection
│   ├── routes/                # Rotas nomeadas
│   ├── services/              # Serviços (Supabase)
│   └── theme/                 # Temas e paletas de cores
├── feature/                   # Features do app (Clean Architecture)
│   ├── auth/                  # Autenticação
│   │   ├── data/             # Repository implementations
│   │   ├── domain/           # Entities, repositories, use cases
│   │   └── presentation/     # BLoC, pages, widgets
│   ├── places/               # Lugares
│   ├── favorites/            # Favoritos
│   └── reviews/              # Avaliações
├── generated/l10n/           # Arquivos de localização gerados
└── main.dart                 # Entry point
```

### Padrões Utilizados
- **Clean Architecture**: Separação em camadas (data, domain, presentation)
- **BLoC Pattern**: Gerenciamento de estado reativo
- **Repository Pattern**: Abstração de fontes de dados
- **Dependency Injection**: Usando `get_it`
- **Feature-first**: Organização por funcionalidade

## 🚀 Como Rodar

### Pré-requisitos
- Flutter SDK 3.0+ ([Instalação](https://flutter.dev))
- Dart SDK 3.0+
- Conta no [Supabase](https://supabase.com)

### 1. Clonar o Repositório
```powershell
git clone <repository-url>
cd TravelSpot
```

### 2. Instalar Dependências
```powershell
flutter pub get
```

### 3. Configurar Supabase

#### 3.1. Criar Projeto no Supabase
1. Acesse [supabase.com](https://supabase.com) e crie um projeto
2. Copie a `URL` e `anon key` do projeto

#### 3.2. Criar Tabelas
Execute o SQL no Supabase SQL Editor:

```sql
-- Tabela de lugares
CREATE TABLE places (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  address TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  type_id UUID REFERENCES place_types(id),
  photo_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de tipos de lugares
CREATE TABLE place_types (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE
);

-- Tabela de culinárias
CREATE TABLE cuisines (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE
);

-- Tabela de relação lugar-culinária
CREATE TABLE place_cuisines (
  place_id UUID REFERENCES places(id) ON DELETE CASCADE,
  cuisine_id UUID REFERENCES cuisines(id) ON DELETE CASCADE,
  PRIMARY KEY (place_id, cuisine_id)
);

-- Tabela de favoritos
CREATE TABLE favorites (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  place_id UUID REFERENCES places(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, place_id)
);

-- Tabela de avaliações
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  place_id UUID REFERENCES places(id) ON DELETE CASCADE,
  author_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 3.3. Configurar Storage
1. Crie um bucket chamado `places` no Supabase Storage
2. Configure como público para permitir leitura de imagens

#### 3.4. Configurar Variáveis de Ambiente
Crie um arquivo `lib/core/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

**Ou** configure diretamente em `lib/main.dart`.

### 4. Gerar Arquivos de Localização
```powershell
flutter gen-l10n
```

### 5. Executar o App
```powershell
# Para desenvolvimento (debug mode)
flutter run

# Para Android
flutter run -d android

# Para iOS
flutter run -d ios

# Para Web
flutter run -d chrome
```

## 🧪 Testes

### Testar Funcionalidades Principais

#### 1. Autenticação
- Criar conta com email/senha
- Fazer login
- Testar detecção de sessão expirada (há botão de teste na lista de lugares)
- Fazer logout

#### 2. Lugares
- Visualizar lista de lugares
- Adicionar novo lugar com todos os campos
- Testar validação (nome e endereço são obrigatórios)
- Fazer upload de imagem e crop
- Visualizar detalhes de um lugar

#### 3. Favoritos
- Favoritar um lugar (requer login)
- Desfavoritar
- Acessar página "Meus Favoritos"
- Navegar para detalhes de um favorito

#### 4. Avaliações
- Abrir detalhes de um lugar
- Clicar em "Ver/Adicionar Avaliações"
- Adicionar avaliação com nota e comentário
- Verificar que avaliação aparece na lista

#### 5. Sessão Expirada
- Na lista de lugares, clicar no botão de bug (canto inferior direito)
- Verificar redirecionamento para tela de sessão expirada
- Testar botões "Fazer Login" e "Explorar sem Login"

### Executar Testes Unitários
```powershell
flutter test
```

### Executar Testes de Integração
```powershell
flutter test integration_test/
```

## 📦 Dependências Principais

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  
  # Backend
  supabase_flutter: ^2.0.0
  chopper: ^7.0.0
  
  # DI
  get_it: ^7.6.4
  
  # Image
  image_picker: ^1.0.4
  image_cropper: ^5.0.0
  
  # Permissions
  permission_handler: ^11.0.1
  device_info_plus: ^9.1.0
  
  # Internacionalização
  intl: ^0.18.0
  flutter_localizations:
    sdk: flutter
```

## 🛠️ Scripts Úteis

### Limpar Build
```powershell
flutter clean
flutter pub get
```

### Gerar Traduções
```powershell
flutter gen-l10n
```

### Analisar Código
```powershell
flutter analyze
```

### Formatar Código
```powershell
dart format .
```

### Build para Produção
```powershell
# Android (APK)
flutter build apk --release

# Android (App Bundle)
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🌐 Internacionalização

O app suporta múltiplos idiomas através do sistema de l10n do Flutter.

### Adicionar Nova Tradução
1. Adicione a chave/valor em `lib/l10n/app_pt.arb`
2. Adicione a tradução correspondente em `lib/l10n/app_en.arb`
3. Execute `flutter gen-l10n`
4. Use `AppLocalizations.of(context).suaChave` no código

## 🎨 Temas

O app suporta temas claro e escuro com paleta customizada:
- Sistema de cores adaptativo
- Tipografia consistente
- Espaçamentos padronizados

## 📝 Notas Importantes

### Remover Botão de Teste
Antes de publicar, remover o botão de teste de sessão expirada em `lib/feature/places/presentation/page/places_list_page.dart` (linhas ~385-399):

```dart
// TODO: REMOVE BEFORE PRODUCTION
floatingActionButton: FloatingActionButton(...)
```

### Configuração de Produção
- Substituir chaves hardcoded por variáveis de ambiente
- Configurar ProGuard/R8 para Android
- Configurar Code Signing para iOS
- Ajustar permissões no `AndroidManifest.xml` e `Info.plist`

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👨‍💻 Desenvolvido com

- Flutter & Dart
- Supabase
- BLoC Pattern
- Clean Architecture
