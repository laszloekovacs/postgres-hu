-- Enable PostGIS (includes raster)
CREATE EXTENSION IF NOT EXISTS postgis;

-- Enable pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- Set default text search config to Hungarian
UPDATE pg_catalog.pg_user SET useconfig = '{default_text_search_config=pg_catalog.hungarian}' WHERE usename = CURRENT_USER;

-- Optional: Create test table with full-text search
CREATE TEXT SEARCH DICTIONARY hungarian_hunspell (
    TEMPLATE = hunspell,
    DictFile = hu_HU,
    AffFile = hu_HU,
    StopWords = hungarian
);

CREATE TEXT SEARCH CONFIGURATION public.hu (COPY=pg_catalog.hungarian);
ALTER TEXT SEARCH CONFIGURATION hu
    ALTER MAPPING FOR asciiword, word, numword, email, url, protocol, numrange
    WITH hunspell_hungarian;