terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

// does not destroy fault vpc -> Terraform does not create
resource "aws_default_vpc" "default" {

}

// HTTP Server -> SG  
//SG -> 80 TCP, 22 TCP, CIDR

resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"
  // vpc_id = "vpc-0c9e7ec66381730c2"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Disables by default
  egress {
    from_port = 0
    to_port   = 0
    // -1 = all
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http_server_sg"
  }
}


resource "aws_instance" "http_server" {
  #ami           = "ami-090e0fc566929d98b"
  ami           = data.aws_ami.aws-linux-2-latest.id
  key_name      = "in28-kp"
  instance_type = "t2.micro"
  // created already, no quotes to use .id
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = data.aws_subnets.default_subnets.ids[5]
  // became ids instead of id
  // subnet_id              = "subnet-0cab3991a57519384"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",                                                                              //install httpd
      "sudo service httpd start",                                                                               //start
      "echo Welcome to LCROSENDO - Virtual Server is at ${self.public_dns} | sudo tee /var/www/html/index.html" //
    ]
  }
}