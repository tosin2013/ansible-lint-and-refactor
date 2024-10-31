# Use Ubuntu 23.10 as base
FROM ubuntu:23.10
LABEL maintainer="Tosin Akinosho"
LABEL version="1.0"
LABEL description="Ansible environment with Python 3.12"

# Set non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and Python 3.12
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    software-properties-common \
    sudo iproute2 \
    && rm -Rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
    && apt-get clean

# Set python3 to point to Python 3.12
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1

# Ensure pip is up to date
RUN python3 -m ensurepip --upgrade

# Fix potential UTF-8 errors
RUN locale-gen en_US.UTF-8

# Create virtual environment and install Ansible
RUN python3 -m venv /opt/ansible-venv \
    && /opt/ansible-venv/bin/pip install --no-cache-dir ansible ansible-navigator ansible-dev-tools

# Add virtual environment to PATH
ENV PATH="/opt/ansible-venv/bin:$PATH"

# Install Ansible inventory file
RUN mkdir -p /etc/ansible && printf "[local]\nlocalhost ansible_connection=local\n" > /etc/ansible/hosts

# Create `ansible` user with sudo permissions
ENV ANSIBLE_USER=ansible
RUN set -xe \
    && useradd -m ${ANSIBLE_USER} \
    && echo "${ANSIBLE_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ansible

# Set working directory
WORKDIR /ansible

# Add a health check
HEALTHCHECK CMD ansible --version || exit 1

CMD ["/bin/bash"]
