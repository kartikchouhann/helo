module "iam" {
  source = "../../../modules/security/iam"

  roles       = var.pulse_iam.roles
  policies    = var.pulse_iam.policies
  users       = var.pulse_iam.users
  groups      = var.pulse_iam.groups
  environment = var.general_variables.environment
  main_region = var.general_variables.main_region
}
