variable "resource_group_name" {
  description = "Specifies the name of the existing resource group."
}

variable "prefix" {
  description = "Prefix to be used by resources and attributes. Windows computer name cannot be more than 15 characters long, be entirely numeric"
  default     = "myserver"
}

variable "vnet_name" {
  description = "Specifies the name of the existing Virtual Network."
}

variable "subnet_name" {
  description = "Specifies the name of the existing Subnet."
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "Public IP address to allow remote access"
  default     = ["1.2.3.4/32"]
}

variable "vm_size" {
  description = "Specifies the size of the Virtual Machine."
  default     = "Standard_DS1_v2"
}

variable "publisher" {
  description = "Specifies the publisher of the image used to create the virtual machine. Changing this forces a new resource to be created."
  default     = "MicrosoftWindowsDesktop"
}

variable "offer" {
  description = "Specifies the offer of the image used to create the virtual machine. Changing this forces a new resource to be created."
  default     = "Windows-10"
}

variable "sku" {
  description = "Specifies the SKU of the image used to create the virtual machine. Changing this forces a new resource to be created."
  default     = "19h1-pro"
}

variable "image_version" {
  description = "Specifies the version of the image used to create the virtual machine. Changing this forces a new resource to be created."
  default     = "latest"
}

variable "autoShutdownStatus" {
  description = "The status of the schedule (i.e. Enabled, Disabled). - Enabled or Disabled"
  default     = "Enabled"
}

variable "autoShutdownTime" {
  description = "The time of day the schedule will occur."
  default     = "00:00"
}

variable "autoShutdownTimeZone" {
  description = "The time zone ID (e.g. Pacific Standard time)."
  default     = "UTC"
}

variable "delete_disks_on_termination" {
  description = "Delete all disks when virtual machine is deleted"
  default     = false
}

variable "domain_name_label" {
  description = "Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
}