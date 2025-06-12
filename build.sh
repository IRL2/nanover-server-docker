#!/bin/bash

# build.sh - Build and run the NanoVer Docker container

set -e

echo "Building NanoVer Docker image..."

# Build the Docker image
docker build -t nanover-server:latest .

echo "Docker image built successfully!"

# Create necessary directories
mkdir -p data config output

echo "Created directories: data, config, output"

# Function to run the container
run_container() {
    echo "Starting NanoVer server container..."
    
    if [ $# -eq 0 ]; then
        echo "No arguments provided - starting with default settings"
        docker run -it --rm \
            -p 0.0.0.0:8080:8080 \
            -p 0.0.0.0:38801:38801 \
            -p 0.0.0.0:38802:38802 \
            -p 0.0.0.0:54545:54545 \
            -v $(pwd)/data:/app/data \
            -v $(pwd)/config:/app/config \
            -v $(pwd)/output:/app/output \
            nanover-server:latest
    else
        echo "Starting with arguments: $@"
        docker run -it --rm \
            -p 0.0.0.0:8080:8080 \
            -p 0.0.0.0:38801:38801 \
            -p 0.0.0.0:38802:38802 \
            -p 0.0.0.0:54545:54545 \
            -v $(pwd)/data:/app/data \
            -v $(pwd)/config:/app/config \
            -v $(pwd)/output:/app/output \
            nanover-server:latest "$@"
    fi
}

# Function to run interactive shell in container
run_shell() {
    echo "Starting interactive shell in NanoVer container..."
    docker run -it --rm \
        -p 0.0.0.0:8080:8080 \
        -p 0.0.0.0:38801:38801 \
        -p 0.0.0.0:38802:38802 \
        -p 0.0.0.0:54545:54545 \
        -v $(pwd)/data:/app/data \
        -v $(pwd)/config:/app/config \
        -v $(pwd)/output:/app/output \
        --entrypoint /bin/bash \
        nanover-server:latest
}

# Function to run with docker-compose
run_compose() {
    echo "Starting with docker-compose..."
    docker-compose up --build
}

# Parse command line arguments
case "${1:-}" in
    "build")
        echo "Build completed. Use './build.sh run' to start the server."
        ;;
    "run")
        shift
        run_container "$@"
        ;;
    "shell")
        run_shell
        ;;
    "compose")
        run_compose
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [command] [args...]"
        echo ""
        echo "Commands:"
        echo "  build           Build the Docker image only"
        echo "  run [args...]   Run the NanoVer server with optional arguments"
        echo "  shell           Start an interactive shell in the container"
        echo "  compose         Start using docker-compose"
        echo "  help            Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 build"
        echo "  $0 run"
        echo "  $0 run --config /app/config/my-config.conf"
        echo "  $0 run --data-dir /app/data --port 8080"
        echo "  $0 shell"
        echo "  $0 compose"
        ;;
    *)
        echo "Building and running NanoVer server..."
        run_container "$@"
        ;;
esac
