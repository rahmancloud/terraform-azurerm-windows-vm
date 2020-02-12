module "windows" {
  source               = "ayusmadi/windows-vm/azurerm"
  prefix               = "mywindows"
  resource_group_name  = "existing-rg"
  allowed_ip_addresses = ["60.50.180.165/32"]
  vm_size              = "Standard_DS1_v2"
  publisher            = "MicrosoftWindowsDesktop"
  offer                = "Windows-10"
  sku                  = "19h1-pro"
  image_version        = "latest"
}
