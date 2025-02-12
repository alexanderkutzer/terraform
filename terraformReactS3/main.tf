provider "aws" {
    region = var.aws_region
}

resource "aws_s3_bucket" "site" {
    bucket = var.site_name
}

resource "aws_s3_bucket_public_access_block" "site"{
    bucket = aws_s3_bucket.site.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "site"{
    bucket = aws_s3_bucket.site.id

    index_document{
        suffix = "index.html"
    }

    error_document {
        key = "error.html"
    }
}

resource "aws_s3_bucket_ownership_controls" "site" {
    bucket = aws_s3_bucket.site.id 

    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}


resource "aws_s3_bucket_acl" "site" {
    bucket = aws_s3_bucket.site.id 

    acl = "public-read"

    depends_on= [
        aws_s3_bucket_ownership_controls.site,
        aws_s3_bucket_public_access_block.site
    ]
}

resource "aws_s3_bucket_policy" "site" {
    bucket = aws_s3_bucket.site.id

    policy = jsonencode({
        Version="2012-10-17"
        Statement = [{
            Sid = "PiblicReadGetObject"
            Effect = "Allow"
            Principal = "*"
            Action = "s3:GetObject"
            Resource = [
                aws_s3_bucket.site.arn , 
                "${aws_s3_bucket.site.arn}/*"
            ]
        }]

    })

    depends_on = [
        aws_s3_bucket_public_access_block.site
    ]
}

# Automatischer Build der React-App mit Terraform
resource "null_resource" "build_react_app" {
  provisioner "local-exec" {
    command = "cd ${path.module}/react-s3-app && npm install && npm run build"

  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Automatisches Hochladen aller Dateien aus dem React Build-Ordner
resource "aws_s3_object" "react_files" {
  for_each = fileset("${path.module}/react-s3-app/dist", "**/*")

  bucket       = aws_s3_bucket.site.id
  key          = each.value
  source       = "${path.module}/react-s3-app/dist/${each.value}"
  content_type = lookup({
    "html" = "text/html",
    "js"   = "application/javascript",
    "css"  = "text/css",
    "json" = "application/json",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "svg"  = "image/svg+xml",
    "woff" = "font/woff",
    "woff2" = "font/woff2",
    "ttf"  = "font/ttf",
    "eot"  = "application/vnd.ms-fontobject"
  }, regex("\\.([^.]+)$", each.value)[0], "application/octet-stream")

  acl = "public-read"
}