variable "cidr_range" {

    description = "CIDR range"
    default = "10.0.0.0/16"
}



variable "instance_type_value" {
    description = "EC2 instance type"
    type = string
    default = "t2.micro"
    
}

