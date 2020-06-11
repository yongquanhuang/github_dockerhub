variable "vpc_name" {
  description = "The name of the VPC"
  default = "billing"
}

variable "instance_type" {
  default = "m5a.2xlarge"
}

variable "jumpserver_instance_type" {
  default = "t2.micro"
}


variable "ami_id" {
  default = "ami-026dea5602e368e96"
}


variable "aws_region" {
  default = "cn-north-1"
}


variable "cidr_numeral" {
  description = "The VPC CIDR numeral (172.x.0.0/16)"
}

variable "cidr_numeral_public" {
  default = {
    "0" = "0"
    "1" = "1"
    "2" = "2"
  }
}

variable "cidr_numeral_private" {
  default = {
    "0" = "3"
    "1" = "4"
    "2" = "5"
  }
}

variable "cidr_numeral_private_db" {
  default = {
    "0" = "6"
    "1" = "7"
    "2" = "8"
  }
}

variable "cidr_numeral_private_emr" {
  default = {
    "0" = "9"
    "1" = "10"
    "2" = "11"
  }
}

variable "ssh_key_name" {
  description = "A master ssh key"
}

variable "jumpserver_image" {
  default = {
    cn-north-1 = "ami-7866b115"
  }
}

variable "env" {
  description = "The AWS env tag"
}

variable "availability_zones" {
  description = "A comma-delimited list of availability zones for the VPC."
}

variable "host_list" {
  default = ["web01", "web02", "was01", "was02", "bat01", "bat02_poss"]
}
