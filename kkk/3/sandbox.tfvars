pulse_iam = {

  # Group of roles to be created.
  roles = [
    {
      role_name        = "pulse-seq-instance-role"
      instance_profile = true
      description      = "Pulse SEQ EC2 instance role created by terraform"
      assume_policy    = "./role_policies_assume/assume-services.json"
      policies_vars = {
        principal_services = ["ec2.amazonaws.com"]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    },
    {
      role_name                 = "pulse-break-glass-role-ro"
      description               = "Allow an iam user to have view only access to login without sso."
      role_max_session_duration = 21600
      assume_policy             = "./role_policies_assume/assume-break-glass-policy.json"
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/ReadOnlyAccess"
      }
      role_policies = {
        policy1 = "./role_policies/break-glass-region.json"
      }
      policies_vars = {
        trusted-account  = "221515991534"
        break-glass-user = "break-glass-ro"
      }
    },
    {
      role_name                 = "pulse-break-glass-role-admin"
      description               = "Allow an iam user to have admin access to login without sso."
      role_max_session_duration = 21600
      assume_policy             = "./role_policies_assume/assume-break-glass-policy.json"
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
      role_policies = {
        policy1 = "./role_policies/break-glass-region.json"
      }
      policies_vars = {
        trusted-account  = "221515991534"
        break-glass-user = "break-glass-admin"
      }
    },
    {
      role_name     = "jobsrunner-codebuild-role"
      description   = "jobsrunner role for codebuild created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/jobsrunner-codebuild-role-policy.json"
      }
      policies_vars = {
        pulse_buckets_names = ["code-pipeline-artifacts-bucket"]
        kms_alias           = "code-pipeline-jobsrunner"
        principal_services  = ["codebuild.amazonaws.com"]
        secrets_name        = ["service/github/token"]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk"
      }
    },
    {
      role_name     = "jobsrunner-codepipeline-role"
      description   = "jobsrunner role for codepipeline created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/jobsrunner-codepipeline-role-policy.json"
      }
      policies_vars = {
        pulse_buckets_names = ["code-pipeline-artifacts-bucket"]
        kms_alias           = "code-pipeline-jobsrunner"
        principal_services  = ["codepipeline.amazonaws.com"]
      }
    },
    # The service uses this to setup ECS
    {
      role_name     = "pulse-cluster-task-execution-role"
      description   = "Pulse cluster task execution role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/pulse-cluster-task-execution-role-policy.json"
      }
      policies_vars = {
        principal_services = ["ecs-tasks.amazonaws.com"]
        kms_alias          = "secret-manager"
        ecr_repo_list = [
          "alerts-api",
          "animal-movements-api",
          "api-proxy",
          "auth-api",
          "feed-api",
          "genetics-api",
          "genetics-sync",
          "genetics-etl",
          "herd-api",
          "iam-audit",
          "onpremise-sync-api",
          "ops-api",
          "parlors-api",
          "pulse-api",
          "pulse-jobsrunner"
        ]
      }
    },
    { # This role must be removed after applying new roles.
      role_name     = "pulse-cluster-task-role"
      description   = "Pulse cluster task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/pulse-cluster-task-role-policy.json"
      }
      policies_vars = {
        fargate_cluster    = "pulse-cluster"
        principal_services = ["ecs-tasks.amazonaws.com"]
      }

      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
      }
    }, # Here ends the pulse-cluster-task-role.
    {
      role_name     = "pulse-auth-task-role"
      description   = "Pulse auth cluster task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-auth-task-role-policy.json"
      }
      policies_vars = {
        principal_services   = ["ecs-tasks.amazonaws.com"]
        fargate_cluster      = "pulse-cluster"
        ses_identities       = ["vas.com"]
        pulse_buckets_names  = ["vas-api-files-public", "vas-api-files"]
        sns_subscribers_list = ["vas-ops-dairies", "vas-ops-zone-integrations"]
        sns_publishers_list  = ["vas-auth-users", "vas-ops-outgoing-integrations"]
      }
    },
    {
      role_name     = "pulse-ops-task-role"
      description   = "Pulse ops cluster task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-ops-task-role-policy.json"
      }
      policies_vars = {
        principal_services   = ["ecs-tasks.amazonaws.com"]
        fargate_cluster      = "pulse-cluster"
        ses_identities       = ["vas.com"]
        pulse_buckets_names  = ["vas-api-files-public", "vas-api-files-quarantine", "vas-api-files"]
        sns_subscribers_list = ["vas-parlors-milk-parlors", "vas-pulse-care-packages"]
        sns_publishers_list = [
          "vas-ops-addresses",
          "vas-ops-companies",
          "vas-ops-dairies",
          "vas-ops-dairy-vendor-integrations",
          "vas-ops-outgoing-integrations",
          "vas-ops-vendor-integrations",
          "vas-ops-zone-integrations",
          "vas-ops-zones",
          "vas-platform-notifications"
        ]
      }
    },
    {
      role_name     = "pulse-op-sync-task-role"
      description   = "Pulse on premise sync cluster task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-op-sync-task-role-policy.json"
      }
      policies_vars = {
        principal_services   = ["ecs-tasks.amazonaws.com"]
        fargate_cluster      = "pulse-cluster"
        pulse_buckets_names  = ["vas-api-files-public"]
        sns_subscribers_list = ["vas-parlors-milkings"]
        sns_publishers_list  = ["vas-worklists"]
      }
    },
    {
      role_name     = "pulse-herd-task-role"
      description   = "Pulse herd cluster task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-herd-task-role-policy.json"
      }
      policies_vars = {
        principal_services  = ["ecs-tasks.amazonaws.com"]
        fargate_cluster     = "pulse-cluster"
        pulse_buckets_names = ["vas-api-files-public"]
        sns_subscribers_list = [
          "vas-auth-users",
          "vas-genetics-matings",
          "vas-herd-daily-milkings",
          "vas-herd-item-changes",
          "vas-ops-addresses",
          "vas-ops-companies",
          "vas-ops-dairies",
          "vas-ops-dairy-vendor-integrations",
          "vas-ops-outgoing-integrations",
          "vas-ops-zones",
          "vas-parlors",
          "vas-parlors-milkings",
          "vas-platform-genetics",
          "vas-platform-integrations",
          "vas-worklists"
        ]
        sns_publishers_list = [
          "vas-genetics-matings",
          "vas-herd-cowevents",
          "vas-herd-daily-milkings",
          "vas-herd-pens",
          "vas-platform-items",
          "vas-pulse-care-packages"
        ]
        # Used buckets     = ["vas-api-files-public"]
      }
    },
    {
      role_name     = "pulse-feed-task-role"
      description   = "Pulse feed cluster task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-feed-task-role-policy.json"
      }
      policies_vars = {
        principal_services = ["ecs-tasks.amazonaws.com"]
        fargate_cluster    = "pulse-cluster"
        # Used buckets     = ["vas-api-files-public"]
      }
    },
    {
      role_name     = "pulse-parlors-task-role"
      description   = "Pulse parlors cluster task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-parlors-task-role-policy.json"
      }
      policies_vars = {
        principal_services  = ["ecs-tasks.amazonaws.com"]
        fargate_cluster     = "pulse-cluster"
        pulse_buckets_names = ["vas-api-files-public", "vas-api-files-quarantine", "vas-api-files"]
        sns_subscribers_list = [
          "vas-herd-pens",
          "vas-ops-dairies",
          "vas-ops-zone-integrations",
          "vas-ops-zones",
          "vas-parlors-milkings"
        ]
        sns_publishers_list = [
          "vas-parlors",
          "vas-parlors-milk-parlors",
          "vas-platform-integrations"
        ]
      }
    },
    {
      role_name     = "pulse-alerts-task-role"
      description   = "Pulse alerts cluster task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-alerts-task-role-policy.json"
      }
      policies_vars = {
        principal_services = ["ecs-tasks.amazonaws.com"]
        fargate_cluster    = "pulse-cluster"
      }
    },
    {
      role_name     = "pulse-generic-task-role"
      description   = "Pulse generic cluster task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-generic-task-role-policy.json"
      }
      policies_vars = {
        principal_services  = ["ecs-tasks.amazonaws.com"]
        fargate_cluster     = "pulse-cluster"
        pulse_buckets_names = ["vas-api-files-public", "vas-api-files-quarantine", "vas-api-files"]
      }
    },
    {
      role_name     = "pulse-genetics-task-role"
      description   = "Pulse genetics task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-genetics-task-role-policy.json"
      }
      policies_vars = {
        principal_services   = ["ecs-tasks.amazonaws.com"]
        fargate_cluster      = "pulse-cluster"
        sns_subscribers_list = ["vas-genetics-matings", "vas-platform-integrations"]
        sns_publishers_list  = ["vas-genetics-matings"]
      }
    },
    {
      role_name     = "pulse-monolith-task-role"
      description   = "Pulse monolith task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-monolith-task-role-policy.json"
      }
      policies_vars = {
        principal_services = ["ecs-tasks.amazonaws.com"]
        fargate_cluster    = "pulse-cluster"
        sqs_queues_list    = ["vas-pulse-medicine-used-message"]
        sns_subscribers_list = [
          "integrations-parlors-dailymilkings",
          "vas-genetics-matings",
          "vas-herd-daily-milkings",
          "vas-ops-addresses",
          "vas-ops-dairies",
          "vas-ops-outgoing-integrations",
          "vas-ops-zone-integrations",
          "vas-ops-zones",
          "vas-parlors",
          "vas-parlors-milk-parlors",
          "vas-parlors-milkings",
          "vas-platform-integrations",
          "vas-worklists"
        ]
        sns_publishers_list = [
          "vas-auth-users",
          "vas-genetics-matings",
          "vas-herd-cowevents",
          "vas-herd-daily-milkings",
          "vas-herd-pens",
          "vas-ops-addresses",
          "vas-ops-companies",
          "vas-ops-dairies",
          "vas-ops-dairy-vendor-integrations",
          "vas-ops-zone-integrations",
          "vas-ops-zones",
          "vas-platform-integrations",
          "vas-platform-items",
          "vas-platform-notifications",
          "vas-pulse-care-packages"
        ]
      },
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
      }
    },
    {
      role_name     = "pulse-feednext-task-role"
      description   = "Pulse feednext cluster task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-feednext-task-role-policy.json"
      }
      policies_vars = {
        principal_services  = ["ecs-tasks.amazonaws.com"]
        pulse_buckets_names = ["vas-feedcomp"]
        sns_publishers_list = ["vas-platform-feed"]
        sns_subscribers_list = [
          "vas-herd-pens",
          "vas-ops-dairies",
          "vas-ops-zone-integrations",
          "vas-platform-feed"
        ]
      }
    },
    {
      role_name     = "pulse-feednext-rc-task-role"
      description   = "Pulse feednext-rc cluster task role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ms-roles/pulse-feednext-rc-task-role-policy.json"
      }
      policies_vars = {
        principal_services  = ["ecs-tasks.amazonaws.com"]
        pulse_buckets_names = ["vas-feedcomp"]
        sns_publishers_list = ["vas-platform-feed"]
        sns_subscribers_list = [
          "vas-herd-pens",
          "vas-ops-dairies",
          "vas-ops-zone-integrations",
          "vas-platform-feed"
        ]
      }
    },
    {
      role_name     = "pulse-elastic-beanstalk-role"
      description   = "Pulse elastic beanstalk role created by terraform"
      assume_policy = "./role_policies_assume/assume-services.json"
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
        policy_arn2 = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
      }
      policies_vars = {
        principal_services = ["elasticbeanstalk.amazonaws.com"]
      }
    },
    {
      role_name        = "pulse-elastic-beanstalk-instance-role"
      instance_profile = true
      description      = "Pulse elastic beanstalk instance role created by terraform"
      assume_policy    = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/elastic-beanstalk-instance-role-policy.json"
        #policy2 = "./role_policies/efs-elastic-beanstalk-access.json"
      }
      policies_vars = {
        #efs_name           = "efs-carepackages"
        kms_alias          = "secret-manager"
        principal_services = ["ec2.amazonaws.com"]
        sns_account_id     = "586815333384"
        sns_topics_list    = ["vas-herd-pens", "vas-platform-feed", "vas-platform-integrations", "vas-platform-items", "vas-platform-kpis", "vas-platform-notifications", "vas-pulse-care-packages", "vas-ops-dairies", "vas-ops-zones", "vas-ops-companies"]
        buckets_names      = ["vas-api-files", "vas-api-files-quarantine", "vas-api-files-public"]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
        policy_arn2 = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
        policy_arn5 = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
        policy_arn6 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        policy_arn7 = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
        policy_arn8 = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
        policy_arn9 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    },
    {
      role_name        = "pulse-elastic-beanstalk-jobsrunner-instance-role"
      instance_profile = true
      description      = "Pulse elastic beanstalk jobsrunner instance role created by terraform"
      assume_policy    = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/elastic-beanstalk-jobsrunner-instance-role-policy.json"
      }
      policies_vars = {
        kms_alias          = "secret-manager"
        principal_services = ["ec2.amazonaws.com"]
        sns_account_id     = "586815333384"
        sns_topics_list = [
          "vas-herd-pens",
          "vas-ops-companies",
          "vas-ops-dairies",
          "vas-ops-zones",
          "vas-platform-items",
          "vas-platform-kpis",
          "vas-platform-notifications",
          "vas-platform-feed",
          "vas-platform-integrations"
        ]
        buckets_names = [
          "vas-api-files",
          "vas-api-files-quarantine",
          "vas-api-files-public",
          "vas-api-files-public",
          "vas-api-files-quarantine",
          "vas-api-files"
        ]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
        policy_arn2 = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
        policy_arn5 = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
        policy_arn6 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        policy_arn7 = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
        policy_arn8 = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
        policy_arn9 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    },
    {
      role_name        = "pulse-elastic-beanstalk-carepackages-instance-role"
      instance_profile = true
      description      = "Pulse elastic beanstalk carepackages instance role created by terraform"
      assume_policy    = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/elastic-beanstalk-carepackages-instance-role-policy.json"
        #policy2 = "./role_policies/efs-elastic-beanstalk-access.json"
      }
      policies_vars = {
        #efs_name           = "efs-carepackages"
        kms_alias            = "secret-manager"
        principal_services   = ["ec2.amazonaws.com"]
        sns_account_id       = "586815333384"
        sns_subscribers_list = ["vas-ops-dairies"]
        sns_publishers_list  = ["vas-platform-items", "vas-pulse-care-packages"]
        buckets_names = [
          "vas-api-files",
          "vas-api-files-quarantine",
          "vas-api-files-public",
          "vas-api-files-public",
          "vas-api-files-quarantine",
          "vas-api-files"
        ]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
        policy_arn2 = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
        policy_arn5 = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
        policy_arn6 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        policy_arn7 = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
        policy_arn8 = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
        policy_arn9 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    },
    {
      role_name     = "mongodbatlas-credentials-secrets-role"
      description   = "Retrieve mongodbatlas credentials role created by terraform"
      assume_policy = "./role_policies_assume/assume-account.json"
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
      }
      role_policies = {
        policy1 = "./role_policies/allow-kms-decrypt.json"
      }
      policies_vars = {
        kms_alias = "secret-manager"
      }
    },
    {
      role_name     = "aws-events-invoke-ecs-role"
      description   = "Pulse ecs-events-role"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ecs-events-policy.json"
      }
      policies_vars = {
        principal_services = ["events.amazonaws.com"]
      }
    },
    {
      role_name     = "config-to-sns-remediation-execution-role"
      description   = "role for required-tag-remediation config rule to post message into SNS"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/allow-config-publish-sns.json"
      }
      policies_vars = {
        principal_services = ["ssm.amazonaws.com"]
        sns_topics_list    = ["vas-devops-required-tag-remediation-sns"]
      }
    },
    {
      role_name     = "iam-audit-role"
      description   = "Regular IAM audit role created by terraform"
      assume_policy = "./role_policies_assume/assume-audit.json"
      policies_vars = {
        account_id = "867082668577"
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/SecurityAudit"
      }
    },
    {
      role_name     = "pulse-sls-deployment-role"
      description   = "Deployment role to be assumed by Cloudformation & Lambda to provision SLS Resources"
      assume_policy = "./role_policies_assume/assume-services.json"
      policies_vars = {
        principal_services = ["cloudformation.amazonaws.com", "lambda.amazonaws.com"]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
    },
    {
      role_name        = "pulse-it-utils-instance-role"
      instance_profile = true
      description      = "pulse-it-utils EC2 instance role created by terraform"
      assume_policy    = "./role_policies_assume/assume-services.json"
      policies_vars = {
        principal_services = ["ec2.amazonaws.com"]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    },
    {
      role_name   = "developer-api-customExecutionRole-us-west-2-sandbox"
      description = "Custom execution role for developer-api"
      role_policies = {
        policy1 = "./role_policies/sls-developer-api-execution-role-policy.json"
      }

      assume_policy = "./role_policies_assume/assume-services.json"
      policies_vars = {
        principal_services = ["lambda.amazonaws.com"]
        secrets_name = [
          "service/redis/serverless/connectionstring/js/readonly",
          "service/redis/serverless/connectionstring/js/writer",
          "service/platform/token",
          "service/general/c2c/shared-secret"
        ]
      }

      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
      }
    },
    {
      role_name        = "pulse-packages-instance-profile-role"
      instance_profile = true
      description      = "EC2 instance role created by terraform"
      assume_policy    = "./role_policies_assume/assume-services.json"
      policies_vars = {
        principal_services = ["ec2.amazonaws.com"]
      }
      role_policies = {
        policy1 = "./role_policies/ec2-instance-role-bucket-access.json"
      }
      policies_vars = {
        pulse_buckets_names = ["pulse-package-installer"]
        principal_services  = ["ec2.amazonaws.com"]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    },
    {
      role_name     = "sls-devops-deployment-role"
      description   = "Devops role to be assumed by  Lambda to provision SLS Resources"
      assume_policy = "./role_policies_assume/assume-services.json"
      policies_vars = {
        principal_services = ["cloudformation.amazonaws.com", "lambda.amazonaws.com"]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
    },
    # DMS Policies
    {
      role_name     = "dms-s3-target-role"
      description   = "Custom execution role for DMS test S3 target"
      assume_policy = "./role_policies_assume/assume-services.json"

      role_policies = {
        policy1 = "./role_policies/dms-s3-access.json"
      }

      policies_vars = {
        principal_services = ["dms.amazonaws.com", "dms.us-west-2.amazonaws.com"]
        buckets_names      = ["vas-data-repo-raw-us-west-2-data", "vas-dms-test-us-west-2-sandbox"]
      }
    },
    {
      role_name     = "dms-secrets-role"
      description   = "Custom execution role for DMS to fetch secrets"
      assume_policy = "./role_policies_assume/assume-services.json"

      role_policies = {
        policy1 = "./role_policies/dms-secret-access.json"
      }

      policies_vars = {
        principal_services = ["dms.amazonaws.com", "dms.us-west-2.amazonaws.com"]
        kms_alias          = "secret-manager"
      }
    },
    {
      role_name     = "dms-vpc-role"
      description   = "Custom role for dms"
      assume_policy = "./role_policies_assume/assume-services.json"

      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
      }

      policies_vars = {
        principal_services = ["dms.amazonaws.com", "dms.us-west-2.amazonaws.com"]
      }
    },
    {
      role_name     = "eventbridge-endpoint-role"
      description   = "Role for eventbridge to invoke endpoints"
      assume_policy = "./role_policies_assume/assume-services.json"
      policies_vars = {
        principal_services = ["events.amazonaws.com"]
      }

      role_policies = {
        policy1 = "./role_policies/eventbridge-endpoint-policy.json"
      }
    },
    {
      role_name     = "ecs-code-deploy-role"
      description   = "Custom role for ECS deployment using code deploy"
      assume_policy = "./role_policies_assume/assume-services.json"

      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
      }
      role_policies = {
        policy1 = "./role_policies/allow-sns-publish.json"
        policy2 = "./role_policies/allow-kms-sns-decrypt.json"
      }

      policies_vars = {
        principal_services = ["codedeploy.amazonaws.com"]
        sns_name           = "vas-devops-codedeploy-status"
        kms_alias          = "sns-general-kms-key"
      }
    },
    # ImageBuilder
    {
      role_name        = "imagebuilder-ec2-role"
      description      = "Custom role for Image builder"
      assume_policy    = "./role_policies_assume/assume-services.json"
      instance_profile = true
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
        policy_arn2 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        policy_arn3 = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
        policy_arn4 = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
      }

      policies_vars = {
        principal_services = ["ec2.amazonaws.com"]
      }
    },
    {
      role_name     = "sls-lambda-aggregators-role"
      description   = "Role for lambdas in MS to assume"
      assume_policy = "./role_policies_assume/assume-account.json"
      policies_vars = {
        principal_services = ["lambda.amazonaws.com"]
        sqs_queues_list    = ["vas-parlors-milkings"]
        sns_topics_list = [
          "vas-platform-integrations",
          "vas-platform-notifications",
          "vas-platform-kpis",
          "vas-genetics-matings",
          "vas-parlors-milkings"
        ]
        secrets_name = [
          "service/partners/apikey",
          "service/sls/auth/usertoken",
          "service/agsource/token",
          "service/platform/token"
        ]
        buckets_names = [
          "morpheus-api-files/uploads/14/dairies",
          "morpheus-api-files/temp",
        ]
        # cross account access that must be removed in the future:
        cross_messaging_account = "586815333384"
        cross_queue_list        = ["vas-parlors-milkings"]
        cross_topic_list = [
          "vas-platform-integrations",
          "vas-platform-notifications",
          "vas-platform-kpis",
          "vas-genetics-matings",
          "vas-parlors-milkings"
        ]
      }
      role_policies = {
        policy1 = "./role_policies/sls-lambda-aggregators.json"
      }
    },
    # SLS Github 
    {
      role_name     = "pulse-sls-integrations-role"
      description   = "role for sls-integrations github repo created by terraform"
      assume_policy = "./role_policies_assume/assume-federated-github-identity.json"
      policies_vars = {
        allowed_repositories = [
          "repo:vas-dev/vas-sls-integrations:*",
          "repo:vas-dev/vas-api-developer:*"
        ]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
    },
    # OIDC
    {
      role_name     = "OIDC-github-devops-cicd"
      description   = "Role for OIDC devops CI/CD"
      assume_policy = "./role_policies_assume/assume-federated-github-identity.json"
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
      policies_vars = {
        allowed_repositories = [
          "repo:vas-dev/vas-devops-pulse:*",
          "repo:vas-dev/vas-api-proxy:*"
        ]
      }
    },
    {
      role_name     = "OIDC-github-ecs-api-cicd"
      description   = "OIDC role for Github to deploy from e.g. vas-api- repos"
      assume_policy = "./role_policies_assume/assume-federated-github-identity.json"
      policies_vars = {
        allowed_repositories = [
          "repo:vas-dev/vas-api-*:*",
          "repo:vas-dev/vas-devops-security:*",
          "repo:vas-dev/Morpheus:*",
          "repo:vas-dev/Genetics-Sync:*",
          "repo:vas-dev/Genetics-etl:*"
        ]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
        policy_arn2 = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
      }
    },
    {
      role_name     = "OIDC-github-static-websites-cicd"
      description   = "Role for Github to deploy tech docs"
      assume_policy = "./role_policies_assume/assume-federated-github-identity.json"
      policies_vars = {
        allowed_repositories = ["repo:vas-dev/vas-docs-*:*"]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
        policy_arn2 = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
        policy_arn3 = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
      }
    },
    {
      role_name     = "OIDC-github-serverless-cicd"
      description   = "Role for Github to deploy serverless application"
      assume_policy = "./role_policies_assume/assume-federated-github-identity.json"
      policies_vars = {
        allowed_repositories = [
          "repo:vas-dev/vas-sls-integrations:ref:refs/heads/master",
          "repo:vas-dev/vas-sls-datascience:*",
          "repo:vas-dev/vas-sls-devops:*"
        ]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
    },
    {
      role_name     = "OIDC-github-eb-cicd"
      description   = "Role for OIDC Elastic Beanstalk CI/CD"
      assume_policy = "./role_policies_assume/assume-federated-github-identity.json"
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
        policy_arn2 = "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk"
        policy_arn3 = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
      }
      policies_vars = {
        allowed_repositories = [
          "repo:vas-dev/vas-api-carepackages:*",
          "repo:vas-dev/Morpheus:*"
        ]
      }
    },
    # Instances
    {
      role_name        = "dc305-instance-profile-role"
      instance_profile = true
      description      = "EC2 instance role created by terraform for DC305 team"
      assume_policy    = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ec2-instance-role-get-secrets.json"
      }
      policies_vars = {
        principal_services = ["ec2.amazonaws.com"]
        secrets_name       = ["instances/dc305/password"]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    },
    {
      role_name        = "platform-ingestion-profile-role"
      instance_profile = true
      description      = "EC2 instance role created by terraform for platform ingestion instance"
      assume_policy    = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ec2-instance-role-get-secrets.json"
      }
      policies_vars = {
        principal_services = ["ec2.amazonaws.com"]
        secrets_name       = ["instances/platform-ingestion/secrets"]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    },
    {
      role_name        = "pulse-github-runner-profile-role"
      instance_profile = true
      description      = "EC2 instance role created by terraform for pulse GitHub runner"
      assume_policy    = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/ec2-instance-role-get-secrets.json"
      }
      policies_vars = {
        principal_services = ["ec2.amazonaws.com"]
        secrets_name       = ["instances/pulse/github-runner/tokens", "instances/sonarqube/db/password"]
      }
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    },
    # S3 Bucket Replication role
    {
      role_name     = "general-s3-bucket-replication-role"
      description   = "Role for replication from Source buckets into Destination buckets"
      assume_policy = "./role_policies_assume/assume-services.json"
      role_policies = {
        policy1 = "./role_policies/general-s3-bucket-replication.json"
      }
      policies_vars = {
        principal_services  = ["s3.amazonaws.com", "batchoperations.s3.amazonaws.com"]
        source_buckets      = ["securityhub-vas-organization-audit-logs-sandbox", "replication-source-bucket-us-west-2-sandbox"]
        destination_buckets = ["securityhub-vas-organization-audit-logs-destination", "replication-destination-bucket-us-west-2-personal"]
      }
    },
    {
      role_name     = "AWSControlTowerExecution"
      description   = "Role to Allows full account access for enrollment"
      assume_policy = "./role_policies_assume/assume-controltower.json"
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
      policies_vars = {}
    },
    {
      role_name     = "aws-controltower-ConfigRecorderRole-customer-created"
      description   = "Role to allow Config to record changes"
      assume_policy = "./role_policies_assume/assume-services.json"
      policies_vars = {
        principal_services = ["config.amazonaws.com"]
      },
      policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/ReadOnlyAccess",
        policy_arn2 = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
      }
    },
    {
      role_name     = "aws-datasync-cross-account-service-role"
      description   = "Role to allow DataSync to access S3"
      assume_policy = "./role_policies_assume/assume-services.json"
      policies_vars = {
        principal_services  = ["datasync.amazonaws.com"],
        source_buckets      = ["replication-source-bucket-us-west-2-sandbox"],
        destination_buckets = ["replication-destination-bucket-us-west-2-personal"]
      },
      role_policies = {
        policy1 = "./role_policies/datasync-s3-cross-account-policy.json"
      }
    },
    {
      role_name     = "rds-sql-server-backup-restore-role"
      description   = "Allow RDS to access S3 for backup and restore"
      assume_policy = "./role_policies_assume/assume-services.json"
      policies_vars = {
        kms_alias          = "aws/rds",
        principal_services = ["rds.amazonaws.com"],
        buckets_names      = ["vas-alta-gps-backup-sandbox"]
      },
      role_policies = {
        policy1 = "./role_policies/rds-sql-server-backup-restore.json"
      }
    }
    # {
    #   role_name     = "OIDC-github-s3-updates-cicd"
    #   description   = "Role for Github to upload files to S3 bucket"
    #   assume_policy = "./role_policies_assume/assume-federated-github-identity.json"
    #   role_policies = {
    #     policy1 = "./role_policies/parlorboss-s3-upload.json"
    #   }
    #   policies_vars = {
    #     bucket_name          = "vas-platform-sandbox"
    #     allowed_repositories = ["repo:vas-dev/ParlorBoss:*"]
    #   }
    # }
  ]

  # IAM Policies to be created.
  policies = [
    {
      name        = "sls-developer-console-policy"
      policy_path = "./role_policies/sls-developer-console.json"
      policy_vars = {
        team_name           = "integrations"
        pulse_buckets_names = ["vas-data-kpis"]
      }
    },
    {
      name        = "sls-devops-deployment-policy"
      policy_path = "./role_policies/sls-developer-deployment.json",
      policy_vars = {
        pulse_buckets_names = ["vas-sls-deployment"]
        team_name           = "devops"
      }
    },
    {
      name        = "sls-devops-console-policy"
      policy_path = "./role_policies/sls-developer-console.json"
      policy_vars = {
        pulse_buckets_names = ["vas-sls-devops"]
        team_name           = "devops"
      }
    },
    {
      name        = "data-developer-console-policy" # match permission_sets 
      policy_path = "./role_policies/data-developer-console.json"
      policy_vars = {}
    },
    {
      name        = "data-developer-console-ro-policy" # match permission_sets 
      policy_path = "./role_policies/data-developer-console-ro.json"
      policy_vars = {}
    },
    {
      name        = "sls-developer-deployment-integrations-policy" # match permission_sets 
      policy_path = "./role_policies/sls-developer-deployment.json"
      policy_vars = {
        pulse_buckets_names = ["vas-sls-deployment-integrations", "vas-sls-deployment-developer-api"]
        team_name           = "integrations"
        secret_names        = ["service/partners/apikey"]
      }
    },
    {
      name        = "sls-developer-deployment-datascience-policy" # match permission_sets 
      policy_path = "./role_policies/sls-developer-deployment.json"
      policy_vars = {
        pulse_buckets_names = ["vas-sls-deployment-datascience"] # Bucket Name should be defined
        team_name           = "datascience"
      }
    },
    {
      name        = "sls-developer-deployment-devops-policy" # match permission_sets 
      policy_path = "./role_policies/sls-developer-deployment.json"
      policy_vars = {
        pulse_buckets_names = ["vas-sls-deployment-devops"] # Bucket Name should be defined
        team_name           = "devops"
      }
    },
    {
      name        = "sls-developer-deployment-dms-policy" # match permission_sets 
      policy_path = "./role_policies/datascience-dms-full-access.json"
      policy_vars = {
        pulse_buckets_names = ["vas-sls-deployment-devops"] # Bucket Name should be defined
        team_name           = "datascience"
      }
    }
  ]

  # IAM Users to be created.
  users = []

  # IAM groups and policies.
  groups = [
    {
      group_name = "developers-ecs-access-ro"
      group_policies = {
        policy1 = "./group_policies/ecs-access-read-only.json"
      }
    },
    {
      group_name = "developers-serverless-access-full"
      group_policies = {
        policy1 = "./group_policies/tagged_policies/s3-sls-deployment-bucket.json"
        policy2 = "./group_policies/cloudwatch-logs-access.json",
        policy3 = "./group_policies/iam-assume-role-access.json",
        policy4 = "./group_policies/cloudwatch-logs-access.json",
        policy5 = "./group_policies/domain-manager-access.json",
        policy6 = "./group_policies/tagged_policies/iam-automation-access.json",
        policy7 = "./group_policies/lambda-access.json"
      }
      group_policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
        policy_arn2 = "arn:aws:iam::aws:policy/IAMUserChangePassword"
      }
      policies_vars = {
        pulse_buckets_names = [
          "genetics-api-files",
          "vas-api-files",
          "vas-api-files-public",
          "vas-api-files-quarantine",
          "vas-dc305-support-files",
          "vas-dc305-updates"
        ],
        domain_url        = "sandbox.integrations-vas.com",
        resource_tag_team = "integrations"
      }
    },
    {
      group_name = "developers-serverless-cloudwatch-only"
      group_policies = {
        policy1 = "./group_policies/cloudwatch-logs-access.json"
      }
    },
    {
      group_name = "developers-serverless-datascience-team"
      group_policies = {
        policy1 = "./group_policies/tagged_policies/api-gateway-access.json",
        policy2 = "./group_policies/tagged_policies/cloudformation-access.json",
        policy3 = "./group_policies/tagged_policies/sns-access.json"
      }
      policies_vars = {
        resource_tag_team = "datascience",
        cloud_formation_stacks_list = [
          "integrations",
          "developer-api"
        ]
      }
    },
    {
      group_name = "developers-serverless-integrations-team"
      group_policies = {
        policy1 = "./group_policies/tagged_policies/api-gateway-access.json",
        policy2 = "./group_policies/tagged_policies/cloudformation-access.json",
        policy3 = "./group_policies/iam-create-role-integrations-access.json",
        policy4 = "./group_policies/tagged_policies/sns-access.json"
      }
      policies_vars = {
        resource_tag_team = "integrations",
        cloud_formation_stacks_list = [
          "integrations",
          "developer-api"
        ]
      }
    },
    {
      group_name = "developers-serverless-s3-deploy"
      group_policies = {
        policy1 = "./group_policies/s3-bucket-read-only-access.json",
        policy2 = "./group_policies/cloudwatch-events-access.json",
        policy3 = "./group_policies/s3-bucket-teams-access.json"
      }
      policies_vars = {
        pulse_buckets_names = [
          "vas-sls-deploy-integrations",
          "vas-sls-deploy-developer-api",
          "vas-sls-deploy-datascience",
          "vas-dc305-support-files",
          "vas-dc305-updates"
        ],
      }
    },
    {
      group_name = "developers-serverless-secretsmanager-datascience"
      group_policies = {
        policy1 = "./group_policies/tagged_policies/secrets-manager-read-only.json"
      }
      policies_vars = {
        resource_tag_team = "datascience"
      }
    },
    {
      group_name = "developers-serverless-secretsmanager-devops"
      group_policies = {
        policy1 = "./group_policies/tagged_policies/secrets-manager-read-only.json"
      }
      policies_vars = {
        resource_tag_team = "devops"
      }
    },
    {
      group_name = "developers-serverless-secretsmanager-integrations"
      group_policies = {
        policy1 = "./group_policies/tagged_policies/secrets-manager-read-only.json"
      }
      policies_vars = {
        resource_tag_team = "integrations"
      }
    },
    {
      group_name = "developers-serverless-support-leads"
      group_policies = {
        policy1 = "./group_policies/tagged_policies/cloudformation-access.json",
        policy2 = "./group_policies/s3-bucket-read-only-access.json",
        policy3 = "./group_policies/tagged_policies/secrets-manager-read-only.json"
      }
      group_policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess",
        policy_arn2 = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
      }
      policies_vars = {
        pulse_buckets_names = [
          "vas-dc305-support-files",
          "vas-dc305-updates"
        ],
        resource_tag_team = "support-leads",
        cloud_formation_stacks_list = [
          "integrations",
          "developer-api"
        ]
      }
    },
    {
      group_name = "s3-full-access"
      group_policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
      }
    },
    {
      group_name = "s3-pulse-api-files"
      group_policies = {
        policy1 = "./group_policies/tagged_policies/s3-sls-deployment-bucket.json"
      }
      group_policies_arns = {
        policy_arn1 = "arn:aws:iam::aws:policy/IAMUserChangePassword"
      }
      policies_vars = {
        pulse_buckets_names = [
          "vas-api-files",
          "vas-api-files-public",
          "vas-api-files-quarantine",
          "vas-dc305-support-files",
          "vas-dc305-updates",
          "genetics-api-files"
        ],
      }
    },
    {
      group_name = "s3-vas-dc305-support-updates-files"
      group_policies = {
        policy1 = "./group_policies/s3-bucket-read-only-access.json"
      }
      policies_vars = {
        pulse_buckets_names = [
          "vas-dc305-support-files",
          "vas-dc305-updates"
        ],
      }
    },
    {
      group_name = "sensitive-ec2-ssm-access"
      group_policies = {
        policy1 = "./group_policies/sensitive-ec2-ssm-access.json"
        policy2 = "./group_policies/allow-ssm-view.json"
      }
    },
    {
      group_name = "nonsensitive-ec2-ssm-access"
      group_policies = {
        policy1 = "./group_policies/nonsensitive-ec2-ssm-access.json"
        policy2 = "./group_policies/allow-ssm-view.json"
      }
    },
  ]
}
