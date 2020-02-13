output "fqdn" {
  value       = azurerm_public_ip.main.fqdn
  description = "Hostname of the Windows virtual machine"
}

output "username" {
  value       = "${var.prefix}-user"
  description = "Username to access the Windows virtual machine"
}

output "password" {
  value       = random_password.password.result
  description = "Username to access the Windows virtual machine"
  sensitive   = true
}

output "vm_id" {
  value       = azurerm_virtual_machine.main.id
  description = "The ID of the Virtual Machine."
}

output "fqdn" {
  value       = azurerm_public_ip.main.fqdn
  description = "Fully qualified domain name of the A DNS record associated with the public IP. domain_name_label must be specified to get the fqdn. This is the concatenation of the domain_name_label and the regionalized DNS zone"
}
