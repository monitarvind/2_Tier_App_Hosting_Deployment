
output "instance_details" {
    value = {
        public_ip = aws_instance.ec2_1.public_ip
        private_ip = aws_instance.ec2_1.private_ip
    }
}

output "vpc_details" {
    value = aws_vpc.vpc1.id
}

output "alb_details" {
    value = {
        dns_name = aws_lb.alb1.dns_name
        arn = aws_lb.alb1.arn
    }
}