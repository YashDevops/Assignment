output "instance_id" {
  value = element(aws_instance.assignment.*.id, 0)
}

output "public_ip" {
  value = element(aws_instance.assignment.*.public_ip, 0)
}
