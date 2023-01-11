# moodle file of MySQL Database

# Recover Resource Group
data "azurerm_resource_group" "moodle" {
  name      = var.azurerm_rg
  location  = var.azurerm_location
}

# Recover VNet
data "azurerm_virtual_network" "moodle" {
  resource_group_name = data.azurerm_resource_group.moodle.name
  name                = var.azurerm_vnet
}

# Azure Blob Storage
resource "azurerm_storage_account" "moodle" {
  name                      = "bitnami-moodle-storage"
  resource_group_name       = data.azurerm_resource_group.moodle.name
  location                  = data.azurerm_resource_group.moodle.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  tags                      = var.tags
}

# Azure File Share
resource "azurerm_storage_share" "moodle" {
  name                 = "bitnami-moodle-share"
  storage_account_name = azurerm_storage_account.moodle.name
  quota                = 50
}

# Subnet
resource "azurerm_subnet" "moodle" {
  name                 = var.azurerm_subnet
  resource_group_name  = data.azurerm_resource_group.moodle.name
  virtual_network_name = data.azurerm_virtual_network.moodle.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "aci"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
      ]
    }
  }
}

# Azure Security Group
resource "azurerm_network_security_group" "moodle" {
  name                = "moodle-aci-nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
    name              = "from-gateway-subnet"
    priority          = 100
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"

    destination_port_ranges    = [8443]
    source_address_prefixes    = "*"
    destination_address_prefix = azurerm_subnet.moodle.address_prefix
  }

  security_rule {
    name                       = "DenyAllInBound-Override"
    priority                   = 900
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name              = "to-vnet"
    priority          = 100
    direction         = "VirtualNetwork"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"

    destination_port_ranges    = [3306]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllOutBound-Override"
    priority                   = 900
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Atach Security Group to Subnet 
resource "azurerm_subnet_network_security_group_association" "moodle" {
  subnet_id                 = azurerm_subnet.moodle.id
  network_security_group_id = azurerm_network_security_group.moodle.id
}

resource "azurerm_network_profile" "moodle" {
  name                = "moodle-aci-profile"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  container_network_interface {
    name = "moodle-aci-nic"

    ip_configuration {
      name      = "moodle-ip-config"
      subnet_id = azurerm_subnet.moodle.id
    }
  }
}

# Azure Container Group
resource "azurerm_container_group" "moodle" {
  name                = "moodle-container"
  location            = data.azurerm_resource_group.moodle.location
  resource_group_name = data.azurerm_resource_group.moodle.name
  
  ip_address_type     = "Private"
  os_type             = "Linux"
  network_profile_id  = azurerm_network_profile.moodle.id

  container {
    name   = "bitnami-moodle"
    image  = "bitnami/moodle"
    cpu    = "0.5"
    memory = "1.5"

    environment_variables = {
      "BITNAMI_DEBUG"               = var.moodle_debug
      "MOODLE_USERNAME"             = var.moodle_admin
      "MOODLE_EMAIL"                = var.moodle_system_email
      "MOODLE_SITE_NAME"            = var.moodle_site_name
      "MOODLE_LANG"                 = var.moodle_lang
      "MOODLE_DATABASE_TYPE"        = "auroramysql"
      "MOODLE_DATABASE_HOST"        = var.database_host
      "MOODLE_DATABASE_NAME"        = var.database_name
      "MOODLE_DATABASE_USER"        = var.database_user
      "MOODLE_DATABASE_MIN_VERSION" = "5.6.47.0"
    }

    secure_environment_variables = {
      "MOODLE_PASSWORD"             = var.moodle_password
      "MOODLE_DATABASE_PASSWORD"    = var.database_password
    }

    volume {
      name       = "moodle"
      mount_path = "/bitnami/moodle"
      read_only  = false
      share_name = azurerm_storage_share.moodle.name

      storage_account_name = azurerm_storage_account.moodle.name
      storage_account_key  = azurerm_storage_account.moodle.primary_access_key
    }

    ports {
      port     = 8443
      protocol = "TCP"
    }
  }

  tags = var.tags
}