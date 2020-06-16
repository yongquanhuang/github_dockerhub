resource "aws_lb" "billing" {
  name               = "billing-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [join(",", aws_subnet.private.*.id)]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "billing-https" {
  load_balancer_arn = aws_lb.billing.arn
  port              = "443"
  protocol          = "tcp"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.billing-https.arn
  }
}


resource "aws_lb_target_group" "billing-https" {
  name     = "billing-https-lb"
  port     = 443
  protocol = "tcp"
  vpc_id   = aws_vpc.billing.id
}


resource "aws_lb_target_group_attachment" "billing-https" {
  count          = length(var.availability_zones)
  target_group_arn = aws_lb_target_group.billing-https.arn
  target_id        = aws_instance.web[count.index].id
  port             = 443
}


resource "aws_lb_listener" "billing-http" {
  load_balancer_arn = aws_lb.billing.arn
  port              = "80"
  protocol          = "tcp"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.billing-http.arn
  }
}


resource "aws_lb_target_group" "billing-http" {
  name     = "billing-http-lb"
  port     = 80
  protocol = "tcp"
  vpc_id   = aws_vpc.billing.id
}


resource "aws_lb_target_group_attachment" "billing-http" {
  count          = length(var.availability_zones)
  target_group_arn = aws_lb_target_group.billing-http.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}
