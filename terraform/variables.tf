variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Free-tier eligible instance type"
  type        = string
  default     = "t3.micro"
}

variable "repo_url" {
  description = "Public Git URL of this repository (cloned on the instance)"
  type        = string
}

variable "allowed_http_cidr" {
  description = "CIDR allowed to reach the web server on port 80"
  type        = string
  default     = "0.0.0.0/0"
}
