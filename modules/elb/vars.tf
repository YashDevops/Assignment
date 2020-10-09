variable "vpc_id" {
  type = string
}

variable "description" {
  type = string
  default = "This security group is for ssh only"
}

variable "subnets" {
  type = list
}

variable "target_ids" {
  type = string
}
