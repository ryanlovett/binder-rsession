FROM rocker/binder:latest

## Declares build arguments
ARG NB_USER
ARG NB_UID

## Copies your repo files into the Docker Container
USER root

# rserver needs libssl1.0 which isn't in focal
RUN curl -L -o /tmp/libssl1.0.deb http://us.archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.6_amd64.deb && \
	dpkg -i /tmp/libssl1.0.deb

# Daily
#ENV RSTUDIO_VERSION 1.4.1012
ENV RSTUDIO_VERSION 1.4.1657
RUN wget --quiet https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb
RUN apt install ./rstudio-server-${RSTUDIO_VERSION}-amd64.deb

RUN install -d -o ${NB_USER} /var/lib/rstudio-server

RUN chown -R ${NB_USER} ${HOME}

RUN apt -y install nodejs npm

RUN pip uninstall -y jupyter-server-proxy jupyter-rsession-proxy

RUN git clone https://github.com/ryanlovett/jupyter-server-proxy
WORKDIR /home/rstudio/jupyter-server-proxy
#RUN git checkout 518fb84
RUN git checkout eb4eb76
RUN pip install .
#RUN pip install -U git+https://github.com/ryanlovett/jupyter-server-proxy@8bc9e13

#RUN pip install -U jupyter-rsession-proxy
#RUN pip install -U git+https://github.com/ryanlovett/jupyter-rsession-proxy@4ef7823
#RUN pip install -U git+https://github.com/ryanlovett/jupyter-rsession-proxy@root_path_header
WORKDIR /home/rstudio
RUN git clone https://github.com/ryanlovett/jupyter-rsession-proxy
WORKDIR /home/rstudio/jupyter-rsession-proxy
RUN git checkout 5d8690c
RUN pip install .

WORKDIR /home/rstudio

COPY jupyter_notebook_config.py /usr/local/etc/jupyter/
COPY myserver.py /home/rstudio/

## Become normal user again
USER ${NB_USER}

# Use RStudio >= 1.4
ENV RSESSION_PROXY_RSTUDIO_1_4 1

CMD jupyter notebook --debug --ip 0.0.0.0
