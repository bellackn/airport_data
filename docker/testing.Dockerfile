FROM python:3-slim
LABEL maintainer "Nico Bellack <bellack.n@gmail.com>"

COPY . /app
WORKDIR /app

RUN \
    pip install pytest requests

CMD ["pytest"]