resource "aws_instance" "web" {
  count          = length(var.availability_zones)
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.private.*.id, count.index)
  key_name      = "Billing"
  security_groups = [aws_security_group.sg-billing-web.id]

  root_block_device {
      volume_type           = "gp2"
      volume_size           = 30
      delete_on_termination = true
    }
  
  ebs_block_device {
      device_name           = "/dev/sdb"
      volume_type           = "gp2"
      volume_size           = 500
      delete_on_termination = true
    }


  user_data = file("file/mount_disk.sh")

  tags = {
    Name = "web0${count.index+1}"
  }
}

resource "aws_instance" "was" {
  count         = length(var.availability_zones)
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.private.*.id, count.index)
  key_name      = "Billing"
  security_groups = [aws_security_group.sg-billing-was.id]

  root_block_device {
      volume_type           = "gp2"
      volume_size           = 30
      delete_on_termination = true
    }
  
  ebs_block_device {
      device_name           = "/dev/sdb"
      volume_type           = "gp2"
      volume_size           = 500
      delete_on_termination = true
    }


  user_data = file("file/mount_disk.sh")

  tags = {
    Name = "was0${count.index+1}"
  }
}


resource "aws_instance" "bat" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private[0].id
  key_name      = "Billing"
  security_groups = [aws_security_group.sg-billing-was.id]

  root_block_device {
      volume_type           = "gp2"
      volume_size           = 30
      delete_on_termination = true
    }
  
  ebs_block_device {
      device_name           = "/dev/sdb"
      volume_type           = "gp2"
      volume_size           = 500
      delete_on_termination = true
    }


  user_data = file("file/mount_disk.sh")

  tags = {
    Name = "bat01"
  }
}


resource "aws_instance" "poss" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private[1].id
  key_name      = "Billing"
  security_groups = [aws_security_group.sg-billing-was.id]

  root_block_device {
      volume_type           = "gp2"
      volume_size           = 30
      delete_on_termination = true
    }
  
  ebs_block_device {
      device_name           = "/dev/sdb"
      volume_type           = "gp2"
      volume_size           = 500
      delete_on_termination = true
    }


  user_data = file("file/mount_disk.sh")

  tags = {
    Name = "poss"
  }
}

resource "aws_instance" "jumphost" {
  ami           = var.ami_id
  instance_type = var.jumpserver_instance_type
  subnet_id     = aws_subnet.public[0].id
  key_name      = "Billing"
  security_groups = [aws_security_group.sg-billing-jumphost.id]

  root_block_device {
      volume_type           = "gp2"
      volume_size           = 30
      delete_on_termination = true
    }

  tags = {
    Name = "jumphost-${var.vpc_name}"
  }
}

# EIP for jumphost
resource "aws_eip" "jumphost" {
  vpc = true
  instance = aws_instance.jumphost.id
}



data "aws_instance" "web" {
  filter {
    name = "tag:Name"
    values = ["web01", "web02"]
  } 
}
