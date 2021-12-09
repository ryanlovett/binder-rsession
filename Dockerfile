FROM rocker/binder:4.1.2

## Declares build arguments
ARG NB_USER

## Become normal user again
USER ${NB_USER}

CMD jupyter notebook --debug --ip 0.0.0.0
