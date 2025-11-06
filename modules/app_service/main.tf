resource "azurerm_app_service_plan" "plan" {
  name                = "${var.clinic_code}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    tier = "Standard"
    size = "S1"
  }
  kind     = "Linux"
  reserved = true
}

resource "azurerm_app_service" "app" {
  name                = "${var.clinic_code}-app"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  site_config {
    linux_fx_version = "NODE|18-lts"
  }

  app_settings = {
    "WEBSITES_PORT"       = "3000"
    "BACKEND_URL"         = var.backend_url
    "BRANDING_BLOB_URL"   = var.branding_blob_url
    "NEXT_PUBLIC_BACKEND" = var.backend_url
  }

  identity {
    type = "SystemAssigned"
  }
}