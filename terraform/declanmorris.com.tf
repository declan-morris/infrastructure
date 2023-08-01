resource "azurerm_resource_group" "personalSite" {
  name     = "personalSite"
  location = "West Europe"
}

resource "azurerm_virtual_network" "personalSiteVNET" {
  name                = "personalSiteNetwork"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.personalSite.location
  resource_group_name = azurerm_resource_group.personalSite.name
}

resource "azurerm_subnet" "personalSiteSubnet" {
  name                 = "personalSiteSubnet"
  resource_group_name  = azurerm_resource_group.personalSite.name
  virtual_network_name = azurerm_virtual_network.personalSiteVNET.name
  address_prefixes     = ["10.0.0.0/29"]
  # checkov:skip=CKV2_AZURE_31::Probably should have NSG but too lazy
}

resource "azurerm_network_interface" "personalSiteNIC" {
  # checkov:skip=CKV_AZURE_119::Probably shouldn't have direct pub ip but too lazy

  name                = "personalSiteNIC"
  location            = azurerm_resource_group.personalSite.location
  resource_group_name = azurerm_resource_group.personalSite.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.personalSiteSubnet.id
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.pubIP.id
    primary                       = true
    private_ip_address            = cidrhost(azurerm_subnet.personalSiteSubnet.address_prefixes[0], 4)
  }

}

//azure only accepts RSA SSH keys so we need to bootstrap as I have ed25519 keys on GH
resource "tls_private_key" "bootstrapKey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "personalSiteVM" {
  name                       = "personalSiteVM"
  resource_group_name        = azurerm_resource_group.personalSite.name
  location                   = azurerm_resource_group.personalSite.location
  size                       = "Standard_B2s"
  admin_username             = "dtm"
  allow_extension_operations = false
  provision_vm_agent         = true

  network_interface_ids = [
    azurerm_network_interface.personalSiteNIC.id,
  ]

  admin_ssh_key {
    username   = "dtm"
    public_key = tls_private_key.bootstrapKey.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "personalSiteNSG" {
  name                = "PersonalSiteNSG"
  location            = azurerm_resource_group.personalSite.location
  resource_group_name = azurerm_resource_group.personalSite.name
}

resource "azurerm_network_interface_security_group_association" "personalSite" {
  network_interface_id      = azurerm_network_interface.personalSiteNIC.id
  network_security_group_id = azurerm_network_security_group.personalSiteNSG.id
}

resource "azurerm_public_ip" "pubIP" {
  name                = "declanmorrispubIP"
  resource_group_name = azurerm_resource_group.personalSite.name
  location            = azurerm_resource_group.personalSite.location
  allocation_method   = "Static"
  domain_name_label   = "declanmorrispersonalsite"
}

resource "local_sensitive_file" "privateKey" {
  content  = tls_private_key.bootstrapKey.private_key_openssh
  filename = "${path.module}/../ansible/secrets/id_RSAAzureBootstrap.pk"
}

resource "azurerm_network_security_rule" "SSHRule" {
  #checkov:skip=CKV_AZURE_10: Allow SSH access for deployment and management
  name                        = "SSHAccess"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_network_interface.personalSiteNIC.private_ip_address
  resource_group_name         = azurerm_resource_group.personalSite.name
  network_security_group_name = azurerm_network_security_group.personalSiteNSG.name
}

resource "azurerm_network_security_rule" "HTTPRule" {
  #checkov:skip=CKV_AZURE_160: Allow http access for certbot
  name                        = "HTTP"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_network_interface.personalSiteNIC.private_ip_address
  resource_group_name         = azurerm_resource_group.personalSite.name
  network_security_group_name = azurerm_network_security_group.personalSiteNSG.name
}

resource "azurerm_network_security_rule" "HTTPSRule" {
  name                        = "HTTPS Access"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_network_interface.personalSiteNIC.private_ip_address
  resource_group_name         = azurerm_resource_group.personalSite.name
  network_security_group_name = azurerm_network_security_group.personalSiteNSG.name
}