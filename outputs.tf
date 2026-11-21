output "customer_profile_private_ip" {
  description = "Private IP address of customer_profile_instance_1"
  value       = module.customer_profile_instance_1.private_ip
}

output "jump_host_public_ip" {
  description = "Public IP address of the jump host"
  value       = module.jump_host_instance.public_ip
}