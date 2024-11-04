# Ubuntu 22.04 LTS Ansible Test Image

Ubuntu 22.04 LTS (Jammy Jellyfish) Docker container for Ansible playbook and role testing.  
This container is used to test Ansible roles and playbooks (e.g. with molecule) running locally inside the container.  
A non-priviledged user `ansible` is created with password-less sudo configured.

```
name: Android CI

on: [push]

jobs:

  android-ci:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v1

    - name: "Android CI Github Action"
      uses: code0987/android-ci-github-action@master
      with:
        args: |
          npm install
          export GRADLE_USER_HOME=`pwd`./src/.gradle
          chmod 755 ./src/gradlew 
          ./src/gradlew -p ./src check
```

[![Docker Build and Publish](https://github.com/tosin2013/docker-ubuntu2204-ansible/actions/workflows/ci.yml/badge.svg)](https://github.com/tosin2013/docker-ubuntu2204-ansible/actions/workflows/ci.yml) ![Docker Pulls](https://img.shields.io/docker/pulls/tosin2013/ubuntu2204-ansible) ![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/tosin2013/docker-ubuntu2204-ansible/main)

## Tags

The following tags are available:

  - `latest`: Latest stable version of Ansible on Python 3.x

## How to Build

This image is built on Docker Hub automatically any time the upstream OS container is rebuilt, and any time a commit is made or merged to the `master` branch. But if you need to build the image on your own locally, do the following:

  1. [Install Docker](https://docs.docker.com/engine/installation/).
  2. Clone this repository and `cd` into this directory.
  3. Run `make build` to build the Docker image.

## How to Use Standalone

  1. [Install Docker](https://docs.docker.com/engine/installation/).
  2. Pull this image from Docker Hub or use the image you built earlier.
  ```bash
  docker pull quay.io/takinosh/ubuntu2204-ansible
  ```
  3. Run a container from the image. To test my Ansible roles, I add in a volume mounted from the current working directory with ``--volume=`pwd`:/etc/ansible/roles/role_under_test:ro``.
  ```bash
  docker run --detach --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro quay.io/takinosh/ubuntu2204-ansible
  ``` 
  4. Use Ansible inside the container:
  ```bash
  docker exec --tty [container_id] env TERM=xterm ansible --version
  ```
  ```bash
  docker exec --tty [container_id] env TERM=xterm ansible-playbook /path/to/ansible/playbook.yml
  ```

## How to Use with Molecule

  1. [Install Docker](https://docs.docker.com/engine/installation/).
  2. [Install Molecule](https://molecule.readthedocs.io/en/latest/installation.html).
  3. Add Image in molecule.yml.

For example:
```yaml
---
driver:
  name: docker
platforms:
  - name: ubuntu2204
    image: quay.io/takinosh/ubuntu2204-ansible
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: true
    command: "/lib/systemd/systemd"
    pre_build_image: true
provisioner:
  name: ansible
  config_options:
    defaults:
      interpreter_python: auto_silent
      callback_whitelist: profile_tasks, timer, yaml
      stdout_callback: yaml
    ssh_connection:
      pipelining: false
  inventory:
    host_vars:
      ubuntu2204:
        ansible_user: ansible
```

## Makefile Usage

The `Makefile` provides several targets to help with building, testing, and running the Docker image:

- **Build the Docker image**:
  ```bash
  make build
  ```

- **Run the Docker container**:
  ```bash
  make run
  ```

- **Run a health check on the Docker container**:
  ```bash
  make test
  ```

- **Push the Docker image to a registry**:
  ```bash
  make push
  ```

- **Clean up Docker images and containers**:
  ```bash
  make clean
  ```

## Author

Created 2021 by Tim Grützmacher, inspired by [Jeff Geerling](https://www.jeffgeerling.com/)
Updated 2024 by Tosin Akinosho
