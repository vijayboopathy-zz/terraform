output "nginx" {
  value = "${aws_instance.nginx.public_ip}"
}
