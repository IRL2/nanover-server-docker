#!/bin/bash
set -e

# Activate conda environment
source /opt/conda/etc/profile.d/conda.sh
conda activate ${CONDA_ENV_NAME}



if [ $# -eq 0 ]; then
    echo "No arguments provided. Starting nanover-omni with default settings..."
    # exec nanover-omni --omm /app/nanover-server-py/tutorials/basics/openmm_files/nanotube.xml
    exec jupyter notebook /app/nanover-server-py/tutorials/basics/getting_started.ipynb --allow-root --ip=0.0.0.0
    # exec nanover-omni --omm /app/nanover-server-py/tutorials/basics/openmm_files/nanotube.xml
else
    echo "Starting nanover-omni with arguments: $@"
    exec nanover-omni "$@"
fi
