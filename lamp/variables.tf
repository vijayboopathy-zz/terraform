variable "region" {
  default = "us-east-1"
}
variable "vpc_name" {
  default = "lamp"
}
variable "cidr" {
  default = "172.40.0.0/16"
}
variable "pub_sub" {
  default = "172.40.2.0/24"
}
variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}
variable "sg_name" {
  default = "lamp-sg"
}
variable "sg_ingress" {
  default = "0.0.0.0/0"
}
variable "ec2_name" {
  default = "lamp-stack"
}
variable "key_name" {
  default = "vibe-aws"
}
variable "private_key_path" {
  default = "/Users/vibe/Dropbox/MyKeyPairs/AWS/vibe-aws.pem"
}
variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
variable "ssh_user" {
  default = "ubuntu"
}
variable "inst_count" {
  default = "2"
}
variable "inst_flavor" {
  default = "t2.micro"
}
