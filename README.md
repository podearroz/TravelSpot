# TravelSpot - Frontend Flutter (esqueleto)

Este repositório contém um esqueleto do frontend em Flutter para o projeto TravelSpot. O propósito é fornecer telas iniciais (login, registro, listagem, cadastro de lugares) e serviços com placeholders para integração com Supabase (autenticação, dados e storage). Também incluímos dependências para `dio` e `chopper` caso queira consumir APIs REST adicionais.

### O que inclui

- `lib/main.dart` - ponto de entrada e rotas
- `lib/screens/` - telas: login, registro, home, cadastro de lugar
- `lib/models/place.dart` - modelo Place
- `lib/services/supabase_service.dart` - wrapper básico para Supabase (auth, fetch/add/upload)
- `lib/services/api_service.dart` - wrapper mínimo para `dio` e esqueleto `chopper`
- `pubspec.yaml` - dependências iniciais

### Instalação e configuração (resumo)

1. Instale o Flutter (versão estável). Veja https://flutter.dev
2. No terminal (PowerShell) dentro da pasta do projeto:

```powershell
flutter pub get
```

3. Configurar Supabase:

- Crie um projeto no Supabase.
- Crie tabela `places` com colunas compatíveis (id, name, type, cuisine, description, image_url).
- Crie um bucket `places` em Storage (se usar upload de imagens).
- Pegue sua `SUPABASE_URL` e `SUPABASE_ANON_KEY` e adicione em `lib/config.dart` (substitua os placeholders).

Exemplo mínimo de inicialização (o `main.dart` já chama `Supabase.initialize` usando `lib/config.dart`):

```dart
await Supabase.initialize(
  url: '<YOUR_SUPABASE_URL>',
  anonKey: '<YOUR_SUPABASE_ANON_KEY>',
);
```

### Uso de `dio` e `chopper`

- `dio` já está configurado em `lib/services/api_service.dart` como cliente HTTP genérico.
- `chopper` foi adicionado como dependência caso você prefira gerar serviços REST com `chopper` e `build_runner`.

### Observações e próximos passos

- Este é um esqueleto: serviços usam implementações simples e retornam mocks quando não configurados.
- Próximos passos recomendados:
  - Implementar página de detalhes com avaliações e CRUD de reviews.
  - Implementar upload de imagem usando `image_picker` e `SupabaseService.uploadImage`.
  - Implementar filtros (por tipo, culinária e nota) na `HomeScreen`.
  - Adicionar validações e tratamento de estados (erro/empty/loading) mais robusto.

Se quiser, eu posso:

- Inicializar o Supabase diretamente a partir de variáveis de ambiente.
- Implementar a tela de detalhes com sistema de reviews.
- Integrar o upload de imagens com `image_picker`.
