FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl wget git jq tar unzip zip sudo \
    software-properties-common build-essential \
    ca-certificates gnupg lsb-release

# Add Docker's official GPG key and repository
RUN mkdir -m 0755 -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
RUN apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Setup user
RUN useradd -m ghactions && \
    echo "ghactions ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    usermod -aG docker ghactions

# Setup GitHub runner
WORKDIR /app
RUN curl -o actions-runner-linux-x64-2.322.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.322.0/actions-runner-linux-x64-2.322.0.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.322.0.tar.gz && \
    rm actions-runner-linux-x64-2.322.0.tar.gz

COPY start.sh .
RUN chmod +x start.sh && \
    chown -R ghactions:ghactions .

USER ghactions
CMD ["./start.sh"]
