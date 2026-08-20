FROM ghcr.io/osgeo/gdal:ubuntu-full-3.13.1

RUN apt-get update && apt-get --assume-yes upgrade \
    && apt-get -qq install -y --no-install-recommends curl \
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
    && apt-get -qq install -y --no-install-recommends jq \
    && apt-get -qq install -y --no-install-recommends python3-pip \
    && apt-get -qq install -y --no-install-recommends python3-dev \
    && apt-get -qq install -y --no-install-recommends python3-venv \
    && apt-get -qq install -y --no-install-recommends openssh-client \
    && apt-get -qq install -y --no-install-recommends autossh \
    && apt-get -qq install -y --no-install-recommends less \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && curl -L https://aka.ms/downloadazcopy-v10-linux -o azcopy.tar.gz \
    && tar -xf azcopy.tar.gz --strip-components=1 -C /usr/local/bin --wildcards '*/azcopy' \
    && rm azcopy.tar.gz \
    && chmod +x /usr/local/bin/azcopy

RUN ARCH=$(uname -m) \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}-2.22.21.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

RUN curl -L https://github.com/mikefarah/yq/releases/download/v4.53.2/yq_linux_amd64 -o /usr/bin/yq && chmod +x /usr/bin/yq

WORKDIR /home/bcfishpass
RUN git config --global --add safe.directory /home/bcfishpass

COPY requirements.txt .

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/python -m pip install -U pip && \
    /opt/venv/bin/python -m pip install --no-cache-dir -r requirements.txt

ENV PATH="/opt/venv/bin:$PATH"