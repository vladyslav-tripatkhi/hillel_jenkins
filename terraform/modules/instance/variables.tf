variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_groups" {
  type = list(string)
}