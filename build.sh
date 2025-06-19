#!/bin/bash

echo -e "=== NanoVer Server docker image builder ===\n"

# Build the Docker image
build() {
	echo "Building and running NanoVer server..."
	docker build -t nanover-server:latest .
	echo "Docker image built successfully!"
    echo "Build completed. Use './nanover' to start the server."
}

# Function to run with docker-compose
run_compose() {
	echo "Starting with docker-compose..."
	docker-compose up --build
}

build
