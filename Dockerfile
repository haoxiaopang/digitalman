FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_INDEX_URL=https://mirrors.aliyun.com/pypi/simple \
    SDL_AUDIODRIVER=dummy

WORKDIR /app

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
    && apt-get install -y --no-install-recommends \
        build-essential \
        ffmpeg \
        libasound2 \
        libgl1 \
        libglib2.0-0 \
        libportaudio2 \
        libsm6 \
        libsndfile1 \
        libxext6 \
        libxrender1 \
        portaudio19-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN python -m pip install --upgrade pip -i https://mirrors.aliyun.com/pypi/simple \
    && python -m pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple

COPY . .

RUN if [ ! -f system.conf ] && [ -f system.conf.bak ]; then cp system.conf.bak system.conf; fi

EXPOSE 5000 5010 9001 10001 10002 10003