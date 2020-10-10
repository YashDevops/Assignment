output "Bastion-IP" {
  value = module.bastion.public_ip
}

output "AppServer-IP" {
  value = module.ec2.private_ip
}
