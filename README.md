# Windows Azure Module
A Terraform module to create a new virtual network and a Windows virtual machine into existing resource group in Azure.

* By default create a single [Windows 10, version 1903 IT Pro](https://docs.microsoft.com/en-us/windows/whats-new/whats-new-windows-10-version-1903)
* Generate password and store secret in key vault
* Allow only one source IP address to access remotely
* Auto-shutdown virtual machine by default

#### The simplest example how to use this module
```
module "windows" {
  source              = "yusmadi/windows-vm/azurerm"
  prefix              = "example"
  resource_group_name = "existing-rg"
  vnet_name           = "existing-vnet"
  subnet_name         = "default"
}
```

#### Full example how to use this module
```
module "windows" {
  source               = "ayusmadi/windows-vm/azurerm"
  prefix               = "mywindows"
  resource_group_name  = "southeastasia"
  my_public_ip_address = "13.15.17.19"
  vm_size              = "Standard_DS1_v2"
  publisher            = "MicrosoftWindowsDesktop"
  offer                = "Windows-10"
  sku                  = "19h1-pro"
  image_version        = "latest"
}
```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 1.43.0 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| address\_prefix | The address prefix to use for the subnet. | `string` | `"10.0.2.0/24"` | no |
| address\_space | The address space that is used the virtual network. You can supply more than one address space. Changing this forces a new resource to be created. | `list` | <pre>[<br>  "10.0.0.0/16"<br>]<br></pre> | no |
| autoShutdownStatus | The status of the schedule (i.e. Enabled, Disabled). - Enabled or Disabled | `string` | `"Enabled"` | no |
| autoShutdownTime | The time of day the schedule will occur. | `string` | `"00:00"` | no |
| autoShutdownTimeZone | The time zone ID (e.g. Pacific Standard time). | `string` | `"UTC"` | no |
| image\_version | Specifies the version of the image used to create the virtual machine. Changing this forces a new resource to be created. | `string` | `"latest"` | no |
| my\_public\_ip\_address | Public IP address to allow remote access | `string` | `"1.2.3.4"` | no |
| offer | Specifies the offer of the image used to create the virtual machine. Changing this forces a new resource to be created. | `string` | `"Windows-10"` | no |
| prefix | Prefix to be used by resources and attributes. | `string` | `"myserver"` | no |
| publisher | Specifies the publisher of the image used to create the virtual machine. Changing this forces a new resource to be created. | `string` | `"MicrosoftWindowsDesktop"` | no |
| resource\_group\_name | Specifies the name of the existing resource group. | `any` | n/a | yes |
| sku | Specifies the SKU of the image used to create the virtual machine. Changing this forces a new resource to be created. | `string` | `"19h1-pro"` | no |
| subnet\_name | Specifies the name of the existing Subnet. | `any` | n/a | yes |
| vm\_size | Specifies the size of the Virtual Machine. | `string` | `"Standard_DS1_v2"` | no |
| vnet\_name | Specifies the name of the existing Virtual Network. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| fqdn | Hostname of the Windows virtual machine |
| password | Username to access the Windows virtual machine |
| username | Username to access the Windows virtual machine |
| vm\_id | The ID of the Virtual Machine. |

#### Reference

* [What is module?](https://www.terraform.io/docs/configuration/modules.html)
* [How can I improve this module?](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/proposing-changes-to-your-work-with-pull-requests)
* [How is this module versioned?](https://semver.org/)
* [What are the available size of virtual machines?](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-size-specs/)
