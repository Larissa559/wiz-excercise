variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "env" {
  type    = string
  default = "dev"
}

# Terraform backend resources (you can create these manually)
variable "tfstate_bucket" {
  type    = string
  default = "wiz-exercise-tf-state-larissa-pefok"
}

variable "dynamodb_table" {
  type    = string
  default = "wiz-exercise-terraform-locks-larissa-pefok"
}

# EC2 SSH Key name
variable "ssh_key_name" {
  type    = string
  default = "larissa-wiz"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed for SSH - intentionally 0.0.0.0/0 for the exercise (insecure)."
  type        = string
  default     = "0.0.0.0/0"
}

variable "account_id" {
  type    = string
  default = "039612867624"
}

variable "cluster_name" {
  type    = string
  default = "wiz-exercise-eks"
}

variable "eks_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "use_public_subnets" {
  description = "Set true to use public subnets for worker nodes (debugging)"
  type        = bool
  default     = true
}
