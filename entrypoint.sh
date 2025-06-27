#!/bin/bash
set -e

# Activate conda environment
source /opt/conda/etc/profile.d/conda.sh
conda activate ${CONDA_ENV_NAME:-nanover}

# Function to show help
show_help() {
    echo "NanoVer Server Docker Container"
    echo "Usage: $0 [command] [options...]"
    echo ""
    echo "Commands:"
    echo "  demo                          Run nanover server with demo nanotube simulation"
    echo "  omni [args...]               Run nanover-omni with specified OpenMM XML files"
    echo "  notebook                      Run Jupyter notebook server with tutorials"
    echo "  notebook --path <path>        Run Jupyter notebook server from the /data path"
    # echo "  shell                         Start interactive bash shell"
    echo "  help                          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 demo"
    echo "  $0 omni --omm ./data/simulation1.xml ./data/simulation2.xml"
    echo "  $0 notebook"
    echo "  $0 notebook --path ./data/my_notebooks/"
    # echo "  $0 shell"
    echo ""
    echo "Default behavior (no arguments): Start demo"
    echo ""
    echo "Available nanover commands:"
    ls -1 /opt/conda/envs/${CONDA_ENV_NAME:-nanover}/bin/nanover* 2>/dev/null || echo "  (none found - check installation)"
}

# Function to run demo simulation
run_demo() {
    echo "Starting NanoVer server with demo nanotube simulation..."
    echo "Command: nanover-omni --omm /app/nanover-server-py/tutorials/basics/openmm_files/nanotube.xml"
    
    # Check if demo file exists
    DEMO_FILE1="/app/nanover-server-py/tutorials/basics/openmm_files/nanotube.xml"
    DEMO_FILE2="/app/nanover-server-py/tutorials/openmm/openmm_files/17-ala.xml"
    if [[ ! -f "$DEMO_FILE1" || ! -f "$DEMO_FILE2" ]]; then
        echo "Warning: Demo file not found at $DEMO_FILE1 or $DEMO_FILE2"
        echo "You may need to provide your own simulation files in /data/"
        echo "Falling back to shell..."
        exec bash
    else
        exec nanover-omni --omm "$DEMO_FILE1" "$DEMO_FILE2"
    fi
}

# Function to run nanover-omni with custom files
run_omni() {
    echo "Starting nanover-omni with provided arguments..."
    
    # Skip the 'omni' command itself
    shift
    
    if [ $# -eq 0 ]; then
        echo "Error: No files provided for omni command"
        echo "Usage: omni --omm <file1.xml> [file2.xml] [...]"
        echo "Example: omni --omm ./data/simulation.xml"
        exit 1
    fi
    
    echo "Command: nanover-omni $@"
    
    # Validate that files exist if they're local paths
    for arg in "$@"; do
        if [[ "$arg" == *.xml ]] && [[ "$arg" == /* ]] && [ ! -f "$arg" ]; then
            echo "Warning: File not found: $arg"
        fi
    done
    
    exec nanover-omni "$@"
}

# Function to run Jupyter notebook
run_notebook() {
    echo "Starting Jupyter notebook server..."
    
    # Check if jupyter is available
    if ! command -v jupyter &> /dev/null; then
        echo "Error: Jupyter not found. Installing..."
        conda install -n ${CONDA_ENV_NAME:-nanover} -c conda-forge jupyter -y
    fi
    
    # Parse arguments
    NOTEBOOK_PATH="/app/nanover-server-py/tutorials/"
    
    while [[ $# -gt 1 ]]; do
        case $1 in
            --path)
                NOTEBOOK_PATH="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                echo "Usage: notebook [--path <custom_path>]"
                exit 1
                ;;
        esac
    done
    
    # Check if path exists
    if [ ! -d "$NOTEBOOK_PATH" ]; then
        echo "Warning: Notebook path not found: $NOTEBOOK_PATH"
        echo "Creating directory or using /app as fallback..."
        
        if [[ "$NOTEBOOK_PATH" == /data/* ]]; then
            mkdir -p "$NOTEBOOK_PATH"
        else
            NOTEBOOK_PATH="/app"
        fi
    fi
    
    echo "Starting Jupyter notebook server at: $NOTEBOOK_PATH"
    echo "Access at: http://localhost:8888 (or your host IP)"
    echo "Command: jupyter notebook $NOTEBOOK_PATH --allow-root --ip=0.0.0.0 --port=8888 --no-browser"
    
    exec jupyter notebook "$NOTEBOOK_PATH" \
        --allow-root \
        --ip=0.0.0.0 \
        --port=8888 \
        --no-browser \
        --NotebookApp.token='' \
        --NotebookApp.password=''
}

# Main command processing
case "${1:-}" in
    "demo")
        run_demo
        ;;
    "omni")
        run_omni "$@"
        ;;
    "notebook")
        shift
        run_notebook "$@"
        ;;
    "shell")
        echo "Starting interactive shell..."
        echo "NanoVer environment activated: ${CONDA_ENV_NAME:-nanover}"
        echo "Available commands:"
        ls -1 /opt/conda/envs/${CONDA_ENV_NAME:-nanover}/bin/nanover* 2>/dev/null || echo "  (run 'conda list | grep nanover' to see installed packages)"
        exec bash
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    "")
        echo "No command provided. Starting demo..."
#        echo "Use '$0 help' to see available commands."
#        echo ""
#        show_help
#        echo ""
#        exec bash
        run_demo
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use '$0 help' to see available commands."
        echo ""
        echo "Attempting to run as direct command: $@"
        exec "$@"
        ;;
esac
