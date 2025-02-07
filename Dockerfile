FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive


# Install essential packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    jq \
    tar \
    unzip \
    zip \
    sudo \
    software-properties-common \
    docker.io \
    openjdk-17-jdk \
    build-essential \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN curl -o actions-runner-linux-x64-2.322.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.322.0/actions-runner-linux-x64-2.322.0.tar.gz

RUN tar xzf ./actions-runner-linux-x64-2.322.0.tar.gz

WORKDIR /app

# Copy the startup script
COPY start.sh .

USER ghactions

CMD ["bash","start.sh"]