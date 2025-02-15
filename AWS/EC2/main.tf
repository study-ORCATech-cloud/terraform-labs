resource "aws_security_group" "sg" {

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami           = var.ec2-ami
  instance_type = var.ec2-instance-type

  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "example-ec2"
  }
}
