FROM rocker/binder:latest

## Declares build arguments
ARG NB_USER
ARG NB_UID

## Copies your repo files into the Docker Container
USER root
RUN apt-get update && \
	apt-get -y install gdebi

# Daily
ENV RSTUDIO_VERSION 1.4.1012
RUN wget --quiet https://s3.amazonaws.com/rstudio-ide-build/server/xenial/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb
RUN gdebi -n rstudio-server-${RSTUDIO_VERSION}-amd64.deb

# rserver needs libssl1.0 which isn't in focal
RUN curl -L -o /tmp/libssl1.0.deb http://us.archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.4_amd64.deb && \
	dpkg -i /tmp/libssl1.0.deb

RUN install -d -o ${NB_USER} /var/lib/rstudio-server

RUN chown -R ${NB_USER} ${HOME}

RUN pip install -U git+https://github.com/ryanlovett/jupyter-server-proxy@e13fe72
RUN pip install -U git+https://github.com/ryanlovett/jupyter-rsession-proxy@d6679d9

## Become normal user again
USER ${NB_USER}

# set rserver's --www-root-path
ENV RSESSION_PROXY_WWW_ROOT_PATH /rstudio/

CMD jupyter notebook --debug --ip 0.0.0.0
