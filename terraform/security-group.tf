resource "aws_security_group" "sg-billing-web" {
  name        = "billing-web-${var.vpc_name}"

  vpc_id = aws_vpc.billing.id

  ingress {
      from_port       = 2222
      to_port         = 2222
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
  }

    ingress {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
  }

      ingress {
      from_port       = 8443
      to_port         = 8443
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "billing-web-${var.vpc_name}"
  }
}

resource "aws_security_group" "sg-billing-was" {
  name        = "billing-was-${var.vpc_name}"

  vpc_id = aws_vpc.billing.id

  ingress {
      from_port       = 2222
      to_port         = 2222
      protocol        = "tcp"
      cidr_blocks     = ["172.16.0.0/16"]
  }

  ingress {
      from_port       = 8180
      to_port         = 8180
      protocol        = "tcp"
      cidr_blocks     = ["172.16.0.0/16"]
  }
  ingress {
      from_port       = 8980
      to_port         = 8980
      protocol        = "tcp"
      cidr_blocks     = ["172.16.0.0/16"]
  }

  ingress {
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      cidr_blocks     = ["172.16.0.0/16"]
  }

  ingress {
      from_port       = 9080
      to_port         = 9080
      protocol        = "tcp"
      cidr_blocks     = ["172.16.0.0/16"]
  }

  ingress {
      from_port       = 57900
      to_port         = 57900
      protocol        = "tcp"
      cidr_blocks     = ["172.16.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "billing-was-${var.vpc_name}"
  }
}

resource "aws_security_group" "sg-billing-jumphost" {
  name        = "jumphost-${var.vpc_name}"
  description = "Allows SSH access to the jumphost server"

  vpc_id = aws_vpc.billing.id

  ingress {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      description     = "Office IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jumphost-${var.vpc_name}"
  }
}

resource "aws_security_group" "sg-billing-nlb" {
  name        = "billing-nlb-${var.vpc_name}"

  vpc_id = aws_vpc.billing.id

  ingress {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
  }

    ingress {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "billing-nlb-${var.vpc_name}"
  }
}
