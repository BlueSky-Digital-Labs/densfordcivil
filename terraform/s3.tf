# locals {  
#   s3_bucket_names = ["${var.project}-prod"]
# }

# resource "aws_s3_bucket" "this" {
#   count         = length(local.s3_bucket_names) // count will be 3
#   bucket        = local.s3_bucket_names[count.index]
# }

# resource "aws_s3_bucket_public_access_block" "this" {
#   count=length(local.s3_bucket_names)
#   bucket = aws_s3_bucket.this[count.index].id
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_ownership_controls" "this" {
#   count=length(local.s3_bucket_names)
#   bucket = aws_s3_bucket.this[count.index].id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "this" {
#   depends_on = [
#     aws_s3_bucket_public_access_block.this,
#   	aws_s3_bucket_ownership_controls.this,
#   ]

#   count=length(local.s3_bucket_names)
#   bucket = aws_s3_bucket.this[count.index].id
#   acl    = "public-read"
# }

# resource "aws_s3_bucket_policy" "this" {
#   count=length(local.s3_bucket_names)
#   bucket = aws_s3_bucket.this[count.index].id
#   policy =<<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "PublicReadGetObject",
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "s3:GetObject",
#       "Resource": "${aws_s3_bucket.this[count.index].arn}/*"
#     }
#   ]
# }
# POLICY
# }

# data "aws_iam_policy_document" "this" {
#   count  = length(local.s3_bucket_names)
#   statement {
#     effect  = "Allow"
#     actions = ["s3:*"]
#     resources = [
#       aws_s3_bucket.this[count.index].arn,
#       "${aws_s3_bucket.this[count.index].arn}/*",
#     ]
#   }
# }

# resource "aws_iam_user_policy" "this" {
#   count  = length(local.s3_bucket_names)
#   name   = "${local.s3_bucket_names[count.index]}-s3"
#   user   = "district-s3"
#   policy = data.aws_iam_policy_document.this[count.index].json
# }

# resource "aws_iam_user" "this" {
#   name = "${var.project}-s3"

#   tags = {
#     ClientName = var.project_name
#     Project    = var.project_name
#     Terraform  = "YES"
#     CreatedBy  = "Reece"
#   }
# }