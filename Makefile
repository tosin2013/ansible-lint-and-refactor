# Makefile for building, testing, and running the Docker image

# Docker image name
IMAGE_NAME := ubuntu2410-ansible

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

# Run the Docker container
run:
	docker run -it --rm $(IMAGE_NAME)

# Run a health check on the Docker container
test:
	docker run --rm $(IMAGE_NAME) ansible --version

# Push the Docker image to a registry (assuming you have logged in)
push:
	docker push $(IMAGE_NAME)

# Clean up Docker images and containers
clean:
	docker rmi $(IMAGE_NAME)

.PHONY: build run test push clean
