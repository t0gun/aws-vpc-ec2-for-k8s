# Kubernetes the Hard Way Infrastructure Automation

This repo provisions the AWS network and compute needed to help you run [Kelsey Hightower’s *Kubernetes The Hard Way*](https://github.com/kelseyhightower/kubernetes-the-hard-way). It only spins up the infrastructure and does not install the cluster or any packages.

## What this repo provisions
- VPC with single AZ with one public and one private subnet
- Internet Gateway for public subnet egress
- Elastic IP and  NAT Gateway for  private subnet egress
- Route tables and its associations for public/private subnets
- Security Groups:
    - bastion-sg: SSH ingress from `allowed_ssh_cidrs`; egress 80/443; SSH to VPC
    - private-sg: SSH only from bastion; intra-SG traffic allowed; egress 80/443
- Bastion EC2 Ubuntu 24.04 in the public subnet, public IP, with SSM agent installed via `user_data`
- IAM role + instance profile for SSM attached to the bastion
- Key pair created from your provided public key. ssh public key is read from GitHub secrets.
- Remote Terraform state** (S3) with DynamoDB state locking
- GitHub Actions  manual flow work for plan, apply and destroy. 
-  Outputs are saved as an artifact and summarized in the run