# Windows Azure Module
A Terraform module to create a new virtual network and a publicly accessible Windows virtual machine into existing resource group in Azure.

* By default create a single [Windows 10, version 1903 IT Pro](https://docs.microsoft.com/en-us/windows/whats-new/whats-new-windows-10-version-1903)
* Generate password and store secret in key vault
* Allow only one source IP address to access remotely
* Auto-shutdown virtual machine by default

#### The simplest example how to use this module
```
module "windows" {
  source              = "yusmadi/windows-vm/azurerm"
  prefix              = "example"
  domain_name_label   = "mywindows"
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
```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 1.43.0 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| allowed\_ip\_addresses | Public IP address to allow remote access | `list(string)` | <pre>[<br>  "1.2.3.4/32"<br>]</pre> | no |
| autoShutdownStatus | The status of the schedule (i.e. Enabled, Disabled). - Enabled or Disabled | `string` | `"Enabled"` | no |
| autoShutdownTime | The time of day the schedule will occur. | `string` | `"00:00"` | no |
| autoShutdownTimeZone | The time zone ID (e.g. Pacific Standard time). | `string` | `"UTC"` | no |
| delete\_disks\_on\_termination | Delete all disks when virtual machine is deleted | `bool` | `false` | no |
| domain\_name\_label | Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. | `any` | n/a | yes |
| image\_version | Specifies the version of the image used to create the virtual machine. Changing this forces a new resource to be created. | `string` | `"latest"` | no |
| offer | Specifies the offer of the image used to create the virtual machine. Changing this forces a new resource to be created. | `string` | `"Windows-10"` | no |
| prefix | Prefix to be used by resources and attributes. Windows computer name cannot be more than 15 characters long, be entirely numeric | `string` | `"myserver"` | no |
| publisher | Specifies the publisher of the image used to create the virtual machine. Changing this forces a new resource to be created. | `string` | `"MicrosoftWindowsDesktop"` | no |
| resource\_group\_name | Specifies the name of the existing resource group. | `any` | n/a | yes |
| sku | Specifies the SKU of the image used to create the virtual machine. Changing this forces a new resource to be created. | `string` | `"19h1-pro"` | no |
| subnet\_name | Specifies the name of the existing Subnet. | `any` | n/a | yes |
| vm\_size | Specifies the size of the Virtual Machine. | `string` | `"Standard_DS1_v2"` | no |
| vnet\_name | Specifies the name of the existing Virtual Network. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| fqdn | Fully qualified domain name of the A DNS record associated with the public IP. domain\_name\_label must be specified to get the fqdn. This is the concatenation of the domain\_name\_label and the regionalized DNS zone |
| password | Username to access the Windows virtual machine |
| username | Username to access the Windows virtual machine |
| vm\_id | The ID of the Virtual Machine. |

#### Reference

* [What is module?](https://www.terraform.io/docs/configuration/modules.html)
* [How can I improve this module?](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/proposing-changes-to-your-work-with-pull-requests)
* [How is this module versioned?](https://semver.org/)
* [What are the available size of virtual machines?](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-size-specs/)
