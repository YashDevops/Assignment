output "Bastion-IP" {
  value = module.bastion.public_ip
}

output "AppServer-IP" {
  value = module.ec2.private_ip
}

# output "ALB-DNS" {
#   description = "Open This DNS in Browser To access Application"
#   value       =  module.elb.dns_name
# }
