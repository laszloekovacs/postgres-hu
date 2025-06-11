CREATE TEXT SEARCH CONFIGURATION public.hu (COPY=pg_catalog.hungarian);
ALTER TEXT SEARCH CONFIGURATION hu
    ALTER MAPPING FOR asciiword, word, numword, email, url, protocol, numrange
    WITH hunspell_hungarian;

CREATE TEXT SEARCH DICTIONARY hunspell_hu (
  TEMPLATE = ispell,
  DictFile = 'hu_HU',
  AffFile = 'hu_HU',
  StopWords = 'hu'
);

-- Create custom schema
  CREATE SCHEMA IF NOT EXISTS postgis;

  -- Install extensions into custom schema
  CREATE EXTENSION IF NOT EXISTS postgis SCHEMA postgis;
  CREATE EXTENSION IF NOT EXISTS postgis_topology SCHEMA postgis;

  -- Optional: install other useful PostGIS extensions
  CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
  CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;
  CREATE EXTENSION IF NOT EXISTS postgis_raster;

CREATE EXTENSION IF NOT EXISTS vector;

  -- Move functions to postgis schema
  ALTER DATABASE $POSTGRES_DB SET search_path = public, postgis;
