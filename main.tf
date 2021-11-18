terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "DBserver" {
  ami           = "ami-0279c3b3186e54acd"
  instance_type = "t2.micro"

  tags = {
    Name = var.db_name 
  }
}


resource "aws_instance" "webserver" {
  ami           = "ami-083654bd07b5da81d"
  instance_type = "t2.micro"

  tags = {
    Name = var.WebServer_name
  }
}