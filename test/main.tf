module "windows" {
  source               = "ayusmadi/windows-vm/azurerm"
  prefix               = "mywindows"
  resource_group_name  = "existing-rg"
  address_space        = ["10.0.0.0/16"]
  address_prefix       = "10.0.2.0/24"
  my_public_ip_address = "13.15.17.19"
  vm_size              = "Standard_DS1_v2"
  publisher            = "MicrosoftWindowsDesktop"
  offer                = "Windows-10"
  sku                  = "19h1-pro"
  image_version        = "latest"
}