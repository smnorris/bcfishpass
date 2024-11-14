FROM ghcr.io/osgeo/gdal:ubuntu-small-3.8.3

RUN apt-get update && apt-get --assume-yes upgrade \
    && apt-get -qq install -y --no-install-recommends postgresql-common \
    && apt-get -qq install -y --no-install-recommends yes \
    && apt-get -qq install -y --no-install-recommends gnupg \
    && yes '' | sh /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh \
    && apt-get -qq install -y --no-install-recommends postgresql-client-16 \
    && apt-get -qq install -y --no-install-recommends make \
    && apt-get -qq install -y --no-install-recommends g++ \
    && apt-get -qq install -y --no-install-recommends git \
    && apt-get -qq install -y --no-install-recommends zip \
    && apt-get -qq install -y --no-install-recommends unzip \
    && apt-get -qq install -y --no-install-recommends parallel \
    && apt-get -qq install -y --no-install-recommends python3-dev \
    && apt-get -qq install -y --no-install-recommends python3-pip \
    && apt-get -qq install -y --no-install-recommends python3-psycopg2 \
    && pip3 install --upgrade numpy \
    && pip3 install bcdata \
    && pip3 install scikit-image \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf /var/lib/apt/lists/*