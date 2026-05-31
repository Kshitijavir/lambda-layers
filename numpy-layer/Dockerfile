# Use the official AWS Lambda Python 3.12 image as base
# Supports Python 3.10, 3.11, 3.12, and 3.13 runtimes
# Use --platform=linux/arm64 for Graviton (arm64) Lambda functions
# Use --platform=linux/amd64 for x86_64 Lambda functions
FROM --platform=linux/amd64 public.ecr.aws/lambda/python:3.12

# Install build dependencies
RUN dnf install -y gcc gcc-c++ python3-devel zip && \
    dnf clean all

# Create the layer directory structure
RUN mkdir -p /layer/python

# Install only numpy into the layer directory
# Use only pre-built wheels to avoid compiling from source
RUN pip install --only-binary :all: numpy -t /layer/python

# Remove unnecessary files to reduce layer size and avoid import issues
RUN find /layer -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null; \
    find /layer -name "*.pyc" -delete; \
    find /layer -name "*.pyo" -delete; \
    find /layer -path "*/tests/*" -delete 2>/dev/null; \
    find /layer -name "conftest.py" -delete 2>/dev/null; \
    find /layer -name "setup.py" -delete 2>/dev/null; \
    find /layer -name "setup.cfg" -delete 2>/dev/null

# Create the zip file
RUN cd /layer && zip -r9 /layer.zip .

# Default command to copy the zip to the host
CMD ["cp", "/layer.zip", "/host/numpy-layer.zip"]
