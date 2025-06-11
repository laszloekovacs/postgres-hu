# Use the official PostgreSQL image as base
FROM postgres:17

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        libpq-dev \
        wget \
        git \
        postgresql-server-dev-all \
        hunspell \
        hunspell-hu \
        libhunspell-dev && \
    rm -rf /var/lib/apt/lists/*

# Add pgvector extension
WORKDIR /tmp/pgvector
RUN git clone https://github.com/pgvector/pgvector.git  . && \
    cmake -DCMAKE_BUILD_TYPE=Release && \
    make && \
    make install

# Add PostGIS extension
RUN apt-get update && \
    apt-get install -y postgis postgresql-$(echo $(cat /usr/include/postgresql/server.h | grep PG_VERSION_NUM | awk '{print $3}'))-postgis-3 && \
    dockerize -wait tcp://localhost:5432 -timeout 60s

# Enable shared_preload_libraries for pgvector (optional but recommended)
RUN echo "shared_preload_libraries = 'vector'" >> /usr/local/share/postgresql/postgresql.conf.sample

# Copy custom SQL scripts to enable extensions
COPY init-scripts/ /docker-entrypoint-initdb.d/

# Install snowball stemmer for Hungarian
RUN cd /usr/src && \
    git clone https://github.com/snowballstem/snowball.git  && \
    cd snowball && \
    ./bootstrap.sh && \
    ./configure && \
    make && \
    make install