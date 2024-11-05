#!/bin/bash
set -euo pipefail

function pause(){
 read -s -n 1 -p "Press any key to continue . . ."
 echo ""
}

# Define the model and editor model (Ensure these variables are set in your environment)
# export OLLAMA_API_BASE=http://ollama.ollama.svc.cluster.local:11434
# export MODEL="ollama/granite3-dense:8b"
# export EDITOR_MODEL="ollama/granite3-dense:8b"
export SLEEP_TIME=30

# Testing Configure Git
# git clone https://github.com/tosin2013/ocp4-disconnected-helper.git
cd /workspace/${REPO_NAME}
git config --global --add safe.directory /workspace/${REPO_NAME}


# Define the files to refactor
#export PLAYBOOKS_DIR="playbooks/"
#export TASKS_DIR="playbooks/tasks/"

for FILE in ${PLAYBOOKS_DIR}*.yml ${TASKS_DIR}*.yml; do
    export ARCHITECT_MESSAGE="$(ansible-lint --offline -p -f pep8 ${FILE})"
    echo "Processed FILENAME: ${FILE}"

    while IFS= read -r line
    do
        echo "Processing: $line"
        # https://webutility.io/chatgpt-prompt-generator-for-coders
        PROMPT="You are an AI language model assisting a developer with the action \"Debug\" related to \"${FILE}\". \
        The following ansible-lint error occurred in the context of \"$line\". \
        Explain the nature of the errors, the steps you took to resolve them, \
        and any potential improvements or alternative solutions that may be applicable."

        aider ${FILE} \
          --architect --model "$MODEL" --editor-model $EDITOR_MODEL \
          --auto-commits --auto-test --yes --suggest-shell-commands \
          --message "${line}" \
          --edit-format diff

        # Stage and commit changes
        #git add "${FILE}"
        #git commit -m "Refactored ${FILE} based on: ${line}"
        
        # Push changes
        git push
        git config --global credential.helper store

        # Optional: Wait for user input before proceeding to the next file
        sleep ${SLEEP_TIME}
        
        # Clean up aider history files
        rm -rf .aider.input.history .aider.chat.history.md .aider.tags.cache.v3
    done <<< "$ARCHITECT_MESSAGE"
done
