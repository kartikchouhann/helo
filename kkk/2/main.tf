module "code_pipeline" {
  source                  = "../../../modules/codepipeline"
  code_build_project_name = var.code_pipeline.code_build_project_name
  code_build_compute_type = var.code_pipeline.code_build_compute_type
  code_build_image        = var.code_pipeline.code_build_image
  code_build_type         = var.code_pipeline.code_build_type
  github_repository_name  = var.code_pipeline.github_repository_name
  github_branch_name      = var.code_pipeline.github_branch_name
  github_org_name         = var.code_pipeline.github_owner_name
  s3_bucket_id            = data.terraform_remote_state.code_pipeline_bucket.outputs.pulse_buckets_ids.code_pipeline_bucket
  kms_key_arn             = data.terraform_remote_state.kms_code_pipeline.outputs.arns.code_pipeline
  code_build_role_arn     = data.terraform_remote_state.iam_roles.outputs.roles_arn["jobsrunner-codebuild-role"]
  code_pipeline_role_arn  = data.terraform_remote_state.iam_roles.outputs.roles_arn["jobsrunner-codepipeline-role"]
  github_token            = var.code_pipeline.github_token
  tags                    = var.code_pipeline.tags
  buildspec               = "buildspec-pulse-jobsrunner.yml"
  notifications           = var.code_pipeline.notifications

  codebuild_env_vars = {
    AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id
    AWS_REGION     = var.general_variables.main_region
    ECS_REPO_NAME  = "pulse-jobsrunner",
    EB_APP_NAME    = "pulse-jobsrunner",
    ENV_NAME       = var.general_variables.environment
    DOCKERFILE     = "Dockerfile-pulse-jobsrunner"
    BUILDS_BUCKET  = data.terraform_remote_state.code_pipeline_bucket.outputs.pulse_buckets_ids.code_pipeline_bucket
  }

  codebuild_secrets = {
    GH_TOKEN = data.terraform_remote_state.secrets.outputs.secrets_arns["GH-TOKEN"]
  }
}