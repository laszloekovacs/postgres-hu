FROM postgres:17

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-16-pgvector \
    hunspell-hu \
    && rm -rf /var/lib/apt/lists/*

# convert encoding
RUN echo '---- PROBLEMATIC PART ----'
RUN iconv -f ISO_8859-1 -t UTF-8 /usr/share/hunspell/hu_HU.aff -o /usr/share/hunspell/hu_HU.aff
# RUN iconv -f ISO_8859-1 -t UTF-8 /usr/share/hunspell/hu_HU.dic -o /usr/share/hunspell/hu_HU.dic

# Symlink dictionary files into PostgreSQL's tsearch_data dir
RUN ln -s /usr/share/hunspell/hu_HU.aff /usr/share/postgresql/17/tsearch_data/hu.affix && \
    ln -s /usr/share/hunspell/hu_HU.dic /usr/share/postgresql/17/tsearch_data/hu.dict

# add short word dict
RUN echo 'és vagy de hogy nem' > /usr/share/postgresql/17/tsearch_data/hu.stop


# Copy custom SQL scripts to enable extensions
COPY init-scripts/ /docker-entrypoint-initdb.d/


# Set default locale
#ENV LANG=hu_HU.UTF-8  
#ENV LANGUAGE=hu_HU:hu
#ENV LC_ALL=hu_HU.UTF-8
#ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
#ENV POSTGRES_USER=${POSTGRES_USER}
