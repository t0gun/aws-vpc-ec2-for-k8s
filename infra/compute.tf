resource "aws_key_pair" "main" {
  key_name   = "bastion-key"
  public_key = var.ssh_public_key
}
####### CREATE INSTANCES
# first bastion
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  owners = ["099720109477"] # canonical
}


resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  subnet_id                   = aws_subnet.public.id
  key_name                    = aws_key_pair.main.key_name
  iam_instance_profile        = aws_iam_instance_profile.ssm.name
  associate_public_ip_address = true
  user_data                   = <<EOF
#!/bin/bash
set -euxo pipefail
snap install amazon-ssm-agent --classic
systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent.service
EOF

  tags = {
    Name = var.instance_name
  }
}


# private instance for k8 nodes 4 Debian 12 book worm that is free in canada ca central 1

data "aws_ami" "debian_amd64" {
  most_recent = true
  owners      = ["136693071363"] # Debian

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "k8s_node" {
  count                       = length(var.k8_node_names)
  ami                         = data.aws_ami.debian_amd64.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.private.id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = false

  tags = {
    Name = var.k8_node_names[count.index]
    Role = "k8s-node"
  }
}

