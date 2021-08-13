#FROM rocker/binder:latest
FROM jupyter/r-notebook:latest

## Declares build arguments
ARG NB_USER
ARG NB_UID

## Copies your repo files into the Docker Container
USER root

#RUN install -d -o ${NB_USER} /var/lib/rstudio-server

RUN apt update && \
	apt install -y --no-install-recommends software-properties-common dirmngr
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/"

RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb
RUN apt update && \
	apt install -y ./rstudio-server-1.4.1717-amd64.deb

RUN chown -R ${NB_USER} ${HOME}

#RUN pip uninstall -y jupyter-rsession-proxy

## Become normal user again
USER ${NB_USER}

RUN pip install jupyter_packaging

#RUN apt update && apt -y install nodejs npm
#RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && \
#	apt install -y nodejs

WORKDIR /tmp
ENV SHA a07aa77
RUN git clone https://github.com/ryanlovett/jupyter-rsession-proxy
WORKDIR /tmp/jupyter-rsession-proxy
RUN git checkout $SHA
RUN pip install .
#WORKDIR /tmp/jupyter-rsession-proxy/jupyterlab-rsession-proxy
#RUN npm install
#RUN npm run build
#RUN jupyter labextension link .

WORKDIR /home/rstudio

# Use RStudio >= 1.4
#ENV RSESSION_PROXY_RSTUDIO_1_4 1

CMD jupyter lab --debug --ip 0.0.0.0
