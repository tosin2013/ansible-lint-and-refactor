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
       python3-dev \
       python3-setuptools \
       python3-pip \
       python3-apt \
       python3-yaml \
       software-properties-common \
       rsyslog systemd systemd-cron sudo iproute2 \
    && rm -Rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
    && apt-get clean

# Disable rsyslog kernel logging to avoid errors
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Remove unnecessary getty and udev targets to reduce CPU usage
RUN rm -f /lib/systemd/system/systemd*udev* /lib/systemd/system/getty.target

# Fix potential UTF-8 errors
RUN locale-gen en_US.UTF-8

# Install Ansible via Pip
ENV pip_packages "ansible"
RUN pip3 install --no-cache-dir $pip_packages

# Copy initctl_faker
COPY initctl_faker /initctl_faker
RUN chmod +x /initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Install Ansible inventory file
RUN mkdir -p /etc/ansible && printf "[local]\nlocalhost ansible_connection=local\n" > /etc/ansible/hosts

# Create `ansible` user with sudo permissions
ENV ANSIBLE_USER=ansible
RUN set -xe \
  && useradd -m ${ANSIBLE_USER} \
  && echo "${ANSIBLE_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ansible

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
