#!/bin/bash

# Check and record the versions of Ansible, Aider, Playwright, and Ansible Navigator

# Check and record the version of Ansible
ANSIBLE_VERSION=$(ansible --version)
echo "Ansible version: $ANSIBLE_VERSION" 

# Check and record the version of Aider
AIDER_VERSION=$(aider --version)
echo "Aider version: $AIDER_VERSION" 

# Check and record the version of Playwright
PLAYWRIGHT_VERSION=$(playwright --version)
echo "Playwright version: $PLAYWRIGHT_VERSION" 

# Check and record the version of Ansible Navigator
ANSIBLE_NAVIGATOR_VERSION=$(ansible-navigator --version)
echo "Ansible Navigator version: $ANSIBLE_NAVIGATOR_VERSION" 
