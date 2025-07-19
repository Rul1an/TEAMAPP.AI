# Brotli Encoding for CloudFront (VEO-154)

This document explains how we serve *Brotli*-compressed Flutter-web assets via **Amazon CloudFront**.

## 1 – Build & Compress

```bash
flutter build web --release --dart-define=FLUTTER_WEB_AUTO_DETECT=false
./scripts/brotli_encode_assets.sh build/web
```

The helper script:
* Finds compressible types (*.js, *.css, *.html, *.json, *.wasm, *.svg, *.ico*)
* Runs `brotli --best --keep --force …`
* Creates `*.br` files alongside originals — e.g. `main.dart.js → main.dart.js.br`

## 2 – Deploy to S3

Upload the **original files + .br corpus** to the designated S3 bucket:

```bash
aws s3 sync build/web s3://$S3_BUCKET/ --delete --content-type mime/type --content-encoding ""
```

> *Leave* the `Content-Encoding` header empty during upload — we let CloudFront set it via behaviour rules.

## 3 – CloudFront Behaviour Configuration

1. **Compress Objects Automatically = ON** (CloudFront now supports Brotli since 2024-12).
2. **AddResponseHeadersPolicy** – Attach `Content-Encoding: br` when viewer supports Brotli *and* `.br` variant exists.
3. **Viewer Policy:** `gzip, br, zstd` (future proof).

Terraform snippet:
```hcl
resource "aws_cloudfront_response_headers_policy" "brotli" {
  name = "brotli-encoding-2025"

  compression_config {
    compression = ["br", "gzip"]
    content_types = [
      "application/javascript",
      "text/css",
      "text/html",
      "application/json",
      "application/wasm"
    ]
  }
}

resource "aws_cloudfront_distribution" "web" {
  # …
  default_cache_behavior {
    response_headers_policy_id = aws_cloudfront_response_headers_policy.brotli.id
    # …
  }
}
```

## 4 – Validation

```bash
curl -H "Accept-Encoding: br" -I https://app.example.com/main.dart.js
# Expect: Content-Encoding: br
```

Grafana panels `CDN > Compression Ratio` & `CDN > Bytes Saved` should reflect ~14 % median save after rollout.

---

*Change owner:* Omar • **ETA:** ≤ ½ day