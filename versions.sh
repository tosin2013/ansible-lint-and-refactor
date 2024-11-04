#!/bin/bash

# Check and record the versions of Ansible, Aider, Playwright, and Ansible Navigator

# Check and record the version of Ansible
ANSIBLE_VERSION=$(ansible --version | grep -oP '(?<=ansible \[)\d+\.\d+\.\d+(?=\])')
echo "Ansible version: $ANSIBLE_VERSION" >> versions.txt

# Check and record the version of Aider
AIDER_VERSION=$(aider --version | grep -oP '(?<=Aider version )\d+\.\d+\.\d+(?=\))')
echo "Aider version: $AIDER_VERSION" >> versions.txt

# Check and record the version of Playwright
PLAYWRIGHT_VERSION=$(playwright --version | grep -oP '(?<=Playwright )\d+\.\d+\.\d+(?=\))')
echo "Playwright version: $PLAYWRIGHT_VERSION" >> versions.txt

# Check and record the version of Ansible Navigator
ANSIBLE_NAVIGATOR_VERSION=$(ansible-navigator --version | grep -oP '(?<=ansible-navigator )\d+\.\d+\.\d+(?=\))')
echo "Ansible Navigator version: $ANSIBLE_NAVIGATOR_VERSION" >> versions.txt
