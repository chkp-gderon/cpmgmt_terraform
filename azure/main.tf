# Basic resources

resource "azurerm_resource_group" "rg_mgmt" {
    name = var.rg_name
    location = var.location
}

resource "azurerm_virtual_network" "vnet_mgmt" {
  name          = var.vnet_name
  address_space = var.vnet_cidr
  location      = var.location
  resource_group_name = azurerm_resource_group.rg_mgmt.name
}

resource "azurerm_subnet" "subnet_mgmt" {
  name                 = var.subnet_mgmt_name
  resource_group_name  = azurerm_resource_group.rg_mgmt.name
  virtual_network_name = azurerm_virtual_network.vnet_mgmt.name
  address_prefixes     = var.subnet_mgmt_cidr
}

resource "azurerm_public_ip" "public_ip_mgmt" {
  name = "mgmtPublicIP"
  resource_group_name = azurerm_resource_group.rg_mgmt.name
  location = var.location
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_network_interface" "mgmt_nic" {
  name = "mgmt-eth0"
  location = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name = "externalNIC"
    subnet_id = azurerm_subnet.subnet_mgmt.id
    private_ip_address_version = "IPv4"
    private_ip_address_allocation = "Dynamic"
    primary = true
    public_ip_address_id = azurerm_public_ip.public_ip_mgmt.id
  }
}

resource "azurerm_linux_virtual_machine" "vm_logserver" {
  name = var.log_server_name
  resource_group_name = var.rg_name
  location = var.location
  size = "Standard_D3_v2"
  admin_username = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [ azurerm_network_interface.mgmt_nic.id ]
  custom_data = base64encode(templatefile("${path.module}/cloud-init.sh",{
    installation_type=var.installation_type
    allow_upload_download= var.allow_upload_download
    os_version=var.os_version
    template_name=var.template_name
    template_version=var.template_version
    is_blink=var.is_blink
    bootstrap_script64=base64encode(var.bootstrap_script)
    location=var.location
    management_gui_client_network=var.management_gui_client_network
  })
  )

  source_image_reference {
    publisher = "checkpoint"
    offer = "check-point-cg-r8040"
    sku = "mgmt-byol"
    version = "latest"
  }
  plan {
    name = "mgmt-byol"
    product = "check-point-cg-r8040"
    publisher = "checkpoint"
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 100
  }
}

resource "azurerm_network_security_group" "nsg_mgmt" {
  name = "mgmt_nsg"
  location = var.location
  resource_group_name = azurerm_resource_group.rg_mgmt.name

}

resource "azurerm_network_security_rule" "nsg_rule_inbound_allow" {
  name = "mgmt_nsg_inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_mgmt.name
  network_security_group_name = azurerm_network_security_group.nsg_mgmt.name
}

resource "azurerm_network_security_rule" "nsg_rule_outbound" {
  name = "mgmt_nsg_outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_mgmt.name
  network_security_group_name = azurerm_network_security_group.nsg_mgmt.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_mgmt" {
  subnet_id = azurerm_subnet.subnet_mgmt.id
  network_security_group_id = azurerm_network_security_group.nsg_mgmt.id
}