-- Supabase schema for TravelSpot
-- Execute this in Supabase SQL Editor (Query) to create tables used by the app.

-- Extension for UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Table: places
CREATE TABLE IF NOT EXISTS public.places (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    name text NOT NULL,
    type text,
    cuisine text,
    description text,
    image_url text,
    created_at timestamptz DEFAULT now()
);

-- Table: reviews
CREATE TABLE IF NOT EXISTS public.reviews (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    place_id uuid REFERENCES public.places (id) ON DELETE CASCADE,
    user_id text,
    rating integer CHECK (
        rating >= 1
        AND rating <= 5
    ),
    comment text,
    image_url text,
    created_at timestamptz DEFAULT now()
);

-- Index to speed up fetching reviews by place
CREATE INDEX IF NOT EXISTS idx_reviews_place_id ON public.reviews (place_id);

-- Note: configure Row Level Security (RLS) and policies according to your auth model.
-- Example minimal policies (for development only):
-- ALTER TABLE public.places ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY "public_select_places" ON public.places FOR SELECT USING (true);
-- ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY "public_select_reviews" ON public.reviews FOR SELECT USING (true);