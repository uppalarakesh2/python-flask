#ecr
# check back : MUTABLE

resource "aws_ecr_repository" "test-app" {
  name                 = "python-flask"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# code build
# main
# code build iam role
resource "aws_iam_role" "example" {
  name = "example"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
# policy for role
resource "aws_iam_role_policy" "example" {
  role = aws_iam_role.example.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "ecr:*",
        "ecs:*",
        "ec2:*",
        "logs:*"
      ]
    }
  ]
}
POLICY
}

# CREATE cb project

resource "aws_codebuild_project" "example" {
  name          = "test-project"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.example.arn
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "sample-app"
      stream_name = "python-flask"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/uppalarakesh2/python-flask.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"

  vpc_config {
    vpc_id = aws_vpc.My_VPC.id

    subnets = [
      aws_subnet.Prod_Private_Subnet1.id
    ]

    security_group_ids = [
      aws_security_group.My_VPC_Security_Group.id
    ]
  }
  tags = {
    Environment = "Test"
  }
}
# triggers (python)
# code build(trigger new build)

resource "aws_codebuild_webhook" "example" {
  project_name = aws_codebuild_project.example.name
  branch_filter = "master"
}

# github authentication
provider "github" {
  token = var.github_token
  owner = "uppalarakesh2"
}

data "github_repository" "example" {
  provider  = "github"
  full_name = "uppalarakesh2/python-flask"
}

resource "github_repository_webhook" "example" {
  active     = true
  events     = ["push"]
  repository = data.github_repository.example.name

  configuration {
    url          = aws_codebuild_webhook.example.payload_url
    secret       = aws_codebuild_webhook.example.secret
    content_type = "json"
    insecure_ssl = false
  }
}
