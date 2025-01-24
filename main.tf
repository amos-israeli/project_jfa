
resource "aws_instance" "web01" {
  ami                    = data.aws_ami.centos_9.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.client_sg.id]
  availability_zone      = "us-east-1a"
  key_name               = aws_key_pair.ansible_key.key_name
  tags = {
    Name = "web01"
  }
}
resource "aws_ec2_instance_state" "web01" {
  instance_id = aws_instance.web01.id
  state       = var.state.web01
}

resource "aws_instance" "web02" {
  ami                    = data.aws_ami.centos_9.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.client_sg.id]
  availability_zone      = "us-east-1a"
  key_name               = aws_key_pair.ansible_key.key_name

  tags = {
    Name = "web02"
  }
}
resource "aws_ec2_instance_state" "web02" {
  instance_id = aws_instance.web02.id
  state       = var.state.web02
}


resource "aws_instance" "web03" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.client_sg.id]
  availability_zone      = "us-east-1a"
  key_name               = aws_key_pair.ansible_key.key_name
  tags = {
    Name = "web03"
  }
}
resource "aws_ec2_instance_state" "web03" {
  instance_id = aws_instance.web03.id
  state       = var.state.web03
}


resource "aws_instance" "db01" {
  ami                    = data.aws_ami.centos_9.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.client_sg.id]
  availability_zone      = "us-east-1a"
  key_name               = aws_key_pair.ansible_key.key_name

  tags = {
    Name = "db"
  }
}
resource "aws_ec2_instance_state" "db01" {
  instance_id = aws_instance.db01.id
  state       = var.state.db01
}


resource "aws_instance" "control" { #the ansible vm
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.control_sg.id]
  availability_zone      = "us-east-1a"
  key_name               = aws_key_pair.ansible_key.key_name
  tags = {
    Name = "control"
  }



  provisioner "file" { #copy the ssh config file
    source      = "control_files/config"
    destination = "/home/ubuntu/.ssh/config"

  }

  provisioner "file" { #copy ssh privet key for use by ansible
    source      = "../keys/ansible_key"
    destination = "/home/ubuntu/.ssh/ansible_key"

  }


  provisioner "file" { #copy the privet git key
    source      = "../keys/git_ansible"
    destination = "/home/ubuntu/.ssh/git_ansible"
  }

  provisioner "file" {
    source      = "ansible_install.sh"
    destination = "/home/ubuntu/ansible_install.sh"

  }



  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x ansible_install.sh",
      "sudo /home/ubuntu/ansible_install.sh",
      #replace the ips in the ansible_install.sh with the current privat ip
      #"sudo sed -i 's/Replace with ip web01/${aws_instance.web01.private_ip}/' /home/ubuntu/vprofile/exercise1/inventory",
      #"sudo sed -i 's/Replace with ip web02/${aws_instance.web02.private_ip}/' /home/ubuntu/vprofile/exercise1/inventory",
      #"sudo sed -i 's/Replace with ip db01/${aws_instance.db.private_ip}/' /home/ubuntu/vprofile/exercise1/inventory"
    ]
  }


  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("../keys/ansible_key")
    host        = self.public_ip
  }



  lifecycle {
    replace_triggered_by = [
      null_resource.script_tracker.id
    ]
  }

}

resource "aws_ec2_instance_state" "control" {
  instance_id = aws_instance.control.id
  state       = var.state.control
}



resource "null_resource" "script_tracker" {
  triggers = {
    script_sha = filesha256("${path.module}/ansible_install.sh")
  }
}



output "db_privet_ip_addr" {
  value = aws_instance.db01.private_ip
}
output "control_ip_addr" {
  value = aws_instance.control.public_ip
}
output "web01_privet_ip_addr" {
  value = aws_instance.web01.private_ip
}
output "web02_privet_ip_addr" {
  value = aws_instance.web02.private_ip
}

output "web03_privet_ip_addr" {
  value = aws_instance.web03.private_ip
}

