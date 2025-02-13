# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}


resource "azurerm_storage_account" "storage" {
  name                     = "staticwebsitestoracc"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_static_website" "website" {
  storage_account_id = azurerm_storage_account.storage.id
  index_document     = "index.html"
  error_404_document = "error.html"
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "./index.html"
  depends_on = [ azurerm_storage_account_static_website.website]   # muss hier auf die resource warten, sodass der container erstellt wird und erst dann die html hineingeladen wird! 
}

resource "azurerm_storage_blob" "error" {
  # Bedingung: Falls boolean nicht gesetzt, resource 0 mal
  count = var.enable_error_page ? 1 : 0

  name                   = "error.html"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "./error.html"
  depends_on = [ azurerm_storage_account_static_website.website]   # muss hier auf die resource warten, sodass der container erstellt wird und erst dann die html hineingeladen wird! 
}


output "website_url" {
  value = azurerm_storage_account.storage.primary_web_endpoint
}
