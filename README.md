# AWS Lambda Layers

Collection of custom AWS Lambda layers for Python runtimes (3.10 – 3.13).

## Layers Overview

| Layer | Description | Size | Depends On |
|---|---|---|---|
| `numpy-layer` | NumPy library | ~14 MB | None |
| `pandas-layer` | Pandas library | ~11 MB | `numpy-layer` |
| `psycopg2-layer` | PostgreSQL adapter (psycopg2-binary) | ~4 MB | None |
| `openpyxl-layer` | Excel file reader/writer | ~7 MB | None |
| `requests-layer` | HTTP library | ~1 MB | None |
| `xlsxwriter-layer` | Excel file writer | ~2 MB | None |

---

## How to Build a Layer

Each layer has a `Dockerfile` and a `build.ps1` script.

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- PowerShell

### Build Steps

```powershell
cd <layer-name>
.\build.ps1
```

This will generate a `<layer-name>.zip` file ready for AWS Lambda.

---

## How to Upload to AWS Lambda

### Step 1: Create a Layer

1. Go to **AWS Console → Lambda → Layers → Create layer**
2. **Name**: e.g. `numpy-layer`
3. **Upload** the `.zip` file
4. **Compatible architectures**: Select **x86_64**
5. **Compatible runtimes**: Select **all** of these:
   - ✅ Python 3.10
   - ✅ Python 3.11
   - ✅ Python 3.12
   - ✅ Python 3.13
6. Click **Create**

### Step 2: Attach Layer to Lambda Function

1. Go to your **Lambda function → Configuration → Layers**
2. Click **Add a layer**
3. Select **Custom layers** → Choose your layer → Choose the version
4. Click **Add**

### Layer Order (Important!)

When using multiple layers, attach them in this order:

| Order | Layer | Reason |
|---|---|---|
| 1st | `numpy-layer` | Must load first (pandas depends on it) |
| 2nd | `pandas-layer` | Depends on numpy |
| 3rd+ | Any other layer | No dependency order |

> ⚠️ **Lambda limit**: Maximum **5 layers** per function.

---

## Build Notes

### Python Version Compatibility

All layers are built using the **Python 3.12** base image, which produces `.so` binaries compatible with Python 3.10, 3.11, 3.12, and 3.13 on AWS Lambda.

If you need to target a different Python version, edit the `FROM` line in the `Dockerfile`:

```dockerfile
FROM --platform=linux/amd64 public.ecr.aws/lambda/python:3.12
```

Change `3.12` to your desired version (e.g. `3.10`, `3.11`, `3.13`).

### Architecture

- **x86_64** — Use `--platform=linux/amd64` (default)
- **arm64** (Graviton) — Change to `--platform=linux/arm64`

---

## Test Files

| File | Description |
|---|---|
| `test_lambda_layers.py` | Tests all 5 layers together (psycopg2, pandas, openpyxl, requests, xlsxwriter) |
| `test_numpy_layer.py` | Tests numpy layer separately |

Upload the test file as your Lambda function code (set handler to `lambda_function.lambda_handler`) and invoke it to verify all layers work correctly.
