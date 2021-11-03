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
	https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2021.09.0-351-amd64.deb
RUN apt update && \
	apt install -y --no-install-recommends /tmp/rstudio-server.deb

RUN chown -R ${NB_USER} ${HOME}

#RUN apt update && apt -y install nodejs npm

#RUN pip uninstall -y jupyter-server-proxy jupyter-rsession-proxy

#WORKDIR /home/rstudio
#RUN git clone https://github.com/ryanlovett/jupyter-server-proxy && \
#    cd /home/rstudio/jupyter-server-proxy && \
#    git checkout eb4eb76
#WORKDIR /home/rstudio/jupyter-server-proxy
#RUN pip install .
RUN pip install -U git+https://github.com/jupyterhub/jupyter-server-proxy

#RUN pip install -U jupyter-rsession-proxy
#RUN pip install -U git+https://github.com/ryanlovett/jupyter-rsession-proxy@4ef7823
RUN pip install -U git+https://github.com/ryanlovett/jupyter-rsession-proxy@rs-2021.09

#WORKDIR /home/rstudio
#RUN git clone https://github.com/ryanlovett/jupyter-rsession-proxy && \
#    cd /home/rstudio/jupyter-rsession-proxy && \
#    git checkout 89f7a9a
#WORKDIR /home/rstudio/jupyter-rsession-proxy
#RUN pip install .

WORKDIR /home/rstudio

#COPY jupyter_notebook_config.py /usr/local/etc/jupyter/
#COPY myserver.py /home/rstudio/

## Become normal user again
USER ${NB_USER}

# Use RStudio >= 1.4
#ENV RSESSION_PROXY_RSTUDIO_1_4 1

CMD jupyter notebook --debug --ip 0.0.0.0
