FROM osgeo/gdal:ubuntu-small-3.4.0

RUN apt-get -qq install -y --no-install-recommends make
RUN apt-get -qq install -y --no-install-recommends wget
RUN apt-get -qq install -y --no-install-recommends zip
RUN apt-get -qq install -y --no-install-recommends unzip
RUN apt-get -qq install -y --no-install-recommends parallel
RUN apt-get -qq install -y --no-install-recommends postgresql-common
RUN apt-get -qq install -y --no-install-recommends yes
RUN apt-get -qq install -y --no-install-recommends gnupg
RUN apt-get -qq install -y --no-install-recommends gcc
RUN yes '' | sh /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
RUN apt-get -qq install -y --no-install-recommends postgresql-client-14
RUN apt-get -qq install -y --no-install-recommends libpq-dev
RUN apt-get -qq install -y --no-install-recommends jq
RUN apt-get -qq install -y --no-install-recommends python3-dev
RUN apt-get -qq install -y --no-install-recommends python3-pip
RUN apt-get -qq install -y --no-install-recommends git

COPY requirements.txt .
RUN pip install -r requirements.txt

WORKDIR /home/bcfishpass