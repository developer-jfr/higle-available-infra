data "aws_ssm_parameter" "ami_id" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


resource "aws_launch_configuration" "web_config" {
  name = "apache-server"

  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups             = ["${aws_security_group.apache_sg.id}"]
  associate_public_ip_address = true

}