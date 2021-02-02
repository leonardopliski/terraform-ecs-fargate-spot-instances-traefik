variable "region" {
  type        = string
  description = "The deployment region"
  default     = "us-west-2"
}

variable "namespace" {
  type        = string
  description = "Your organization name or abbreviation. Eg.: ag, ya"
  default     = "yeshua"
}

variable "stage" {
  type        = string
  description = "Your cluster stage. Eg.: staging, production"
  default     = "staging"
}

variable "name" {
  type        = string
  description = "The solution name. Eg.: app, jenkins"
  default     = "app"
}
