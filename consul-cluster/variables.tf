variable "aws_access_key" {
    default = ""
    
}
variable "aws_secret_key" {
    default = ""
}
# variable "private_key_path" {
#   default = "C:\\Users\\yael\\Documents\\DevOps Engineering Course\\Key Pairs\\opsconsul.pem"
# }
# variable "key_name" {
#     default = "opsconsul"
# }
variable "region" {
  default = "us-east-1"
}
variable "availability_zones" {
  default = "us-east-1a" # [, "us-east-1b"]
  # type = "list"
}
variable "consul_server_count" {
  default = 3
}
variable "consul_apache_count" {
  default = 1
}
variable "instance_type" {
  default = "t2.micro"
}


