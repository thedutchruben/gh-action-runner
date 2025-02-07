FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl wget git jq tar unzip zip sudo \
    software-properties-common build-essential \
    ca-certificates gnupg \
    && rm -rf /var/lib/apt/lists/*

# Create user and add to sudo/docker groups
RUN useradd -m ghactions && \
    echo "ghactions ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    usermod -aG docker ghactions

RUN curl -o actions-runner-linux-x64-2.322.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.322.0/actions-runner-linux-x64-2.322.0.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.322.0.tar.gz

WORKDIR /app
COPY start.sh .
RUN chown -R ghactions:ghactions /app

USER ghactions
CMD ["bash","start.sh"]
