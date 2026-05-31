import json
import sys
import numpy as np


def lambda_handler(event, context):
    results = []

    # =============================================
    # 1. Test numpy
    # =============================================
    arr = np.array([1, 2, 3, 4, 5])
    matrix = np.ones((3, 3))
    results.append({
        "layer": "numpy",
        "status": "✅ OK",
        "version": np.__version__,
        "info": f"Array mean={arr.mean():.1f}, matrix={matrix.shape}"
    })
    print("[LAYER TEST] numpy ✅ - Version:", np.__version__)

    # =============================================
    # Summary
    # =============================================
    passed = sum(1 for r in results if r["status"] == "✅ OK")
    failed = sum(1 for r in results if r["status"] == "❌ FAIL")
    total = len(results)

    print("\n" + "=" * 50)
    print(f"LAYER TEST SUMMARY: {passed}/{total} passed, {failed} failed")
    print("=" * 50)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "python_version": sys.version,
            "total_layers": total,
            "passed": passed,
            "failed": failed,
            "results": results
        }, indent=2)
    }
