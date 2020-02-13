terraform {
  required_version = "~> 0.12.20"

  required_providers {
    azurerm = "~> 1.43.0"
  }
}

data "azurerm_client_config" "main" {}

resource "random_password" "password" {
  length           = 8
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  special          = true
  override_special = "!@#$%&"
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "main" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = data.azurerm_virtual_network.main.name
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-pip1"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  domain_name_label   = var.prefix

  tags = {
    label = var.prefix
  }
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = {
    label = var.prefix
  }
}

resource "azurerm_network_security_rule" "remote_desktop" {
  name                        = "Remote Access"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = var.allowed_ip_addresses
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_interface" "main" {
  name                      = "${var.prefix}-nic1"
  location                  = data.azurerm_resource_group.main.location
  resource_group_name       = data.azurerm_resource_group.main.name
  network_security_group_id = azurerm_network_security_group.main.id

  ip_configuration {
    name                          = "${var.prefix}-config1"
    subnet_id                     = data.azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = {
    label = var.prefix
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = data.azurerm_resource_group.main.location
  resource_group_name   = data.azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination = var.delete_disks_on_termination
  delete_data_disks_on_termination  = var.delete_disks_on_termination

  storage_os_disk {
    name              = "${var.prefix}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
  }

  os_profile {
    computer_name  = "${var.prefix}-vm"
    admin_username = "${var.prefix}-user"
    admin_password = random_password.password.result
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  /*
  identity {
    type         = "UserAssigned"
    identity_ids = [ data.azurerm_client_config.main.client_id ]
  }
  */

  tags = {
    label = var.prefix
  }
}

/* auto-shutdown doesn't work at the moment. refer terraform-provider-azurerm issues with service/devtestlabs label
resource "azurerm_dev_test_lab" "main" {
  name                = "YourDevTestLab"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

}

resource "azurerm_dev_test_schedule" "main" {
  name                = "shutdown-compute-${var.prefix}-vm1"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  lab_name            = azurerm_dev_test_lab.main.name
  
  status = "Enabled"

  daily_recurrence {
    time      = "0852"
  }

  time_zone_id = "Singapore Standard Time"
  task_type    = "ComputeVmShutdownTask"

  notification_settings {
  }

  tags = {
    label = var.prefix
  }
}
*/

resource "azurerm_template_deployment" "main" {
  name                = "${var.prefix}-template1"
  resource_group_name = data.azurerm_resource_group.main.name

  template_body = <<DEPLOY
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "type": "String"
        },
        "virtualMachineName": {
            "type": "String"
        },
        "autoShutdownStatus": {
            "type": "String"
        },
        "autoShutdownTime": {
            "type": "String"
        },
        "autoShutdownTimeZone": {
            "type": "String"
        }
    },
    "variables": {
    },
    "resources": [
        {
            "type": "Microsoft.DevTestLab/schedules",
            "apiVersion": "2017-04-26-preview",
            "name": "[concat('shutdown-computevm-', parameters('virtualMachineName'))]",
            "location": "[parameters('location')]",
            "properties": {
                "status": "[parameters('autoShutdownStatus')]",
                "taskType": "ComputeVmShutdownTask",
                "dailyRecurrence": {
                    "time": "[parameters('autoShutdownTime')]"
                },
                "timeZoneId": "[parameters('autoShutdownTimeZone')]",
                "targetResourceId": "[resourceId('Microsoft.Compute/virtualMachines', parameters('virtualMachineName'))]"
            }
        }
    ],
    "outputs": {
    }
}
DEPLOY

  parameters = {
    "location"             = data.azurerm_resource_group.main.location
    "virtualMachineName"   = azurerm_virtual_machine.main.name
    "autoShutdownStatus"   = var.autoShutdownStatus
    "autoShutdownTime"     = var.autoShutdownTime
    "autoShutdownTimeZone" = var.autoShutdownTimeZone
  }

  deployment_mode = "Incremental"

  depends_on = [
    azurerm_virtual_machine.main
  ]
}
