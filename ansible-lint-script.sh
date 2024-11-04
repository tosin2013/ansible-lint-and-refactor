#!/bin/bash
set -x

# Define the model and editor model (Ensure these variables are set in your environment)
export OLLAMA_API_BASE=http://ollama.ollama.svc.cluster.local:11434
export MODEL="ollama/granite3-dense:8b"
export EDITOR_MODEL="ollama/granite3-dense:8b"

# Configure Git
git clone https://github.com/tosin2013/ocp4-disconnected-helper.git
cd ocp4-disconnected-helper
git config --local user.name "user1"
git config --local user.email "user1@example.com"

# Define the files to refactor
export PLAYBOOKS_DIR="playbooks/"
export TASKS_DIR="playbooks/tasks/"

for FILE in ${PLAYBOOKS_DIR}*.yml ${TASKS_DIR}*.yml; do
    export ARCHITECT_MESSAGE="$(ansible-lint ${FILE})"
    echo ${ARCHITECT_MESSAGE}
    aider ${FILE} \
    --architect --model "$MODEL" --editor-model $EDITOR_MODEL \
    --auto-commits --auto-test --yes --suggest-shell-commands \
    --message "${ARCHITECT_MESSAGE}" \
    --check-update  --test-cmd "ansible-lint ${FILE}" --edit-format diff

    # Optional: Wait for user input before proceeding to the next file
    # echo "Processed $FILE. Press Enter to continue..."
    # read -r

    # or Alternative: Sleep for a few seconds before next iteration
    sleep 5
    rm -rf .aider.input.history
    rm -rf .aider.chat.history.md
done