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

