resource "aws_s3_bucket" "sensitive_data" {
  bucket        = "${module.lab.full_name}-sensitive-data"
  force_destroy = true

  tags = merge(module.lab.tags, {
    Name = "${module.lab.full_name}-sensitive-data"
  })
}

resource "aws_s3_bucket_ownership_controls" "sensitive_data" {
  bucket = aws_s3_bucket.sensitive_data.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "sensitive_data" {
  depends_on = [aws_s3_bucket_ownership_controls.sensitive_data]
  bucket     = aws_s3_bucket.sensitive_data.id
  acl        = "private"
}


# Ensure the EC2 instance role has access to the bucket
resource "aws_s3_bucket_policy" "sensitive_data" {
  bucket = aws_s3_bucket.sensitive_data.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowInstanceRoleAccess"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.instance_role.arn
        }
        Action = [
          "s3:*",
        ]
        Resource = [
          aws_s3_bucket.sensitive_data.arn,
          "${aws_s3_bucket.sensitive_data.arn}/*"
        ]
      }
    ]
  })
}
resource "aws_s3_bucket_policy" "admin_access" {
  bucket = aws_s3_bucket.sensitive_data.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowManagementAcxcess"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.arn
        }
        Action = [
          "s3:*",
        ]
        Resource = [
          aws_s3_bucket.sensitive_data.arn,
          "${aws_s3_bucket.sensitive_data.arn}/*"
        ]
      }
    ]
  })
}

# resource "aws_s3_object" "sensitive_data" {
#   bucket = aws_s3_bucket.sensitive_data.id
#   key    = "sensitive-data/"
#   source = "${path.module}/../../../deploy/sensitive-data"
# }
