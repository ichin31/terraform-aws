provider "aws" {
    region = "region"
}

resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
  tags = {
    "Name" = "AWS Testing VPC"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "availability zone"
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.main.id

  route { 
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id = aws_subnet.main.id
  route_table_id = aws_route_table.default.id
}

resource "aws_network_acl" "allowall" {
  vpc_id = aws_vpc.main.id

  egress  {
    cidr_block = "0.0.0.0/0"
    action = "allow"
    from_port = 0
    protocol = "-1"
    rule_no = 100
    to_port = 0
    
  } 

  ingress  {
    cidr_block = "0.0.0.0/0"
    action = "allow"
    from_port = 0
    protocol = "-1"
    rule_no = 200
    to_port = 0
  } 
}

resource "aws_security_group" "allowall" {
  name = "AWS Terraform Crash Course Allow All"
  description = "Allow all traffic - Bad Example"
  vpc_id = aws_vpc.main.id

egress   {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    protocol = "-1"
    to_port = 0
    
  } 

  ingress   {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  } 
}


resource "aws_eip" "webserver" {
    instance = aws_instance.webserver.id
    vpc = true
    depends_on = [aws_internet_gateway.main]
}
resource "aws_key_pair" "default" {
  key_name = "key"
  public_key = "Value"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "webserver" {
    ami = data.aws_ami.ubuntu.id
    availability_zone = "us-east-1a"
    instance_type = "t2.nano"
    key_name = aws_key_pair.default.key_name
    vpc_security_group_ids = [ aws_security_group.allowall.id ]
    subnet_id = aws_subnet.main.id
}

output "public_ip" {
  value = aws_eip.webserver.public_ip
}