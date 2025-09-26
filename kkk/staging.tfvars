## Elastic BeanStalk

elastic_beanstalk = {
  elastic_app_name             = "pulse-jobsrunner"
  beanstalk_app_env_name       = "pulse-jobsrunner-staging"
  solution_stack_name          = "64bit Amazon Linux 2 v4.2.3 running Docker"
  subnets                      = ["private-beanstalk-az-2a-subnet-01", "private-beanstalk-az-2b-subnet-01"]
  lb_subnets                   = ["private-alb-az-2a-subnet-01", "private-alb-az-2b-subnet-01"]
  environment                  = "Staging"
  instance_type                = "c7i.large"
  autoscaling_minsize          = 1
  autoscaling_maxsize          = 2
  deployment_batchsize         = 30
  preferred_start_time         = "Tue:09:00"
  ssl_certificate_id           = "*.staging.vas.com"
  cloudwatch_logs_retention    = 60
  cross_account_id             = 586815333384
  use_iam_roles_authentication = true
  seq_api_key                  = "jyKgt4RLDEAYQWKpMjTz" # cspell:disable-line
}