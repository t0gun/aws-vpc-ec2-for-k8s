variable "region" {
  description = "the region where the vpc would be created"
  type        = string
  default     = "ca-central-1"
}

variable "instance_name" {
  description = "value of the bastion host ec2 instance name"
  type        = string
  default     = "bastion"
}

variable "instance_type" {
  description = "the ec2 instance's type"
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to SSH to the bastion. use _ip/32"
  default     = ["0.0.0.0/0"]
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key here"
}

