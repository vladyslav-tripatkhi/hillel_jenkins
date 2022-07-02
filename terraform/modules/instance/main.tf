resource "aws_instance" "this" {
  ami = data.aws_ami.awslinux2.id

  instance_type = var.instance_type
  key_name      = var.key_name

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 10
  }

  vpc_security_group_ids = var.security_groups
  user_data              = data.local_file.user_data.content

  tags = {
    Name = var.name
  }
}
