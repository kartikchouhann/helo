## AWS Code Pipeline

code_pipeline = {
  code_build_project_name = "jobsrunner"
  code_build_compute_type = "BUILD_GENERAL1_SMALL"
  code_build_image        = "aws/codebuild/standard:5.0"
  environment             = "staging"
  code_build_type         = "LINUX_CONTAINER"
  github_repository_name  = "Morpheus"
  github_branch_name      = "master"
  github_owner_name       = "vas-dev"
  github_token            = "Token"

  notifications = [
    {
      name       = "jobsrunner-failure-notification"
      topic_name = "devops-notifications-emails"
      event_types = [
        "codepipeline-pipeline-pipeline-execution-canceled",
        "codepipeline-pipeline-pipeline-execution-failed"
      ]
    }
  ]

  tags = {
    project     = "devops"
    application = "terraform"
  }
}