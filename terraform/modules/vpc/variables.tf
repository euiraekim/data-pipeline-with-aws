variable "aws_region" {
  type = string
  default = "ap-northeast-2"
}

variable "vpc_cidr" {
  type = string
  default  = "10.0.0.0/16"
}

variable "name" {
  type = string
}

variable "availability_zones" {
  type = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "use_nat" {
  type = bool
  default = false
}
