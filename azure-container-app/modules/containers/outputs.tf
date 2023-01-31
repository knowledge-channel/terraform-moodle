output "public_ip" {
  value = jsondecode(azapi_resource.moodle_env.output).properties.staticIp
}