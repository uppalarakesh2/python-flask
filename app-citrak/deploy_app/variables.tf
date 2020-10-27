variable "aws_profile" {}
variable "aws_region" {}
variable "region" {
  default = "us-east-1"
}
variable "availabilityZone" {
  default = "us-east-1a"
}
variable "availabilityZone2" {
  default = "us-east-1b"
}
variable "instanceTenancy" {
  default = "default"
}
variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
variable "vpcCIDRblock" {
  default = "10.0.0.0/16"
}
variable "publicsubnetCIDRblock" {
  default = "10.0.0.0/24"
}
variable "publicsubnetCIDR2block" {
  default = "10.0.3.0/24"
}
variable "private1subnetCIDRblock" {
  default = "10.0.1.0/24"
}
variable "private2subnetCIDRblock" {
  default = "10.0.2.0/24"
}
variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
  type    = list
  default = ["0.0.0.0/0"]
}
variable "egressCIDRblock" {
  type    = list
  default = ["0.0.0.0/0"]
}
variable "mapPublicIP" {
  default = true
}

variable "github_token" {
  description = "GitHub token https://github.com/settings/tokens"
  default     = "#######"
}

variable "env" {
  description = "Name of the environment. Example: prod"
  default     =  "prod"
  # type        = string
}

variable "s3_bucket" {
  description = "'Name' tag for S3 bucket with terraform state."
  default     =  "mycitcode"
}

variable "dynamodb_table" {
  description = "DynamoDB table name for terraform lock."
  default     =  "mycittest"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

# variable "app_image" {
#   description = "Docker image to run in the ECS cluster"
#   default     = "661159855470.dkr.ecr.us-east-1.amazonaws.com/python-flask:latest"
# }

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 5000
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 0
}

variable "health_check_path" {
  default = "/healthcheck"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}
