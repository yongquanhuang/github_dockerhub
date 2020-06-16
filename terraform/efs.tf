resource "aws_efs_file_system" "billing-nas" {
  creation_token = "my-product"

  tags = {
    Name = "MyProduct"
  }
}

resource "aws_efs_mount_target" "billing-nas-mount" {
    file_system_id = "${aws_efs_file_system.billing-nas.id}"
    subnet_id      = aws_subnet.private[0].id
    security_groups = "${aws_security_group.billing-nas.id}"
}

resource "aws_security_group""billing-nas" {
    name          = "billing-efs-sg"
    description   = "Allow EFS traffic."
    vpc.id        = aws_vpc.billing.id    

    lifecycle {
      create_before_destroy = true
    }

    ingress {
      from_port    =   "2049"
      to_port      =   "2049"
      protocol     =   "tcp"
      cidr_blocks  =   ["172.16.0.0/16"]
    }

    egress {
      from_port   =   0
      to_port     =   0
      protocol    =   "-1"
      cidr_blocks =   ["0.0.0.0/0"]
   }
}

data "template_file" "setup_efs" {
  template = "${file("file/setup_efs.sh")}"
  vars = {
    efs_dns_name = "${aws_efs_file_system.billing-nas.dns_name}"
  }
}
