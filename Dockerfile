# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set environment variables to avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install git, build tools, and the zip utility (defaults to v3.0 on Debian)
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /workspace

# Clone your specific repository and branch
RUN git clone --branch fix_nhood https://github.com/nilchia/squidpy.git

# Set the working directory to the cloned repository
WORKDIR /workspace/squidpy

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install the specific version of anndata requested
RUN pip install --no-cache-dir anndata==0.12.10

# Install the package in editable mode along with testing dependencies
RUN pip install --no-cache-dir -e ".[dev,test]" || pip install --no-cache-dir -e . && pip install pytest

# Set the default command to open a bash shell so you can run your tests
CMD ["/bin/bash"]