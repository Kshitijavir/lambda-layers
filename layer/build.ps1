# Build script for psycopg2 Lambda Layer
# Run this in PowerShell

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$LayerZip = Join-Path $ProjectRoot "psycopg2-layer.zip"

Write-Host "=== Building psycopg2 Lambda Layer ===" -ForegroundColor Cyan

# Step 1: Build the Docker image
Write-Host "[1/3] Building Docker image..." -ForegroundColor Yellow
docker build -t psycopg2-layer-builder -f "$ProjectRoot\Dockerfile" "$ProjectRoot"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker build failed!" -ForegroundColor Red
    exit 1
}

# Step 2: Run the container to generate the zip
Write-Host "[2/3] Running container to generate layer zip..." -ForegroundColor Yellow
docker run --rm -v "${ProjectRoot}:/host" psycopg2-layer-builder cp /layer.zip /host/psycopg2-layer.zip

if ($LASTEXITCODE -ne 0) {
    Write-Host "Container run failed!" -ForegroundColor Red
    exit 1
}

# Step 3: Verify the zip
Write-Host "[3/3] Verifying the layer zip..." -ForegroundColor Yellow
if (Test-Path $LayerZip) {
    $Size = (Get-Item $LayerZip).Length / 1MB
    Write-Host "SUCCESS! Layer zip created: $LayerZip" -ForegroundColor Green
    Write-Host "Size: $([math]::Round($Size, 2)) MB" -ForegroundColor Green

    # Show contents
    Write-Host "`nContents of the zip:" -ForegroundColor Cyan
    & docker run --rm -v "${ProjectRoot}:/host" --entrypoint "" public.ecr.aws/lambda/python:3.13 sh -c "unzip -l /host/psycopg2-layer.zip | head -30"
} else {
    Write-Host "FAILED: Layer zip not found!" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== Done ===" -ForegroundColor Cyan
Write-Host "You can now upload 'psycopg2-layer.zip' to AWS Lambda as a layer." -ForegroundColor Green
