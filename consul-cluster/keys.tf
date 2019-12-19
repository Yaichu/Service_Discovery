resource "tls_private_key" "consul_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "consul_key" {
  key_name   = "consul_key"
  public_key = "${tls_private_key.consul_key.public_key_openssh}"
}

resource "local_file" "consul_key" {
  sensitive_content  = "${tls_private_key.consul_key.private_key_pem}"
  filename           = "consul.pem"
}