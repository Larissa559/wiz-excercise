# Data: Ubuntu 18.04 AMI
data "aws_ami" "ubuntu_1804" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "mongo_sg" {
  name        = "mongo-sg-${var.env}"
  vpc_id      = aws_vpc.main.id
  description = "Allow SSH and MongoDB"
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr] # intentionally 0.0.0.0/0 by default
  }
  ingress {
    description = "MongoDB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # intentionally public
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "mongo" {
  ami                         = data.aws_ami.ubuntu_1804.id # "ami-05c939b9f6b8c9c0e" # Ubuntu 18.04 
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.public[0].id
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.mongo_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.mongo_profile.name
  associate_public_ip_address = true

  user_data = file("${path.module}/userdata/mongo_userdata.sh")

  tags = {
    Name = "wiz-mongo-vm"
  }
}
