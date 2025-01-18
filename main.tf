
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


resource "aws_instance" "db" {
  ami                    = data.aws_ami.centos_9.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.client_sg.id]
  availability_zone      = "us-east-1a"
  key_name               = aws_key_pair.ansible_key.key_name

  tags = {
    Name = "db"
  }
}


resource "aws_instance" "control" { #the ansible vm
  ami                    = data.aws_ami.ubuntu_ansible.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.control_sg.id]
  availability_zone      = "us-east-1a"
  key_name               = aws_key_pair.ansible_key.key_name
  tags = {
    Name = "control"
  }


  provisioner "file" { #copy the privet key
    source      = "../keys/ansible_key"
    destination = "/home/ubuntu/ansible_key"

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
    "sudo sed -i 's/Problem with replacing ip web01/${aws_instance.web01.private_ip}/' /home/ubuntu/vprofile/exercise1/inventory",
    "sudo sed -i 's/Problem with replacing ip web02/${aws_instance.web02.private_ip}/' /home/ubuntu/vprofile/exercise1/inventory",
    "sudo sed -i 's/Problem with replacing ip db01/${aws_instance.db.private_ip}/' /home/ubuntu/vprofile/exercise1/inventory"
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



resource "null_resource" "script_tracker" {
  triggers = {
    script_sha = filesha256("${path.module}/ansible_install.sh")
  }
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
output "db_privet_ip_addr" {
  value = aws_instance.db.private_ip
}