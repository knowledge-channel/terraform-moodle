# way to get generated password
output "created_password" {
  sensitive = true
  value     = random_password.password.result
}

output "moodle_host" {
  value = module.containers.moodle_host
}
