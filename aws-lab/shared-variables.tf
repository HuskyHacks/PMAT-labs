variable "environment" {
  description = "The name of the environment in which the resources will be created'"
  default     = "pmat-lab"
}
variable "flarevm-ami" {
  description = "The Amazon Machine Image (AMI) ID of the created FlareVM."
}

variable "guacamole-ami" {
  description = "The AMI for the Bitnami Apache Guacamole host"
}

variable "remnux-ami" {
  description = "The AMI for the REMnux host"
}

variable "account" {
  description = "The AWS account used for provisioning"
}

variable "region" {
  description = "The AWS region to use for the resources"
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "The best AWS availability zone for your location"
  default     = "us-east-1a"
}

variable "enable_guacamole" {
  description = "Whether to enable the Guacamole server for remote access to the instances (If enabled the FlareVM will have not Internet)"
  default     = true
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
