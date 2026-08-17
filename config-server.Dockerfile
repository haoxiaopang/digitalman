FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /opt/fay_config_server

RUN set -eux; \
    for source_file in /etc/apt/sources.list /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources; do \
        if [ -f "$source_file" ]; then \
            sed -i \
                -e 's|deb.debian.org|mirrors.aliyun.com|g' \
                -e 's|security.debian.org|mirrors.aliyun.com|g' \
                "$source_file"; \
        fi; \
    done; \
    apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/xszyou/fay_config_server.git . \
    && rm -rf projects/* \
    && python -m pip install --upgrade pip -i https://mirrors.aliyun.com/pypi/simple \
    && python -m pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple \
    && mkdir -p projects

EXPOSE 5500