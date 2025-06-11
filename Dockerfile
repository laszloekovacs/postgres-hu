FROM postgres:16

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-server-dev-all \
    postgresql-16-postgis-3 \
    postgresql-16-postgis-3-scripts \
    postgresql-16-pgvector \
    locales \
    hunspell-hu \
    && rm -rf /var/lib/apt/lists/*

# Enable Hungarian dictionary
RUN sed -i 's/# hu_HU.UTF-8 UTF-8/hu_HU.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

# Symlink dictionary files into PostgreSQL's tsearch_data dir
RUN ln -s /usr/share/hunspell/hu_HU.aff /usr/share/postgresql/16/tsearch_data/hu_HU.aff && \
    ln -s /usr/share/hunspell/hu_HU.dic /usr/share/postgresql/16/tsearch_data/hu_HU.dic

RUN echo 'és vagy de hogy nem' > /usr/share/postgresql/16/tsearch_data/hu.stop


# Copy custom SQL scripts to enable extensions
COPY init-scripts/ /docker-entrypoint-initdb.d/


# Set default locale
ENV LANG hu_HU.UTF-8  
ENV LANGUAGE hu_HU:hu
ENV LC_ALL hu_HU.UTF-8
