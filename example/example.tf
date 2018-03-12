provider "aws" {
  region     = "${var.region}"
}

resource "aws_instance" "example" {
  ami           = "ami-b374d5a5"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "vibes-example-terraform" {
  bucket = "vibes-example-terraform"
  acl    = "private"
  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
  
  tags {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

resource "aws_instance" "example2" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  depends_on    = ["aws_s3_bucket.vibes-example-terraform"]

  provisioner "local-exec" {
    command = "echo ${aws_instance.example2.public_ip} > ip_address.txt"
  }
}
