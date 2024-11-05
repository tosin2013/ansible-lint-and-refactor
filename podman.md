# Running Ansible Lint and Refactor with Docker and Podman

This guide explains how to run the Ansible Lint and Refactor Docker container using both Docker and Podman on your local machine.

## Prerequisites

- Ensure Docker and/or Podman are installed and running on your host operating system.
- Ensure the Docker image is built.

## Steps

### 1. Build the Docker Image

If you haven't already built the Docker image, you can do so using the provided `Dockerfile`.

#### Using Docker

```bash
docker build -t ansible-lint-and-refactor .
```

#### Using Podman

```bash
podman build -t ansible-lint-and-refactor .
```

### 2. Set Environment 
```bash
mkdir -p ~/workspace
cd ~/workspace
git clone https://gitea.apps.cluster-b2c8s.b2c8s.sandbox2594.opentlc.com/user1/ocp4-disconnected-helper.git # git@github.com:tosin2013/ocp4-disconnected-helper.git
chmod -R 775 ~/workspace/ocp4-disconnected-helper
```

### 3. Run the Container with Volume Mount

#### Using Docker

Use the `docker run` command to mount the `~/workspace` directory from your host operating system into the Docker container.

##### Using OLLAMA API
```bash
docker run -it --privileged \
  -v ~/workspace:/workspace \
  -e OLLAMA_API_BASE=http://ollama.ollama.svc.cluster.local:11434 \
  -e MODEL=ollama/granite3-dense:8b \
  -e EDITOR_MODEL=ollama/granite3-dense:8b \
  -e PLAYBOOKS_DIR=playbooks/ \
  -e TASKS_DIR=playbooks/tasks/ \
  -e REPO_NAME=ocp4-disconnected-helper \
  -e HOME=/workspace \
  -u $(id -u):$(id -g) \
  ansible-lint-and-refactor \
  /opt/ansible-venv/bin/ansible-lint-script.sh

```

##### Using Deepseek API
```bash
export DEEPSEEK_API_KEY=sk-xxxxxx
docker run -it --privileged -v ~/workspace:/workspace \
  -e DEEPSEEK_API_KEY=$DEEPSEEK_API_KEY \
  -e DEEPSEEK_API_KEY=$DEEPSEEK_API_KEY \
  -e MODEL=deepseek/deepseek-coder \
  -e EDITOR_MODEL=deepseek/deepseek-coder \
  -e PLAYBOOKS_DIR=playbooks/ \
  -e TASKS_DIR=playbooks/tasks/ \
  -e REPO_NAME=ocp4-disconnected-helper \
  -e HOME=/workspace \
  -u $(id -u):$(id -g) \
  ansible-lint-and-refactor \
  /opt/ansible-venv/bin/ansible-lint-script.sh
```


#### Using Podman

Use the `podman run` command to mount the `~/workspace` directory from your host operating system into the Podman container.

```bash
podman run -it \
  -v ~/workspace:/workspace:Z \
  -e OLLAMA_API_BASE=http://ollama.ollama.svc.cluster.local:11434 \
  -e MODEL=ollama/granite3-dense:8b \
  -e EDITOR_MODEL=ollama/granite3-dense:8b \
  -e PLAYBOOKS_DIR=playbooks/ \
  -e TASKS_DIR=playbooks/tasks/ \
  -e REPO_NAME=ocp4-disconnected-helper \
  -u $(id -u):$(id -g) \
  ansible-lint-and-refactor \
  /opt/ansible-venv/bin/ansible-lint-script.sh
```
##### Using Deepseek API
```bash
export DEEPSEEK_API_KEY=sk-xxxxxx
podman run -it \
  -v ~/workspace:/workspace \
  -e DEEPSEEK_API_KEY=$DEEPSEEK_API_KEY \
  -e MODEL=deepseek/deepseek-coder \
  -e EDITOR_MODEL=deepseek/deepseek-coder \
  -e PLAYBOOKS_DIR=playbooks/ \
  -e TASKS_DIR=playbooks/tasks/ \
  -e REPO_NAME=ocp4-disconnected-helper \
  -e HOME=/workspace \
  -u $(id -u):$(id -g) \
  ansible-lint-and-refactor \
  /opt/ansible-venv/bin/ansible-lint-script.sh
```

### 3. Monitor the Output

The script will run inside the container, and you can monitor the output in your terminal. It will process the playbooks and tasks in the mounted directory, refactor them using Aider, and commit the changes to the local Git repository.

## Notes

- **Environment Variables**: Ensure that the environment variables (`OLLAMA_API_BASE`, `MODEL`, `EDITOR_MODEL`, `PLAYBOOKS_DIR`, `TASKS_DIR`) are correctly set according to your setup.
- **Git Configuration**: The script assumes that the Git repository in `~/workspace` is already configured with the necessary user name and email. If not, you may need to configure Git manually before running the script.
- **Permissions**: Ensure that the user running the Docker or Podman container has the necessary permissions to read and write to the `~/workspace` directory.
