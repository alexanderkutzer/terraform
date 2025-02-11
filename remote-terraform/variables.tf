variable "aws_region" {
    description = "value for the aws region"
    type       = string
    default = "eu-central-1"
}

variable "instance_name"{
    type = string
    description = "This is the name of the instance"
    default = "techstarter-test"
}

variable "instance_type"{
    type = string
    description = "This is my instance type"
    default = "t2.micro"
}