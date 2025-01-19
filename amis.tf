data "aws_ami" "centos_9" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS-Stream-ec2-9-20221219.0-20230110.0.x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"] # Canonical
}




data "aws_ami" "ubuntu_ansible" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu_22.04_with_ansible"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["216989131086"] # my account ID
}



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}