FROM jupyter/r-notebook:latest

## Declares build arguments
ARG NB_USER
ARG NB_UID

## Copies your repo files into the Docker Container
USER root

RUN apt update && \
	apt install -y --no-install-recommends \
	software-properties-common \
	dirmngr

RUN wget -q -O /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
	https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/"

# rstudio server
RUN wget --quiet -O /tmp/rstudio-server.deb \
	https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2021.09.1-372-amd64.deb
RUN apt update && \
	apt install -y --no-install-recommends /tmp/rstudio-server.deb

RUN chown -R ${NB_USER} ${HOME}

RUN pip install jupyter-server-proxy==3.2.0

RUN pip install -U git+https://github.com/ryanlovett/jupyter-rsession-proxy@jsp-pr301-dev

## Become normal user again
USER ${NB_USER}

CMD jupyter notebook --debug --ip 0.0.0.0
