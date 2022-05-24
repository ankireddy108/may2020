# Setting "aws_region" to an undefined Terraform variable forces a user to have to
# manually enter in their preferred AWS region each time when using "terraform plan"
# or "terraform apply" commands. The advantage of this slight inconvenience prevents
# users from accidently creating services outside of their preferred region.

variable "aws_region" {
  description = "Enter in a value for aws-region (e.g. us-east-1, us-west-2, etc.)"
  type = string
}

# There are no needs for access_key and secret_key inputs if your AWS credential are
# stored in their default location utilized in other AWS terminal controlled services
# (e.g. awscli). Terraform should automatically fetch the correct authentication
# information.

provider "aws" {
  #region = var.aws_region
   region = "us-east-1"
   access_key = "AKIAZ56GJVLFOS2OJ2FJ"
   secret_key = "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"
}
