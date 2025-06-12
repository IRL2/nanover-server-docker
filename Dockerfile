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
ADD entrypoint.sh /app
RUN chmod +x /app/entrypoint.sh

# Expose common ports (adjust as needed for your server)
EXPOSE 8888 38801 38802 38803 54545

# Set the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

# Default command (can be overridden)
CMD []
