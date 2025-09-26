## Elastic BeanStalk

elastic_beanstalk = {
  elastic_app_name             = "pulse-jobsrunner"
  beanstalk_app_env_name       = "pulse-jobsrunner-prod"
  solution_stack_name          = "64bit Amazon Linux 2 v4.2.3 running Docker"                               #Secret manager compatible version
  subnets                      = ["private-beanstalk-az-2a-subnet-01", "private-beanstalk-az-2b-subnet-01"] #, "private-beanstalk-az-2c-subnet-01", "private-beanstalk-az-2d-subnet-01"]
  lb_subnets                   = ["private-alb-az-2a-subnet-01", "private-alb-az-2b-subnet-01"]             #, "private-alb-az-2c-subnet-01", "private-alb-az-2d-subnet-01"]
  environment                  = "Production"
  instance_type                = "c7i.xlarge"
  autoscaling_minsize          = 8
  autoscaling_maxsize          = 8
  deployment_batchsize         = 100
  preferred_start_time         = "Tue:09:00"
  ssl_certificate_id           = "*.prod.vas.com"
  cloudwatch_logs_retention    = 60
  cross_account_id             = 221515991534
  use_iam_roles_authentication = true
  seq_api_key                  = "KCRHfwh1iCoYLHOmWL7f" # cspell:disable-line
}
