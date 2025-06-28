resource "aws_vpc" "vpc1" {
    
    cidr_block = var.cidr_range
    tags = {
        Name = "VPC"
        Env = "Dev"
    }
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true

}

resource "aws_subnet" "sub2" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1b"
    #map_public_ip_on_launch = true

}

resource "aws_route_table" "rt1" {
    vpc_id = aws_vpc.vpc1.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table" "rt2" {
    vpc_id = aws_vpc.vpc1.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc1.id
}

resource "aws_route_table_association" "rt_asso_1" {
    subnet_id=aws_subnet.sub1.id
    route_table_id = aws_route_table.rt1.id

}

resource "aws_route_table_association" "rt_asso_2" {
    subnet_id=aws_subnet.sub2.id
    route_table_id = aws_route_table.rt2.id

}

resource "aws_instance" "ec2_1" {
    
    ami = "ami-0b09627181c8d5778"
    instance_type = var.instance_type_value
    subnet_id = aws_subnet.sub1.id
    vpc_security_group_ids = [aws_security_group.sg1_ec2.id]

    key_name = "KEY-BYD-Account2"

    user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
              echo "Hello from Terraform EC2" > /var/www/html/index.html
              EOF


    tags = {
        Name = "EC2"
        Env = "Dev"
    }

}

resource "aws_security_group" "sg1_ec2" {
    name = "sg1"
    vpc_id = aws_vpc.vpc1.id
    
    ingress {

        description = "HTTP"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        #prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  }

  ingress {

        description = "SSH"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        #prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  }

  egress {

    description = "open to all"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  }
}

resource "aws_security_group" "sg1_alb" {
    name = "sg1_alb"
    vpc_id = aws_vpc.vpc1.id
    
    ingress {

        description = "HTTP"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        #prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  }

  egress {

    description = "open to all"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  }


}

resource "aws_lb" "alb1" {

    name = "test-lb-tf"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.sg1_alb.id]
    subnets = [aws_subnet.sub1.id, aws_subnet.sub2.id,]
    tags = {
        Name = "ALB"
        Env = "Dev"
    }

}

resource "aws_lb_target_group" "alb_tg1" {
  name     = "alb-tg-tf"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc1.id
}


resource "aws_lb_target_group_attachment" "tg_ec2_attach" {
  target_group_arn = aws_lb_target_group.alb_tg1.arn
  target_id        = aws_instance.ec2_1.id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb1.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg1.arn
  }
}
