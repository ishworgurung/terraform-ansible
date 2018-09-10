provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "nginx" {
  vpc_id = "vpc-013c8e66"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access for provisioning"
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access to nginx server"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${aws_security_group.nginx.id}"]
  key_name                    = "${var.ssh_keyname}"
  associate_public_ip_address = true
  count                       = 2

  tags {
    Name = "nginx-${count.index}"
  }

  provisioner "remote-exec" {
    # install ansible dep or more..
    inline = ["sudo apt-get -y install python"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.ssh_key_private)}"
    }
  }

  provisioner "local-exec" {
    # run provisioner playbook
    command = <<HD
      echo "Running provisioner" && sleep 2;      
      docker run --rm \
        -v $(pwd):/ansible/playbooks \
        -v ~/.ssh:/root/.ssh \
        ansible-playbook:latest -vv -i '${self.public_ip},' \
        --private-key ${var.ansible_docker_ssh_key_private} -T 300 provision.yml;
HD
  }

  provisioner "local-exec" {
    # run site playbook
    command = <<HD
      echo "Running site playbook" && sleep 2;
      docker run --rm \
        -v $(pwd):/ansible/playbooks \
        -v ~/.ssh:/root/.ssh \
        ansible-playbook:latest -vv -i '${self.public_ip},' \
        --private-key ${var.ansible_docker_ssh_key_private} -T 300 site.yml
HD
  }

  provisioner "local-exec" {
    # run basic curl check
    command = <<HD
      echo "Running nginx site checks using cURL";
      curl -o/dev/null -s http://${self.public_ip}:80 && echo "nginx is up on ${self.public_ip}:80"
HD
  }
}
