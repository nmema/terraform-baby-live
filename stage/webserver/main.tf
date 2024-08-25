terraform {
  backend "s3" {
    key            = "webserver/terraform.tfstate"
    bucket         = "terraform-baby-state-dev"
    region         = "us-west-2"
    dynamodb_table = "terraform-baby-locking"
    encrypt        = true
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-baby-state-dev"
    key    = "vpc/terraform.tfstate"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "terraform-baby-state-dev"
    key    = "data-stores/mysql/terraform.tfstate"
    region = "us-west-2"
  }
}

resource "aws_security_group" "lb_sg" {
  name = "terraform-lb-sg"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "load_balancer" {
  name               = "terraform-lb-example"
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  security_groups    = [aws_security_group.lb_sg.id]
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "asg_tg" {
  name     = "terraform-asg-tg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "lb_listener_rule" {
  listener_arn = aws_lb_listener.lb_listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_tg.arn
  }
}

resource "aws_security_group" "sg" {
  name = "terraform-allow-http"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "launch_config" {
  image_id        = "ami-0aff18ec83b712f05"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg.id]

  user_data = templatefile("user-data.sh", {
    server_port = var.server_port,
    db_address  = data.terraform_remote_state.db.outputs.address,
    db_port     = data.terraform_remote_state.db.outputs.port
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "scaling_group" {
  launch_configuration = aws_launch_configuration.launch_config.name
  vpc_zone_identifier  = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  target_group_arns = [aws_lb_target_group.asg_tg.arn]
  health_check_type = "ELB"

  min_size = 1
  max_size = 4

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}
