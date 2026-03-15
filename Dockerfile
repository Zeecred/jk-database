FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config default-libmysqlclient-dev build-essential figlet \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/jk-database
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
