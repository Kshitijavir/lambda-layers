# AWS Lambda Layers

Collection of custom AWS Lambda layers for Python runtimes.

## Layers

| Layer | Description | Build |
|---|---|---|
| `numpy-layer` | NumPy library | `numpy-layer/build.ps1` |
| `pandas-layer` | Pandas library (requires numpy layer) | `pandas-layer/build.ps1` |
| `psycopg2-layer` | PostgreSQL adapter | `psycopg2-layer/build.ps1` |
| `openpyxl-layer` | Excel file reader/writer | `openpyxl-layer/build.ps1` |
| `requests-layer` | HTTP library | `requests-layer/build.ps1` |
| `xlsxwriter-layer` | Excel file writer | `xlsxwriter-layer/build.ps1` |
| `layer` | Generic layer (psycopg2) | `layer/build.ps1` |

## Build Instructions

Each layer has a `Dockerfile` and a `build.ps1` script. To build a layer:

```powershell
cd <layer-name>
.\build.ps1
```

This will generate a `<layer-name>.zip` file that can be uploaded to AWS Lambda as a layer.

## Lambda Layer Limits

- Maximum **5 layers** per Lambda function
- Each layer must specify compatible runtimes and architectures

## Test Files

- `test_lambda_layers.py` — Tests all layers together (psycopg2, pandas, openpyxl, requests, xlsxwriter)
- `test_numpy_layer.py` — Tests numpy layer separately
