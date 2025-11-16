-- ============================================================================
-- Supabase Schema for TravelSpot
-- ============================================================================
-- Execute este script no Supabase SQL Editor para criar todas as tabelas,
-- índices, políticas RLS e dados iniciais necessários para o app.
--
-- Versão: 1.0
-- Data: 16/11/2025
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. EXTENSÕES
-- ----------------------------------------------------------------------------

-- Extensão para geração de UUIDs
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Extensão para funções UUID v4 (caso necessário)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- ----------------------------------------------------------------------------
-- 2. TABELAS
-- ----------------------------------------------------------------------------

-- Tabela: place_types (Tipos de Lugares)
CREATE TABLE IF NOT EXISTS public.place_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.place_types IS 'Tipos de lugares (Restaurante, Café, Bar, etc.)';


-- Tabela: cuisines (Tipos de Culinária)
CREATE TABLE IF NOT EXISTS public.cuisines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.cuisines IS 'Tipos de culinária (Italiana, Japonesa, Brasileira, etc.)';


-- Tabela: places (Lugares)
CREATE TABLE IF NOT EXISTS public.places (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    address TEXT NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    type_id UUID REFERENCES public.place_types(id) ON DELETE SET NULL,
    photo_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.places IS 'Lugares cadastrados no app';
COMMENT ON COLUMN public.places.address IS 'Endereço do lugar (obrigatório)';
COMMENT ON COLUMN public.places.latitude IS 'Latitude para exibição em mapa (opcional)';
COMMENT ON COLUMN public.places.longitude IS 'Longitude para exibição em mapa (opcional)';
COMMENT ON COLUMN public.places.photo_url IS 'URL da foto do lugar no Supabase Storage';


-- Tabela: place_cuisines (Relação Many-to-Many: Lugar ↔ Culinária)
CREATE TABLE IF NOT EXISTS public.place_cuisines (
    place_id UUID REFERENCES public.places(id) ON DELETE CASCADE,
    cuisine_id UUID REFERENCES public.cuisines(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (place_id, cuisine_id)
);

COMMENT ON TABLE public.place_cuisines IS 'Relação entre lugares e tipos de culinária';


-- Tabela: favorites (Favoritos dos Usuários)
CREATE TABLE IF NOT EXISTS public.favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    place_id UUID REFERENCES public.places(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, place_id)
);

COMMENT ON TABLE public.favorites IS 'Lugares favoritados pelos usuários';
COMMENT ON CONSTRAINT favorites_user_id_place_id_key ON public.favorites 
    IS 'Previne favoritos duplicados do mesmo usuário para o mesmo lugar';


-- Tabela: reviews (Avaliações)
CREATE TABLE IF NOT EXISTS public.reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    place_id UUID REFERENCES public.places(id) ON DELETE CASCADE,
    author_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.reviews IS 'Avaliações de lugares pelos usuários';
COMMENT ON COLUMN public.reviews.rating IS 'Nota de 1 a 5 estrelas';
COMMENT ON COLUMN public.reviews.comment IS 'Comentário opcional do usuário';


-- ----------------------------------------------------------------------------
-- 3. ÍNDICES (Performance)
-- ----------------------------------------------------------------------------

-- Índice para buscar reviews de um lugar específico
CREATE INDEX IF NOT EXISTS idx_reviews_place_id 
    ON public.reviews(place_id);

-- Índice para buscar reviews de um autor específico
CREATE INDEX IF NOT EXISTS idx_reviews_author_id 
    ON public.reviews(author_id);

-- Índice para buscar favoritos de um usuário
CREATE INDEX IF NOT EXISTS idx_favorites_user_id 
    ON public.favorites(user_id);

-- Índice para buscar favoritos de um lugar
CREATE INDEX IF NOT EXISTS idx_favorites_place_id 
    ON public.favorites(place_id);

-- Índice para buscar lugares por tipo
CREATE INDEX IF NOT EXISTS idx_places_type_id 
    ON public.places(type_id);

-- Índice composto para buscar culinárias de um lugar
CREATE INDEX IF NOT EXISTS idx_place_cuisines_place_id 
    ON public.place_cuisines(place_id);


-- ----------------------------------------------------------------------------
-- 4. ROW LEVEL SECURITY (RLS) - POLÍTICAS DE ACESSO
-- ----------------------------------------------------------------------------

-- ========== PLACES ==========
ALTER TABLE public.places ENABLE ROW LEVEL SECURITY;

-- Política: Qualquer pessoa pode ler lugares
CREATE POLICY "public_can_read_places" 
    ON public.places 
    FOR SELECT 
    USING (true);

-- Política: Usuários autenticados podem criar lugares
CREATE POLICY "authenticated_can_create_places" 
    ON public.places 
    FOR INSERT 
    WITH CHECK (auth.role() = 'authenticated');

-- Política: Usuários autenticados podem atualizar lugares
-- (Para implementação futura: apenas criador pode editar)
CREATE POLICY "authenticated_can_update_places" 
    ON public.places 
    FOR UPDATE 
    USING (auth.role() = 'authenticated');


-- ========== PLACE TYPES ==========
ALTER TABLE public.place_types ENABLE ROW LEVEL SECURITY;

-- Política: Qualquer pessoa pode ler tipos de lugares
CREATE POLICY "public_can_read_place_types" 
    ON public.place_types 
    FOR SELECT 
    USING (true);


-- ========== CUISINES ==========
ALTER TABLE public.cuisines ENABLE ROW LEVEL SECURITY;

-- Política: Qualquer pessoa pode ler culinárias
CREATE POLICY "public_can_read_cuisines" 
    ON public.cuisines 
    FOR SELECT 
    USING (true);


-- ========== PLACE CUISINES ==========
ALTER TABLE public.place_cuisines ENABLE ROW LEVEL SECURITY;

-- Política: Qualquer pessoa pode ler relações
CREATE POLICY "public_can_read_place_cuisines" 
    ON public.place_cuisines 
    FOR SELECT 
    USING (true);

-- Política: Autenticados podem criar relações
CREATE POLICY "authenticated_can_create_place_cuisines" 
    ON public.place_cuisines 
    FOR INSERT 
    WITH CHECK (auth.role() = 'authenticated');


-- ========== FAVORITES ==========
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

-- Política: Usuários só podem ver seus próprios favoritos
CREATE POLICY "users_can_view_own_favorites" 
    ON public.favorites 
    FOR SELECT 
    USING (auth.uid() = user_id);

-- Política: Usuários só podem criar seus próprios favoritos
CREATE POLICY "users_can_create_own_favorites" 
    ON public.favorites 
    FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Política: Usuários só podem deletar seus próprios favoritos
CREATE POLICY "users_can_delete_own_favorites" 
    ON public.favorites 
    FOR DELETE 
    USING (auth.uid() = user_id);


-- ========== REVIEWS ==========
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

-- Política: Qualquer pessoa pode ler avaliações
CREATE POLICY "public_can_read_reviews" 
    ON public.reviews 
    FOR SELECT 
    USING (true);

-- Política: Usuários autenticados podem criar avaliações (com seu próprio ID)
CREATE POLICY "authenticated_can_create_reviews" 
    ON public.reviews 
    FOR INSERT 
    WITH CHECK (auth.uid() = author_id);

-- Política: Usuários só podem atualizar suas próprias avaliações
CREATE POLICY "users_can_update_own_reviews" 
    ON public.reviews 
    FOR UPDATE 
    USING (auth.uid() = author_id);

-- Política: Usuários só podem deletar suas próprias avaliações
CREATE POLICY "users_can_delete_own_reviews" 
    ON public.reviews 
    FOR DELETE 
    USING (auth.uid() = author_id);


-- ----------------------------------------------------------------------------
-- 5. FUNÇÕES E TRIGGERS
-- ----------------------------------------------------------------------------

-- Função: Atualizar campo updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Atualizar updated_at em places
DROP TRIGGER IF EXISTS set_updated_at_places ON public.places;
CREATE TRIGGER set_updated_at_places
    BEFORE UPDATE ON public.places
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger: Atualizar updated_at em reviews
DROP TRIGGER IF EXISTS set_updated_at_reviews ON public.reviews;
CREATE TRIGGER set_updated_at_reviews
    BEFORE UPDATE ON public.reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- ----------------------------------------------------------------------------
-- 6. DADOS INICIAIS (Seed Data)
-- ----------------------------------------------------------------------------

-- Inserir tipos de lugares padrão
INSERT INTO public.place_types (name) VALUES
    ('Restaurante'),
    ('Café'),
    ('Bar'),
    ('Lanchonete'),
    ('Padaria'),
    ('Pizzaria'),
    ('Sorveteria'),
    ('Bistrô'),
    ('Pub'),
    ('Food Truck')
ON CONFLICT (name) DO NOTHING;

-- Inserir tipos de culinária padrão
INSERT INTO public.cuisines (name) VALUES
    ('Brasileira'),
    ('Italiana'),
    ('Japonesa'),
    ('Chinesa'),
    ('Mexicana'),
    ('Indiana'),
    ('Árabe'),
    ('Francesa'),
    ('Americana'),
    ('Vegetariana'),
    ('Vegana'),
    ('Frutos do Mar'),
    ('Churrasco'),
    ('Contemporânea'),
    ('Fusion')
ON CONFLICT (name) DO NOTHING;


-- ----------------------------------------------------------------------------
-- 7. STORAGE BUCKET (Para imagens de lugares)
-- ----------------------------------------------------------------------------

-- NOTA: Buckets devem ser criados via Dashboard ou Storage API
-- Este é um exemplo de configuração via SQL (requer permissões especiais)

-- Criar bucket 'places' (se não existir)
INSERT INTO storage.buckets (id, name, public)
VALUES ('places', 'places', true)
ON CONFLICT (id) DO NOTHING;

-- Política: Permitir leitura pública de imagens
CREATE POLICY "public_read_places_images"
ON storage.objects FOR SELECT
USING (bucket_id = 'places');

-- Política: Permitir upload de usuários autenticados
CREATE POLICY "authenticated_upload_places_images"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'places' 
    AND auth.role() = 'authenticated'
);

