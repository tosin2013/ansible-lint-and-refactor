# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04
LABEL maintainer="Tosin Akinosho"
LABEL version="1.0"
LABEL description="Ansible environment with Python 3.12"

# Set non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install software-properties-common to get add-apt-repository
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common \
    gnupg \
    ca-certificates

# Add deadsnakes PPA for Python 3.12
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776 && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update

# Install Python 3.12 and other dependencies
RUN apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    locales \
    libffi-dev \
    libssl-dev \
    libyaml-dev \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3-setuptools \
    python3-pip \
    python3-apt \
    python3-yaml \
    git \
    curl \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libglib2.0-0 \
    sudo \
    iproute2 && \
    rm -Rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man && \
    apt-get clean

# Set python3 to point to Python 3.12
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1

# Fix potential UTF-8 errors
RUN locale-gen en_US.UTF-8

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment and install Python packages
RUN python3 -m venv /opt/ansible-venv \
    && /opt/ansible-venv/bin/pip install --upgrade pip \
    && /opt/ansible-venv/bin/pip install --no-cache-dir \
        ansible \
        ansible-lint \
        ansible-navigator \
        molecule \
        ansible-dev-tools \
        aider-chat \
        aider \
        playwright \
    && /opt/ansible-venv/bin/python -m playwright install --with-deps chromium

# Add virtual environment to PATH
ENV PATH="/opt/ansible-venv/bin:$PATH"

# Install Ansible inventory file
RUN mkdir -p /etc/ansible && printf "[local]\nlocalhost ansible_connection=local\n" > /etc/ansible/hosts

# Create `ansible` user with sudo permissions
ENV ANSIBLE_USER=ansible
RUN set -xe \
    && useradd -m  ${ANSIBLE_USER} \
    && echo "${ANSIBLE_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${ANSIBLE_USER} \
    && chmod 0440 /etc/sudoers.d/${ANSIBLE_USER} \
    && mkdir -p /ansible \
    && chown -R ${ANSIBLE_USER}:${ANSIBLE_USER} /opt/ansible-venv /etc/ansible /ansible

# Set working directory
WORKDIR /ansible

# Switch to 'ansible' user
USER ${ANSIBLE_USER}

# Add a health check
HEALTHCHECK CMD ansible --version || exit 1

# Switch to the `ansible` user
USER ${ANSIBLE_USER}

CMD ["/bin/bash"]
