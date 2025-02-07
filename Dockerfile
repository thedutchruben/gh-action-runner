FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
   curl wget git jq tar unzip zip sudo \
   software-properties-common build-essential \
   ca-certificates gnupg lsb-release


# Setup user
RUN useradd -m ghactions && \
   echo "ghactions ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

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
