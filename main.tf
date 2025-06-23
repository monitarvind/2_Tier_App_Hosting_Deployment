resource "aws_instance" "ec2_1" {
    ami = "ami-0b09627181c8d5778"
    instance_type = "t2.micro"
    subnet_id = "subnet-0bd4db1e0a74ea533"


}