-- Política: Usuários podem deletar suas próprias imagens
CREATE POLICY "users_delete_own_places_images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'places' 
    AND auth.role() = 'authenticated'
);


-- ----------------------------------------------------------------------------
-- 8. VIEWS ÚTEIS (Opcional)
-- ----------------------------------------------------------------------------

-- View: Lugares com rating médio e contagem de reviews
CREATE OR REPLACE VIEW public.places_with_ratings AS
SELECT 
    p.id,
    p.name,
    p.description,
    p.address,
    p.latitude,
    p.longitude,
    p.photo_url,
    p.type_id,
    pt.name AS type_name,
    COALESCE(AVG(r.rating), 0) AS avg_rating,
    COUNT(r.id) AS review_count,
    p.created_at,
    p.updated_at
FROM public.places p
LEFT JOIN public.place_types pt ON p.type_id = pt.id
LEFT JOIN public.reviews r ON p.id = r.place_id
GROUP BY p.id, pt.name;

COMMENT ON VIEW public.places_with_ratings 
    IS 'Lugares com rating médio calculado e contagem de avaliações';


-- ============================================================================
-- FIM DO SCRIPT
-- ============================================================================

-- Para verificar se tudo foi criado corretamente, execute:
-- SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;

-- Para verificar políticas RLS:
-- SELECT schemaname, tablename, policyname FROM pg_policies WHERE schemaname = 'public' ORDER BY tablename;