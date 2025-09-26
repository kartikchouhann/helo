module "beanstalk_cluster" {
  source                 = "../../../modules/elastic-beanstalk"
  elastic_app_name       = var.elastic_beanstalk.elastic_app_name
  beanstalk_app_env_name = var.elastic_beanstalk.beanstalk_app_env_name
  solution_stack_name    = var.elastic_beanstalk.solution_stack_name
  tags                   = var.elastic_beanstalk.tags

  settings = concat([
    {
      namespace = "aws:ec2:vpc",
      name      = "VPCId",
      value     = data.terraform_remote_state.primary_vpc.outputs.vpc
    },
    {
      namespace = "aws:ec2:vpc",
      name      = "Subnets",
      value     = join(",", sort([for subnet in var.elastic_beanstalk.subnets : data.terraform_remote_state.primary_vpc.outputs.subnets[subnet]]))
    },
    {
      namespace = "aws:ec2:vpc",
      name      = "AssociatePublicIpAddress",
      value     = var.elastic_beanstalk.associate_public_ipddress
    },
    {
      namespace = "aws:ec2:vpc",
      name      = "ELBScheme",
      value     = var.elastic_beanstalk.elb_scheme
    },
    {
      namespace = "aws:ec2:vpc",
      name      = "ELBSubnets",
      value     = join(",", sort([for subnet in var.elastic_beanstalk.lb_subnets : data.terraform_remote_state.primary_vpc.outputs.subnets[subnet]]))
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment",
      name      = "AwsConnection__AwsAccount",
      value     = var.elastic_beanstalk.cross_account_id

    },
    {
      namespace = "aws:elasticbeanstalk:application:environment",
      name      = "ASPNETCORE_ENVIRONMENT",
      value     = var.elastic_beanstalk.environment
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment",
      name      = "Serilog:WriteTo:1:Args:apiKey",
      value     = var.elastic_beanstalk.seq_api_key
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment",
      name      = "AwsConnection:UseIAMRolesAuthentication",
      value     = var.elastic_beanstalk.use_iam_roles_authentication
    },
    {
      namespace = "aws:elasticbeanstalk:application:environmentsecrets",
      name      = "DatabaseConnections:DefaultConnection",
      value     = data.terraform_remote_state.secrets.outputs.secrets_arns["databaseconnections_jobsrunner_secret"]
    },
    {
      namespace = "aws:elasticbeanstalk:application:environmentsecrets",
      name      = "DatabaseConnections:ReadOnlyConnection",
      value     = data.terraform_remote_state.secrets.outputs.secrets_arns["databaseconnections_readonly_jobsrunner_secret"]
    },
    # commenting this out because it will break JR if deployed.
    # {
    #   namespace = "aws:elasticbeanstalk:application:environmentsecrets",
    #   name      = "SecretsManagerResources:PartnersApiKey",
    #   value     = data.terraform_remote_state.secrets.outputs.secrets_arns["partners_api_key"]
    # },
    # {
    #   namespace = "aws:elasticbeanstalk:application:environmentsecrets",
    #   name      = "SecretsManagerResources:PlatformAuthenticationToken",
    #   value     = data.terraform_remote_state.secrets.outputs.secrets_arns["PlatformAuthenticationToken"]
    # },
    {
      namespace = "aws:elasticbeanstalk:application:environmentsecrets",
      name      = "RaygunSettings:ApiKey",
      value     = data.terraform_remote_state.secrets.outputs.secrets_arns["raygun_jobsrunner_apiKey_secret"]
    },
    {
      namespace = "aws:elasticbeanstalk:application:environmentsecrets",
      name      = "Vas.Sdk.Geocoding:ApiKey",
      value     = data.terraform_remote_state.secrets.outputs.secrets_arns["geocoding_apiKey_secret"]
    },
    {
      namespace = "aws:elasticbeanstalk:application:environmentsecrets",
      name      = "Vas.Sdk.Cache:Password",
      value     = data.terraform_remote_state.secrets.outputs.secrets_arns["redis_jobsrunner_password_secret"]
    },
    {
      namespace = "aws:elasticbeanstalk:application:environmentsecrets",
      name      = "Vas.Sdk.Cache:Host",
      value     = data.terraform_remote_state.secrets.outputs.secrets_arns["redis_jobsrunner_host_secret"]
    },
    {
      namespace = "aws:elasticbeanstalk:application:environmentsecrets",
      name      = "Jobs:JobStorage",
      value     = data.terraform_remote_state.secrets.outputs.secrets_arns["jobs_jobstorage_secret"]
    },
    {
      namespace = "aws:elasticbeanstalk:application:environmentsecrets",
      name      = "Vas.Sdk.Messaging:AwsAccessKey",
      value     = data.terraform_remote_state.secrets.outputs.secrets_arns["aws_sdkaccess_key_secret"]
    },
    {
      namespace = "aws:elasticbeanstalk:application:environmentsecrets",
      name      = "Vas.Sdk.Messaging:AwsSecretKey",
      value     = data.terraform_remote_state.secrets.outputs.secrets_arns["aws_sdksecret_key_secret"]
    },
    {
      namespace = "aws:autoscaling:launchconfiguration",
      name      = "SecurityGroups",
      value     = data.terraform_remote_state.elastic_beanstalk_security_group.outputs.group_ids["elastic-beanstalk-sg"]
    },
    {
      namespace = "aws:autoscaling:launchconfiguration",
      name      = "IamInstanceProfile",
      value     = data.terraform_remote_state.iam_roles.outputs.instance_profiles_ids["pulse-elastic-beanstalk-instance-role"]
    },
    {
      namespace = "aws:autoscaling:launchconfiguration",
      name      = "InstanceType",
      value     = var.elastic_beanstalk.instance_type
    },
    {
      namespace = "aws:autoscaling:launchconfiguration",
      name      = "DisableIMDSv1",
      value     = true
    },
    # { 
    #   namespace = "aws:autoscaling:launchconfiguration", 
    #   name = "EC2KeyName", 
    #   value = var.elastic_beanstalk.ec2_key_name 
    # },
    {
      namespace = "aws:elasticbeanstalk:managedactions",
      name      = "ServiceRoleForManagedUpdates",
      value     = "AWSServiceRoleForElasticBeanstalkManagedUpdates"
    },
    {
      namespace = "aws:elasticbeanstalk:managedactions",
      name      = "ManagedActionsEnabled",
      value     = var.elastic_beanstalk.managed_actions_enabled
    },
    {
      namespace = "aws:elasticbeanstalk:managedactions",
      name      = "PreferredStartTime",
      value     = var.elastic_beanstalk.preferred_start_time
    },
    {
      namespace = "aws:elasticbeanstalk:managedactions:platformupdate",
      name      = "UpdateLevel",
      value     = var.elastic_beanstalk.platform_update
    },
    {
      namespace = "aws:elasticbeanstalk:managedactions:platformupdate",
      name      = "InstanceRefreshEnabled",
      value     = var.elastic_beanstalk.instance_refresh_enabled
    },
    {
      namespace = "aws:autoscaling:trigger",
      name      = "UpperThreshold",
      value     = var.elastic_beanstalk.trigger_upper_threshold
    },
    {
      namespace = "aws:autoscaling:trigger",
      name      = "UpperBreachScaleIncrement",
      value     = var.elastic_beanstalk.trigger_upper_scale_increment
    },
    {
      namespace = "aws:autoscaling:trigger",
      name      = "LowerThreshold",
      value     = var.elastic_beanstalk.trigger_lower_threshold
    },
    {
      namespace = "aws:autoscaling:trigger",
      name      = "LowerBreachScaleIncrement",
      value     = var.elastic_beanstalk.trigger_lower_scale_increment
    },
    {
      namespace = "aws:autoscaling:trigger",
      name      = "Statistic",
      value     = var.elastic_beanstalk.trigger_statistic
    },
    {
      namespace = "aws:autoscaling:trigger",
      name      = "MeasureName",
      value     = var.elastic_beanstalk.trigger_measure_name
    },
    {
      namespace = "aws:autoscaling:trigger",
      name      = "Unit",
      value     = var.elastic_beanstalk.trigger_unit
    },
    {
      namespace = "aws:elasticbeanstalk:healthreporting:system",
      name      = "SystemType",
      value     = "enhanced"
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default",
      name      = "MatcherHTTPCode",
      value     = var.elastic_beanstalk.matcher_http_code
    },
    {
      namespace = "aws:elasticbeanstalk:environment",
      name      = "LoadBalancerType",
      value     = var.elastic_beanstalk.load_balancer_type
    },
    {
      namespace = "aws:autoscaling:asg",
      name      = "MinSize",
      value     = var.elastic_beanstalk.autoscaling_minsize
    },
    {
      namespace = "aws:autoscaling:asg",
      name      = "MaxSize",
      value     = var.elastic_beanstalk.autoscaling_maxsize
    },
    {
      namespace = "aws:elasticbeanstalk:command",
      name      = "BatchSize",
      value     = var.elastic_beanstalk.deployment_batchsize
    },
    {
      namespace = "aws:elasticbeanstalk:command",
      name      = "DeploymentPolicy",
      value     = var.elastic_beanstalk.deployment_policy
    },
    {
      namespace = "aws:elasticbeanstalk:command",
      name      = "IgnoreHealthCheck",
      value     = var.elastic_beanstalk.ignore_health_check
    },
    {
      namespace = "aws:autoscaling:updatepolicy:rollingupdate",
      name      = "MaxBatchSize",
      value     = var.elastic_beanstalk.rolling_update_max_batch_size
    },
    {
      namespace = "aws:autoscaling:updatepolicy:rollingupdate",
      name      = "RollingUpdateEnabled",
      value     = var.elastic_beanstalk.rolling_update_enabled
    },
    {
      namespace = "aws:autoscaling:updatepolicy:rollingupdate",
      name      = "RollingUpdateType",
      value     = var.elastic_beanstalk.rolling_update_type
    },
    {
      namespace = "aws:autoscaling:updatepolicy:rollingupdate",
      name      = "Timeout",
      value     = var.elastic_beanstalk.rolling_update_timeout
    },
    {
      namespace = "aws:elbv2:loadbalancer",
      name      = "SecurityGroups",
      value     = data.terraform_remote_state.elastic_beanstalk_security_group.outputs.group_ids["alb-elastic-beanstalk-sg"]
    },
    {
      namespace = "aws:elbv2:loadbalancer",
      name      = "ManagedSecurityGroup",
      value     = data.terraform_remote_state.elastic_beanstalk_security_group.outputs.group_ids["alb-elastic-beanstalk-sg"]
    },
    {
      namespace = "aws:elbv2:listener:default",
      name      = "Protocol",
      value     = var.elastic_beanstalk.listener_protocol_http
    },
    {
      namespace = "aws:elbv2:listener:default",
      name      = "ListenerEnabled",
      value     = var.elastic_beanstalk.listener_enabled
    },
    {
      namespace = "aws:elbv2:listener:443",
      name      = "Protocol",
      value     = var.elastic_beanstalk.listener_protocol_https
    },
    {
      namespace = "aws:elbv2:listener:443",
      name      = "SSLCertificateArns",
      value     = data.terraform_remote_state.certificate_manager.outputs.certificate_arns[var.elastic_beanstalk.ssl_certificate_id]
    },
    {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs",
      name      = "StreamLogs",
      value     = var.elastic_beanstalk.cloudwatch_logs
    },
    {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs",
      name      = "RetentionInDays",
      value     = var.elastic_beanstalk.cloudwatch_logs_retention
    },
    {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs:health",
      name      = "HealthStreamingEnabled",
      value     = true
    },
    {
      namespace = "aws:elasticbeanstalk:sns:topics",
      name      = "NotificationProtocol",
      value     = var.elastic_beanstalk.notification_protocol
    },
    {
      namespace = "aws:elasticbeanstalk:sns:topics",
      name      = "Notification Endpoint",
      value     = var.elastic_beanstalk.notification_endpoint
    }
    ],
    var.general_variables.environment == "prod" ? [
      {
        namespace = "aws:elasticbeanstalk:application:environment",
        name      = "Vas.Sdk.Storage:UseIAMRolesAuthentication",
        value     = var.elastic_beanstalk.use_iam_roles_authentication
      },
      { # Temporary Variable to Prevent Recurring Jobs from Running
        namespace = "aws:elasticbeanstalk:application:environment",
        name      = "Jobs:EnableRecurringJobs",
        value     = true
      },
      {
        namespace = "aws:elasticbeanstalk:application:environment",
        name      = "Vas.Sdk.Cache:Ssl",
        value     = true
      },
      {
        namespace = "aws:elasticbeanstalk:application:environment",
        name      = "RedisCache:Ssl",
        value     = true
      },
      {
        namespace = "aws:elasticbeanstalk:application:environment",
        name      = "Serilog:WriteTo:1:Args:serverUrl",
        value     = "http://10.152.40.81:5341"
      },
      {
        namespace = "aws:elasticbeanstalk:application:environment",
        name      = "Jobs:ProcessNewComputeHerds",
        value     = true
      },
      {
        namespace = "aws:elasticbeanstalk:application:environment",
        name      = "Jobs:EnableOnlyZoneIntegrationDispatcher",
        value     = false
      },
  ] : [])
}