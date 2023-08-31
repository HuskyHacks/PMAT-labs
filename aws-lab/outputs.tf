output "flarevm_ip" {
  description = "FlareVM IP"
  value       = var.enable_guacamole == false ? aws_instance.flarevm.public_ip : aws_instance.flarevm.private_ip
}

output "remnux_ip" {
  description = "REMnux IP"
  value       = var.enable_guacamole == false ? aws_instance.remnux.public_ip : aws_instance.remnux.private_ip
}

output "guacamole_public_ip" {
  description = "Guacamole public IP"
  value       = var.enable_guacamole == false ? null : aws_instance.guacamole[0].public_ip
}

output "guacamole_credentials" {
  description = "Guacamole credentials"
  value       = var.enable_guacamole == false ? null : data.external.guacamole_credentials[0].result
}

output "flarevm_credentials" {
  description = "Default credentials for the PMAT FLARE-VM base AMI. PLEASE CHANGE THESE!"
  value = "Administrator:PLEASEchangeThisPassword123"
}

output "remnux_credentials" {
  description = "Default credentials for the PMAT REMnux base AMI. PLEASE CHANGE THESE!"
  value = "remnux:malware"
}
