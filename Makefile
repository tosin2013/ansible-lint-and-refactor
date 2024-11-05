# Makefile for building, testing, and running the Docker image

# Docker image name
IMAGE_NAME := ansible-lint-and-refactor

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

# Run the Docker container
run:
	docker run -it --rm $(IMAGE_NAME) /bin/bash

# Run a health check on the Docker container
test:
	docker run --rm $(IMAGE_NAME) ansible --version

# Run ansible-lint
lint:
	docker run --rm $(IMAGE_NAME) ansible-lint

# Run ansible-navigator
navigator:
	docker run --rm -v $(PWD):/ansible $(IMAGE_NAME) ansible-navigator

# Run molecule tests
molecule-test:
	docker run --rm -v $(PWD):/ansible $(IMAGE_NAME) molecule test

aider-test:
	docker run --rm -v $(PWD):/ansible $(IMAGE_NAME) aider --help

get-versions:
	docker run --rm -v $(PWD):/ansible $(IMAGE_NAME) versions.sh | tee versions.txt

# Push the Docker image to a registry (assuming you have logged in)
push:
	docker push $(IMAGE_NAME)

# Clean up Docker images and containers
clean:
	docker rmi $(IMAGE_NAME)

prune:
	docker system prune -f

.PHONY: build run test lint navigator molecule-test push clean
