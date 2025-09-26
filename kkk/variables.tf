variable "general_variables" {
  description = "Custom project configs"
  type = object({
    main_region  = string
    environment  = string
    default_tags = map(string)
  })

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.general_variables.main_region))
    error_message = "Must be valid AWS Region names."
  }
}

variable "pulse_project_configs" {
  description = "Custom project configs"
  type = object({
    default_tags = map(string)
  })
}

variable "elastic_beanstalk" {
  description = "Custom project variables"
  type = object({
    trigger_upper_threshold       = optional(number, 70)
    trigger_lower_threshold       = optional(number, 0)
    trigger_statistic             = optional(string, "Maximum")
    trigger_unit                  = optional(string, "Percent")
    trigger_upper_scale_increment = optional(number, 0)
    trigger_lower_scale_increment = optional(number, 0)
    trigger_measure_name          = optional(string, "CPUUtilization")
    associate_public_ipddress     = optional(bool, false)
    elb_scheme                    = optional(string, "internal")
    matcher_http_code             = optional(number, 200)
    subnets                       = list(string)
    lb_subnets                    = list(string)
    load_balancer_type            = optional(string, "application")
    instance_type                 = string
    autoscaling_minsize           = number
    autoscaling_maxsize           = number
    deployment_batchsize          = number
    deployment_policy             = optional(string, "AllAtOnce")
    rolling_update_max_batch_size = optional(number, 3)
    rolling_update_enabled        = optional(bool, false)
    rolling_update_type           = optional(string, "Health")
    rolling_update_timeout        = optional(string, "PT5M")
    managed_actions_enabled       = optional(bool, false)
    preferred_start_time          = string
    platform_update               = optional(string, "patch")
    instance_refresh_enabled      = optional(bool, false)
    ignore_health_check           = optional(bool, true)
    cloudwatch_logs               = optional(bool, true)
    cloudwatch_logs_retention     = number
    elastic_app_name              = string
    listener_protocol_http        = optional(string, "HTTP")
    instance_port_http            = optional(string, "80")
    listener_enabled              = optional(bool, true)
    beanstalk_app_env_name        = string
    solution_stack_name           = string
    listener_protocol_https       = optional(string, "HTTPS")
    ssl_certificate_id            = string
    cross_account_id              = number
    environment                   = string
    use_iam_roles_authentication  = optional(bool, true)
    tags                          = optional(map(string), {})
    notification_protocol         = optional(string, "email")
    notification_endpoint         = optional(string, "vasdevopsteam@vas.com")
    seq_api_key                   = string # this is a not-so-secret secret. It is plaintext so that we can see the terraform plan output
    # ec2_key_name                = string
  })
}

variable "backend_info" {
  description = "Custom backend configs"
  type = object({
    bucket_name                   = string
    primary_vpc_statefile         = string
    iam_roles_statefile           = string
    security_group_statefile      = string
    certificate_manager_statefile = string
    secret_manager_statefile      = string
  })
}
