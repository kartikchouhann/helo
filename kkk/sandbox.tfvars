## Elastic BeanStalk

elastic_beanstalk = {
  elastic_app_name             = "pulse-jobsrunner"
  beanstalk_app_env_name       = "pulse-jobsrunner-sandbox"
  solution_stack_name          = "64bit Amazon Linux 2 v4.2.0 running Docker"
  subnets                      = ["private-beanstalk-az-2a-subnet-01", "private-beanstalk-az-2b-subnet-01"]
  lb_subnets                   = ["private-alb-az-2a-subnet-01", "private-alb-az-2b-subnet-01"]
  environment                  = "sandbox"
  instance_type                = "c7i.large"
  autoscaling_minsize          = 1
  autoscaling_maxsize          = 2
  deployment_batchsize         = 30
  preferred_start_time         = "Tue:09:00"
  ssl_certificate_id           = "*.sandbox.vas.com"
  cloudwatch_logs_retention    = 60
  cross_account_id             = 111111111111 #Placeholder
  use_iam_roles_authentication = false
  seq_api_key                  = "value"
}