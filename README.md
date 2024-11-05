# Ansible Lint and Refactor

This action runs Ansible Lint on your playbooks and tasks, and then uses Aider to refactor them. It requires an image with Ansible, Ansible Lint, and Aider installed.

## Usage

To use this action in another repository, you can add the following code to your `.github/workflows/ansible-lint-and-refactor.yml` file:

```yaml
name: 'Ansible Lint and Refactor - OLLAMA'
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  ansible-lint-and-refactor:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Adjust Workspace Permissions
        run: |
          sudo chown -R 1000:1000 ${{ github.workspace }}

      - name: Run Ansible Lint and Refactor in Container
        uses: addnab/docker-run-action@v3
        with:
          image: quay.io/takinosh/ansible-lint-and-refactor:da3de0378544e860d38371435a8b42af8981fb70
          options: |
            -v ${{ github.workspace }}:/workspace
            -e OLLAMA_API_BASE=${{ secrets.OLLAMA_API_BASE }}
            -e MODEL=${{ secrets.MODEL }}
            -e EDITOR_MODEL=${{ secrets.EDITOR_MODEL }}
            -e PLAYBOOKS_DIR=playbooks/
            -e TASKS_DIR=playbooks/tasks/
          run: |
            set -e
            whoami
            ls -lath /workspace
            ls -ld /workspace/.git
            cd /workspace
            echo ${OLLAMA_API_BASE}
            echo "USING MODEL: ${MODEL}"
            /opt/ansible-venv/bin/ansible-lint-script.sh || exit 1
```

**Note**: Replace the `OLLAMA_API_BASE` URL with the URL of your own Ollama API.

## Inputs

None.

## Outputs

None.

## Environment Variables

- `OLLAMA_API_BASE`: The URL of the Ollama API.
- `MODEL`: The Ollama model to use for refactoring.
- `EDITOR_MODEL`: The Ollama editor model to use for refactoring.
- `PLAYBOOKS_DIR`: The directory containing your playbooks.
- `TASKS_DIR`: The directory containing your tasks.
- `SLEEP_TIME`: The time to sleep before running the refactoring script.
