output "vpc_id" {
  value =  aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}
output "bastion_id" {
  value =  aws_instance.bastion.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "iam_role_name" {
  value = aws_iam_role.ssm.name
}

output "iam_instance_profile_arn" {
  value = aws_iam_instance_profile.ssm.arn
}