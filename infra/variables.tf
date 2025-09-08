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
  default     = "t3.small"
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


variable "k8_node_names" {
  type        = list(string)
  description = "private ec2 node names for k8s"
  default     = ["k8s-node-1", "k8-nodes-2", "k8s-node-3", "k8s-node-4"]
}