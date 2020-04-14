output "vm_name" {
  value = vsphere_virtual_machine.main.name
}

output "vm_management_ip" {
  value = var.management_ipv4_address
}
