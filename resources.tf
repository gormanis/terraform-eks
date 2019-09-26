#
# Define SSH key pair for our instances
#
resource "aws_key_pair" "default" {
  key_name = "security_keypair-${var.name_of_user}"
  public_key = "${file("${var.key_path}")}"
}


#
# DEPLOY S3 BUCKET FOR THIS PROJECT
#
resource "aws_s3_bucket" "aws_s3_primary_bucket" {
  bucket = "${var.name_of_user}-s3-logs-data-resource"
  acl    = "private"
  tags   = {
	Name        = "${var.name_of_user}-s3-logs-data-resource"
	Owner       = "${var.name_of_user}"
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
