resource "aws_key_pair" "ansible_key" {
  key_name   = "ansible_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5iEgAhEsJPYsfVJOirn6HKGEYt9txT7T+H8hH/itwr amos@win-10pc"
}