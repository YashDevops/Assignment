resource "aws_lb_target_group" "app-tg" {
  name = "new-tg"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = var.vpc_id
  health_check {
    interval = 5
    path = "/"
    protocol = "HTTP"
    timeout = "3"
    healthy_threshold  = "2"
    unhealthy_threshold = "3"
  }
}


resource "aws_lb" "app-lb" {
  name = "app-lb"
  internal = "false"
  security_groups = [aws_security_group.elb-sg.id]
  subnets = var.subnets
}

resource "aws_lb_listener" "app-listner" {
  load_balancer_arn = aws_lb.app-lb.arn
  port = "80"
  protocol = "HTTP"
  default_action  {
    target_group_arn = aws_lb_target_group.app-tg.arn
    type = "forward"
  }
}

resource "aws_alb_target_group_attachment" "ec2-attach" {
  count = 1
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id = var.target_ids
}
