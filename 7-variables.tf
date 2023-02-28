# ALB ports
variable "alb_rules" {
  type = list(object({
    port        = number
    proto       = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      port        = 80
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 443
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}


# ALB count
variable "count_instances" {
  type = object({
    min     = number
    max     = number
    desired = number
  })
  default = {
    min     = 1
    max     = 1
    desired = 1
  }
}

# instance type
variable "instance_type" {
  type    = string
  default = "t2.micro"
}


# key pair for apache
variable "key_name" {
  type    = string
  default = "apache_key"
}

variable "ami" {
  type = string
  default = "ami-0e86a3c35660c41f7"
}