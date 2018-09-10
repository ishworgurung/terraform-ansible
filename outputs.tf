output "nginx_server_ips" {
  value = "${aws_instance.nginx.*.public_ip}"
}