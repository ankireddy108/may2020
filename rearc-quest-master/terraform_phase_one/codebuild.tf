# ECR Repository to store Docker image after it has been built

resource "aws_ecr_repository" "rearc-quest-container-repo" {
  name = "rearc-quest-container-repo"
}

# Codebuild project to create the Docker image to use when deploying the project.
# Docker image is built from a GitHub repo containing a Dockerfile and buildspec.yml
# instructions.

resource "aws_codebuild_project" "rearc-quest-codebuild-project" {
  name          = "rearc-quest-codebuild-project"
  service_role  = aws_iam_role.rearc-quest-codebuild-role.arn
  build_timeout = "10"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name = "REARC_QUEST_ECR_URL"
      value = aws_ecr_repository.rearc-quest-container-repo.repository_url
    }
    privileged_mode = true
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/ankireddy108/may2020.git"
    git_clone_depth = 1
    buildspec = "buildspec.yml"
  }
  source_version = "master"
}

# GitHub webhook connected to the Codebuild project
# Forces a new build of the project to be created when a new commit is pushed to the
#  master branch of the repo containing the Dockerfile and buildspec.yml instructions.

resource "aws_codebuild_webhook" "rearc-quest-codebuild-webhook" {
  project_name = aws_codebuild_project.rearc-quest-codebuild-project.name

  filter_group {
    filter {
      type = "EVENT"
      pattern = "PUSH"
    }
    filter {
      type = "HEAD_REF"
      pattern = "master"
    }
  }
}
