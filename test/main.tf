module "windows" {
  source               = "ayusmadi/windows-vm/azurerm"
  prefix               = "mywindows"
  domain_name_label    = "mywindows"
  resource_group_name  = "existing-rg"
  allowed_ip_addresses = ["13.15.17.19/32"]
  vm_size              = "Standard_DS1_v2"
  publisher            = "MicrosoftWindowsDesktop"
  offer                = "Windows-10"
  sku                  = "19h1-pro"
  image_version        = "latest"
  delete_disks_on_termination = true
}
