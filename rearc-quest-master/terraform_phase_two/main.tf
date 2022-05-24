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
   
}

# Outputs DNS url for the project once the Terraform template has been completed.
# It take several minutes after the url is outputted for the project to become live.

# This is a great opportunity to take a bathroom break, or grab a glass of water!

# Since the SSL certificate utilized with the HTTPS link is self-signed, you will likely
# be presented with a security warning when visiting the page. Some browser (e.g. Safari)
# will let you easily by pass this barrier, while others (e.g. Chrome) will make it more
# difficult to access. View this implementation mentation as a proof of concept, as a
# properly registered SSL cert would not present this issue.

output "rearc-quest-alb-dns-http-url" {
  depends_on = [aws_alb.rearc-quest-alb]
  value = "http://${aws_alb.rearc-quest-alb.dns_name}"
}

output "rearc-quest-alb-dns-https-url" {
  depends_on = [aws_alb.rearc-quest-alb]
  value = "https://${aws_alb.rearc-quest-alb.dns_name}"
}
