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

# Install Node.js 18
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    rm -rf /var/lib/apt/lists/*

# Verify Node.js installation
RUN node --version && npm --version

# Install Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools

RUN mkdir -p ${ANDROID_HOME} && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O android-commandline-tools.zip && \
    unzip -q android-commandline-tools.zip -d ${ANDROID_HOME} && \
    mv ${ANDROID_HOME}/cmdline-tools ${ANDROID_HOME}/latest && \
    mkdir ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/latest ${ANDROID_HOME}/cmdline-tools/ && \
    rm android-commandline-tools.zip

# Accept Android SDK licenses
RUN yes | sdkmanager --licenses

# Install required Android SDK packages
RUN sdkmanager --install \
    "platforms;android-33" \
    "build-tools;33.0.0" \
    "platform-tools" \
    "ndk;25.1.8937393"

# Create a user for the GitHub runner
RUN useradd -m actions-runner \
    && usermod -aG sudo actions-runner \
    && usermod -aG docker actions-runner \
    && echo "actions-runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create directory for global npm packages
RUN mkdir -p /home/actions-runner/.npm-global && \
    chown -R actions-runner:actions-runner /home/actions-runner/.npm-global

# Switch to the runner user
USER actions-runner
WORKDIR /home/actions-runner

# Configure npm to use new directory and add to PATH
ENV NPM_CONFIG_PREFIX=/home/actions-runner/.npm-global
ENV PATH=/home/actions-runner/.npm-global/bin:$PATH

# Download and install GitHub runner
ARG RUNNER_VERSION=2.311.0
RUN curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Install global npm packages
RUN npm install -g expo-cli && \
    npm install -g eas-cli

# Copy the startup script
COPY --chown=actions-runner:actions-runner start.sh .
RUN sudo chmod +x start.sh

ENTRYPOINT ["./start.sh"]