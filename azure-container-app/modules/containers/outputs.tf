output "default_domain" {
  value = jsondecode(azapi_resource.moodle_env.output).properties.defaultDomain
}