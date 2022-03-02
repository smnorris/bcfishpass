FROM osgeo/gdal:ubuntu-small-3.4.1

RUN apt-get -qq install -y --no-install-recommends make
RUN apt-get -qq install -y --no-install-recommends wget
RUN apt-get -qq install -y --no-install-recommends zip
RUN apt-get -qq install -y --no-install-recommends unzip
#RUN apt-get -qq install -y --no-install-recommends parallel
RUN apt-get -qq install -y --no-install-recommends postgresql-common
RUN apt-get -qq install -y --no-install-recommends yes
RUN apt-get -qq install -y --no-install-recommends gnupg
RUN apt-get -qq install -y --no-install-recommends gcc
RUN yes '' | sh /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
RUN apt-get -qq install -y --no-install-recommends postgresql-client-14
RUN apt-get -qq install -y --no-install-recommends libpq-dev
#RUN apt-get -qq install -y --no-install-recommends jq
#RUN apt-get -qq install -y --no-install-recommends python3-dev
#RUN apt-get -qq install -y --no-install-recommends python3-pip
RUN apt-get -qq install -y --no-install-recommends git

RUN curl https://raw.githubusercontent.com/fphilipe/psql2csv/master/psql2csv > /usr/local/bin/psql2csv && chmod +x /usr/local/bin/psql2csv

ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda.sh && \
	/bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

#COPY requirements.txt .
#RUN pip install -r requirements.txt

COPY environment.yml .
RUN conda env create -f environment.yml

WORKDIR /home/bcfishpass