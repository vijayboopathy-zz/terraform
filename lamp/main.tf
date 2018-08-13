provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "lamp-stack" {
  cidr_block = "${var.cidr}"
}

resource "aws_internet_gateway" "lamp-igw" {
  vpc_id = "${aws_vpc.lamp-stack.id}"
}

resource "aws_route" "lamp-rt" {
  route_table_id         = "${aws_vpc.lamp-stack.main_route_table_id}"
  destination_cidr_block = "${var.sg_ingress}"
  gateway_id             = "${aws_internet_gateway.lamp-igw.id}"
}

resource "aws_subnet" "pub-sub01" {
  vpc_id     = "${aws_vpc.lamp-stack.id}"
  cidr_block = "${var.pub_sub}"
}

resource "aws_security_group" "lamp-all" {
  name        = "${var.sg_name}"
  description = "This SG has open internet. Not recommended for production use"
  vpc_id      = "${aws_vpc.lamp-stack.id}"

  # inbound
  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = -1
    cidr_blocks = ["${var.sg_ingress}"]
  }
  # outbound
  egress {
    from_port  = 0
    to_port    = 0
    protocol   = -1
    cidr_blocks = ["${var.sg_ingress}"]
  }
}

resource "aws_instance" "nginx" {
  # connection details
  connection {
    user        = "${var.ssh_user}"
    private_key = "${file("${var.private_key_path}")}"
    timeout     = "30s"
  }

  # core details
  instance_type               = "${var.inst_flavor}"
  ami                         = "ami-66506c1c"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.lamp-all.id}"]
  subnet_id                   = "${aws_subnet.pub-sub01.id}"

  # user-data
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx mysql-client -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}

resource "aws_instance" "mysql" {
  # connection details
  connection {
    user        = "${var.ssh_user}"
    private_key = "${file("${var.private_key_path}")}"
    timeout     = "30s"
  }

  # core details
  instance_type               = "${var.inst_flavor}"
  ami                         = "ami-66506c1c"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.lamp-all.id}"]
  subnet_id                   = "${aws_subnet.pub-sub01.id}"

  # user-data
  provisioner "file" {
     source      = "mysql.sh"
     destination = "/tmp/mysql.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/mysql.sh",
      "/tmp/mysql.sh",
    ]
  }
}
