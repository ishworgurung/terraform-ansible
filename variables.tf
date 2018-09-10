variable "ssh_key_private" {
  default     = "~/.ssh/ishwor-aws-tmp"
  description = "Path to the SSH public key for accessing cloud instances"
}

variable "ssh_keyname" {
  default     = "ishwor-aws-tmp"
  description = "Used for AWS keypair"
}

variable "ansible_docker_ssh_key_private" {
  default     = "/root/.ssh/ishwor-aws-tmp"
  description = "Path to the SSH public key for accessing cloud instances within ansible-playbook docker image"
}

variable "aws_region" {
  default = "ap-southeast-2"
}

variable "ami" {
  default = "ami-059b78064586da1b7"
}

variable "instance_type" {
  default = "m5.large"
}

variable "subnet_id" {
  default = "subnet-8b2f5dec"
}
