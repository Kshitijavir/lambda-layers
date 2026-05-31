# Use the official AWS Lambda Python 3.11 image as base
# Supports Python 3.10, 3.11, 3.12, and 3.13 runtimes
FROM --platform=linux/amd64 public.ecr.aws/lambda/python:3.11

# Install build dependencies
RUN yum install -y gcc gcc-c++ python3-devel zip && \
    yum clean all

# Create the layer directory structure
RUN mkdir -p /layer/python

# Install pandas into the layer directory
# Use only pre-built wheels to avoid compiling from source
RUN pip install --only-binary :all: pandas -t /layer/python && \
    # Remove numpy from this layer since it has its own separate layer
    rm -rf /layer/python/numpy /layer/python/numpy.libs /layer/python/numpy-*.dist-info

# Remove unnecessary files to reduce layer size
RUN find /layer -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null; \
    find /layer -name "*.pyc" -delete; \
    find /layer -name "*.pyo" -delete

# Create the zip file
RUN cd /layer && zip -r9 /layer.zip .

# Default command to copy the zip to the host
CMD ["cp", "/layer.zip", "/host/pandas-layer.zip"]
