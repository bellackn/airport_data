FROM python:3-slim
LABEL maintainer "Nico Bellack <bellack.n@gmail.com>"

COPY requirements.txt /tmp/reqs

RUN \
    BUILD_DEPS="\
        gcc \
        libpq-dev \
        python3-dev" \
    && RUNTIME_DEPS="\
        libpq5" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        $BUILD_DEPS $RUNTIME_DEPS \
    && pip install -r /tmp/reqs \
    && apt-get purge -y --auto-remove \
        $BUILD_DEPS \
    && apt-get clean \
    && rm -rf \
        /tmp/* \
        /var/log/dpkg.log \
        /var/log/alternatives.log \
        /var/log/apt \
        /var/lib/apt/lists/*

EXPOSE 5000

CMD ["python", "/api/app.py"]