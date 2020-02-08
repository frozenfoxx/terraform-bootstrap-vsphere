variable "authkeys" {
  default     = ""
  description = "Authorized keys content for the persistent admin user (base64 encoded)"
}

variable "cluster" {
  default     = "MGMT"
  description = "Cluster to assign host to"
}

variable "datacenter" {
  default     = ""
  description = "Which datacenter name to use"
}

variable "dataroot" {
  default     = "/data"
  description = "Root location for tftp"
}

variable "datastore" {
  default     = ""
  description = "Datastore in vSphere to attach to"
}

variable "dhcpstart" {
  default     = "192.168.3.10"
  description = "IP to start DHCP serving"
}

variable "dhcpstop" {
  default     = "192.168.3.19"
  description = "IP to stop DHCP serving"
}

variable "folder" {
  default     = "MGMT VMs"
  description = "vSphere folder for organization"
}

variable "management_dns_servers" {
  default     = []
  description = "List of DNS servers to use"
}

variable "management_domain" {
  default     = ""
  description = "Domain to attach the host to"
}

variable "management_gateway" {
  default     = ""
  description = "Host to route default uplink traffic to"
}

variable "management_ipv4_address" {
  default     = ""
  description = "Management network IPv4 address for the system"
}

variable "management_ipv4_prefix_length" {
  default     = "24"
  description = "IPv4 bits to use for the prefix in the management network"
}

variable "management_netlabel" {
  default     = ""
  description = "Management network device"
}

variable "name" {
  default     = "default-vm"
  description = "Hostname of the system"
}

variable "password" {
  default     = ""
  description = "Password for the persistent user for system access"
}

variable "template" {
  default     = ""
  description = "Which VM template to clone from"
}

variable "timeout" {
  default     = "600"
  description = "Time to wait during creation"
}

variable "username" {
  default     = ""
  description = "Persistent user for system access"
}

variable "vmtimez" {
  default     = "Etc/UTC"
  description = "Timezone"
}
