# Build script for numpy Lambda Layer
# Run this in PowerShell

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$LayerZip = Join-Path $ProjectRoot "numpy-layer.zip"

Write-Host "=== Building numpy Lambda Layer ===" -ForegroundColor Cyan

# Step 1: Build the Docker image
Write-Host "[1/3] Building Docker image..." -ForegroundColor Yellow
docker build -t numpy-layer-builder -f "$ProjectRoot\Dockerfile" "$ProjectRoot"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker build failed!" -ForegroundColor Red
    exit 1
}

# Step 2: Run the container to generate the zip
Write-Host "[2/3] Running container to generate layer zip..." -ForegroundColor Yellow
docker run --rm --entrypoint sh -v "${ProjectRoot}:/host" numpy-layer-builder -c "cp /layer.zip /host/numpy-layer.zip"

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
    Write-Host "`nTop-level contents of the zip:" -ForegroundColor Cyan
    & docker run --rm --entrypoint sh -v "${ProjectRoot}:/host" numpy-layer-builder -c "unzip -l /host/numpy-layer.zip | head -20"
} else {
    Write-Host "FAILED: Layer zip not found!" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== Done ===" -ForegroundColor Cyan
Write-Host "You can now upload 'numpy-layer.zip' to AWS Lambda as a layer." -ForegroundColor Green
