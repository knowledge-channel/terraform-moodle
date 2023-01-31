# moodle file of Container App

# Recover Resource Group
data "azurerm_resource_group" "moodle" {
  name = var.azurerm_rg
}

# Azure Container App Environment
resource "azapi_resource" "moodle_env" {
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  parent_id = data.azurerm_resource_group.moodle.id
  location  = data.azurerm_resource_group.moodle.location
  name      = "moodle-container-env"
  tags      = var.tags

  body = jsonencode({
    properties = {
      daprAIInstrumentationKey = var.logs_app_insights
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = var.logs_workspace_id
          sharedKey  = var.logs_access_key
        }
      }
    }
  })
}

resource "azapi_resource" "moodle_storage" {
  type      = "Microsoft.App/managedEnvironments/storages@2022-03-01"
  parent_id = azapi_resource.moodle_env.id
  name      = "moodle-container-storage"

  body = jsonencode({
    properties = {
      azureFile = {
        accountName = var.volume_storage_name
        shareName   = var.volume_share_name
        accountKey  = var.volume_access_key
        accessMode  = "ReadWrite"
      }
    }
  })
}

# Azure Container App
resource "azapi_resource" "moodle" {
  type      = "Microsoft.App/containerApps@2022-03-01"
  parent_id = data.azurerm_resource_group.moodle.id
  location  = data.azurerm_resource_group.moodle.location
  name      = "moodle-containers"

  body = jsonencode({
    properties : {
      managedEnvironmentId = azapi_resource.moodle_env.id
      configuration = {
        ingress = {
          external  = true
          allowInsecure = true
          targetPort = 80
          transport = "auto"
          traffic = [
            {
              latestRevision = true
              weight         = 100
            }
          ]
        }
        secrets = [
          {
            name = "moodle-password"
            value = var.moodle_password
          },
          {
            name = "moodle-db-password"
            value = var.database_password
          },
        ]
      }
      template = {
        containers = [
          {
            name  = "main"
            image = "bitnami/moodle:latest"
            resources = {
              cpu    = 0.5
              memory = "1.0Gi"
            }
            probes = [
              {
                type = "Startup"
                httpGet = {
                  path   = "/"
                  port   = 80
                }
                initialDelaySeconds = 60
                periodSeconds       = 120
                failureThreshold    = 10
                timeoutSeconds      = 120
              },
              {
                type = "Liveness"
                httpGet = {
                  path   = "/"
                  port   = 80
                }
              }
            ]
            env = [
              {
                name  = "BITNAMI_DEBUG"
                value = var.moodle_debug
              },
              {
                name  = "MOODLE_USERNAME"
                value = var.moodle_admin
              },
              {
                name  = "MOODLE_PASSWORD"
                secretRef = "moodle-password"
              },
              {
                name  = "MOODLE_EMAIL"
                value = var.moodle_system_email
              },
              {
                name  = "MOODLE_SITE_NAME"
                value = var.moodle_site_name
              },
              {
                name  = "MOODLE_LANG"
                value = var.moodle_lang
              },
              {
                name  = "MOODLE_DATABASE_TYPE"
                value = "auroramysql"
              },
              {
                name  = "MOODLE_DATABASE_HOST"
                value = var.database_host
              },
              {
                name  = "MOODLE_DATABASE_NAME"
                value = var.database_name
              },
              {
                name  = "MOODLE_DATABASE_USER"
                value = var.database_user
              },
              {
                name  = "MOODLE_DATABASE_PASSWORD"
                secretRef = "moodle-db-password"
              },
              {
                name  = "MOODLE_DATABASE_MIN_VERSION"
                value = "5.6.47.0"
              },
              {
                name  = "APACHE_HTTP_PORT_NUMBER"
                value = "80"
              },
            ]
            volumeMounts = [
              {
                volumeName = "moodle-volume"
                mountPath  = "/bitnami/moodle"
              }
            ]
          }
        ]
        scale = {
          minReplicas = 1
          maxReplicas = 10
          rules = [
            {
              name = "http-rule",
              http = {
                metadata = {
                  concurrentRequests = "100"
                }
              }
            }
          ]
        }
        volumes = [
          {
            name        = "moodle-volume"
            storageName = azapi_resource.moodle_storage.name
            storageType = "AzureFile"
          }
        ]
      }
    }
  })

  tags = var.tags
}
