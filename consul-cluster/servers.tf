data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# data "template_file" "consul" {
#   template = "${file("${path.module}/files/consul-server.sh")}"
# }

# Create Consul Cluster:
# Create the consul server
resource "aws_instance" "consul_server" {
  count                       = var.consul_server_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.consul-join.name
  vpc_security_group_ids      = [aws_security_group.opsschool_consul.id]
  key_name                    = aws_key_pair.consul_key.key_name # var.key_name  
  user_data                   = file("${path.module}/files/consul-server.sh")
  
  
  tags = {
    Name        = "consul-${count.index + 1}"
    consul_server = "true"
  }

  connection {
      type         = "ssh"
      host         = self.public_ip
      user         = "ubuntu"
      private_key  = tls_private_key.consul_key.private_key_pem
      # file(var.private_key_path)
  }

  #   provisioner "file" {
  #   source      = "consul.pem"
  #   destination = "/tmp/consul.pem"
  # }
 
}

# creating consul client server with apache
resource "aws_instance" "consul_apache" { 
  count                       = var.consul_apache_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.consul-join.name
  vpc_security_group_ids      = [aws_security_group.opsschool_consul.id]
  key_name                    = aws_key_pair.consul_key.key_name
  user_data                   = file("${path.module}/files/consul-agent.sh") 

  tags = {
    Name = "apache-webserver"
    # consul_server = "true"
  }

  connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = tls_private_key.consul_key.private_key_pem # file(var.private_key_path)
  }

    provisioner "remote-exec" {
     inline = [
       "sudo apt-get update",
       "sudo apt-get install apache2 -y",
       "sudo systemctl enable apache2",
       "sudo systemctl start apache2",
       "sudo chmod 777 /var/www/html/index.html"
     ]
   }
    
}

