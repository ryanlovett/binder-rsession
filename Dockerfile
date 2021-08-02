FROM rocker/binder:latest

## Declares build arguments
ARG NB_USER
ARG NB_UID

## Copies your repo files into the Docker Container
USER root

# Daily
#ENV RSTUDIO_VERSION 1.4.1717
#RUN wget --quiet https://download2.rstudio.org/server/bionic/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb
#RUN apt install ./rstudio-server-${RSTUDIO_VERSION}-amd64.deb

RUN install -d -o ${NB_USER} /var/lib/rstudio-server

RUN chown -R ${NB_USER} ${HOME}

RUN apt update && apt -y install nodejs npm

RUN pip uninstall -y jupyter-rsession-proxy

#WORKDIR /home/rstudio
#RUN git clone https://github.com/ryanlovett/jupyter-server-proxy && \
#    cd /home/rstudio/jupyter-server-proxy && \
#    git checkout eb4eb76
#WORKDIR /home/rstudio/jupyter-server-proxy
#RUN pip install .
#RUN pip install -U git+https://github.com/jupyterhub/jupyter-server-proxy

#RUN pip install -U jupyter-rsession-proxy
RUN pip install -U git+https://github.com/ryanlovett/jupyter-rsession-proxy@195e026
#RUN pip install -U git+https://github.com/ryanlovett/jupyter-rsession-proxy@root_path_header
#WORKDIR /home/rstudio

#WORKDIR /home/rstudio
#RUN git clone https://github.com/ryanlovett/jupyter-rsession-proxy && \
#    cd /home/rstudio/jupyter-rsession-proxy && \
#    git checkout 89f7a9a
#WORKDIR /home/rstudio/jupyter-rsession-proxy
#RUN pip install .

RUN jupyter server extension enable --py --sys-prefix jupyter_rsession_proxy
RUN jupyter serverextension  enable      --sys-prefix jupyter_rsession_proxy

RUN pip install notebook
RUN jupyter nbextension install      --py --sys-prefix jupyter_rsession_proxy
RUN jupyter nbextension enable       --py --sys-prefix jupyter_rsession_proxy

WORKDIR /home/rstudio

#COPY jupyter_notebook_config.py /usr/local/etc/jupyter/
#COPY myserver.py /home/rstudio/

## Become normal user again
USER ${NB_USER}

# Use RStudio >= 1.4
ENV RSESSION_PROXY_RSTUDIO_1_4 1

CMD jupyter notebook --debug --ip 0.0.0.0
