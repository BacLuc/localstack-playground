resource "aws_s3_bucket" "s3_bucket" {
  bucket = local.supabase.bucket_name
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Some Public Subnet"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 8443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["aws-ami-docker-compose"]
  }

  owners = ["000000000000"]
}

data "cloudinit_config" "ec2_cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content      = local.cloud_config
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "init.sh"
    content      = <<-EOF
      #!/bin/bash

      /usr/local/bin/entrypoint default
    EOF
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true

  user_data = data.cloudinit_config.ec2_cloudinit.rendered

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_lb_target_group" "main" {
  name = "main"
  protocol = "HTTP"
  target_type = "ip"
  port = 443
  vpc_id = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.app_server.id
#  port = 443
}

resource "aws_lb" "test" {
  name               = var.loadbalancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [aws_subnet.main.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

