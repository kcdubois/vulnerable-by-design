resource "aws_s3_bucket" "backup" {
    bucket = "${var.bucket_prefix}-backup"

    tags = {
        Project = random_string.project.result
    }
}

data "aws_iam_policy_document" "database_bucket_policy" {
  statement {
    sid = "1"

    actions = [
        "s3:PutObject"
    ]

    principals {
        type = "AWS"
        identifiers = [aws_iam_role.database_role.arn]
    }

    resources = [ "arn:aws:s3:::${aws_s3_bucket.backup.bucket}/*" ]
  }

  statement {
    sid = "2"

    actions = [
        "s3:GetObject"
    ]

    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }

    resources = [ "arn:aws:s3:::${aws_s3_bucket.backup.bucket}/*" ]
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.backup.bucket
  policy = data.aws_iam_policy_document.database_bucket_policy.json
}
