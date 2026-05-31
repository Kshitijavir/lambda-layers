# Use the official AWS Lambda Python 3.13 image as base
FROM public.ecr.aws/lambda/python:3.13

# Install build dependencies
RUN dnf install -y gcc python3-devel zip && \
    dnf clean all

# Create the layer directory structure
RUN mkdir -p /layer/python

# Install openpyxl into the layer directory
RUN pip install openpyxl -t /layer/python

# Remove unnecessary files to reduce layer size
RUN find /layer -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null; \
    find /layer -name "*.pyc" -delete; \
    find /layer -name "*.pyo" -delete; \
    find /layer -name "*.dist-info" -type d -exec rm -rf {} + 2>/dev/null; \
    find /layer -name "*.egg-info" -type d -exec rm -rf {} + 2>/dev/null

# Create the zip file
RUN cd /layer && zip -r9 /layer.zip .

# Default command to copy the zip to the host
CMD ["cp", "/layer.zip", "/host/openpyxl-layer.zip"]
