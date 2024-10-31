FROM ubuntu:23.10
LABEL maintainer="Tosin Akinosho"

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
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
    python3-full \
    python3-yaml \
    software-properties-common \
    sudo iproute2 \
    && rm -Rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
    && apt-get clean

# Fix potential UTF-8 errors
RUN locale-gen en_US.UTF-8

# Install Ansible directly
RUN pip3 install --no-cache-dir ansible ansible-navigator ansible-dev-tools

# Install Ansible inventory file
RUN mkdir -p /etc/ansible && printf "[local]\nlocalhost ansible_connection=local\n" > /etc/ansible/hosts

# Create `ansible` user with sudo permissions
ENV ANSIBLE_USER=ansible
RUN set -xe \
    && useradd -m ${ANSIBLE_USER} \
    && echo "${ANSIBLE_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ansible

CMD ["/bin/bash"]
