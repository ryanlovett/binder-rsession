FROM rocker/binder:latest

## Declares build arguments
ARG NB_USER
ARG NB_UID

## Copies your repo files into the Docker Container
USER root

RUN install -d -o ${NB_USER} /var/lib/rstudio-server

RUN chown -R ${NB_USER} ${HOME}

RUN apt update && apt -y install nodejs npm

RUN pip uninstall -y jupyter-rsession-proxy

RUN pip install -U git+https://github.com/ryanlovett/jupyter-rsession-proxy@85a360a

RUN pip install notebook

RUN jupyter server extension enable --py --sys-prefix jupyter_rsession_proxy
RUN jupyter serverextension  enable      --sys-prefix jupyter_rsession_proxy
RUN jupyter nbextension install      --py --sys-prefix jupyter_rsession_proxy
RUN jupyter nbextension enable       --py --sys-prefix jupyter_rsession_proxy

WORKDIR /home/rstudio

## Become normal user again
USER ${NB_USER}

# Use RStudio >= 1.4
ENV RSESSION_PROXY_RSTUDIO_1_4 1

CMD jupyter notebook --debug --ip 0.0.0.0
