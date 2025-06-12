# Use mambaforge as base image for faster conda operations
FROM condaforge/mambaforge:latest

# Set working directory
WORKDIR /app

# Set environment variables
ENV CONDA_ENV_NAME=nanover
ENV PATH=/opt/conda/envs/${CONDA_ENV_NAME}/bin:$PATH

# Update conda and install mamba for faster package resolution
RUN conda update -n base -c defaults conda && \
    conda install -n base -c conda-forge mamba

# Create conda environment and install nanover-server first
RUN mamba create -n ${CONDA_ENV_NAME} -c irl -c conda-forge \
    nanover-server \
    python=3.11 \
    -y && \
    conda clean -afy

RUN git clone https://github.com/IRL2/nanover-server-py.git

# Make sure the environment is activated by default
RUN echo "conda activate ${CONDA_ENV_NAME}" >> ~/.bashrc


# Shell entry
SHELL ["/bin/bash", "--login", "-c"]

# Run entrypoint script
ADD entryp.sh /
RUN chmod +x /entryp.sh

# Create entrypoint script
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'set -e' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo '# Activate conda environment' >> /entrypoint.sh && \
    echo 'source /opt/conda/etc/profile.d/conda.sh' >> /entrypoint.sh && \
    echo 'conda activate ${CONDA_ENV_NAME}' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo '# Check if arguments are provided' >> /entrypoint.sh && \
    echo 'if [ $# -eq 0 ]; then' >> /entrypoint.sh && \
    echo '    echo "No arguments provided. Starting nanover-omni with default settings..."' >> /entrypoint.sh && \
    echo '    exec nanover-omni --omm nanover-server-py/tutorials/basics/openmm_files/nanotube.xml' >> /entrypoint.sh && \
    echo 'else' >> /entrypoint.sh && \
    echo '    echo "Starting nanover-omni with arguments: $@"' >> /entrypoint.sh && \
    echo '    exec nanover-omni "$@"' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Expose common ports (adjust as needed for your server)
EXPOSE 8888 38801 38802 38803 54545

# Set the entrypoint
ENTRYPOINT ["/entryp.sh"]

# Default command (can be overridden)
CMD []
