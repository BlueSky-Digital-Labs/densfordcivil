resource "tls_private_key" "primary-key-pair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "primary-ssh-key" {
  key_name   = "${var.project}-primary"
  public_key = tls_private_key.primary-key-pair.public_key_openssh
}