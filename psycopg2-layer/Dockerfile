# Use the official AWS Lambda Python 3.10 image as base
# Supports Python 3.10, 3.11, 3.12, and 3.13 runtimes
# Use --platform=linux/arm64 for Graviton (arm64) Lambda functions
# Use --platform=linux/amd64 for x86_64 Lambda functions
FROM --platform=linux/amd64 public.ecr.aws/lambda/python:3.11

# Install build dependencies
RUN yum install -y gcc postgresql-devel python3-devel zip && \
    yum clean all

# Create the layer directory structure
RUN mkdir -p /layer/python

# Install psycopg2-binary into the layer directory
RUN pip install psycopg2-binary -t /layer/python

# Remove unnecessary files to reduce layer size
RUN find /layer -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null; \
    find /layer -name "*.pyc" -delete; \
    find /layer -name "*.pyo" -delete

# Create the zip file
RUN cd /layer && zip -r9 /layer.zip .

# Default command to copy the zip to the host
CMD ["cp", "/layer.zip", "/host/layer.zip"]
