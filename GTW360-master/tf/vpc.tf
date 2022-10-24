resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    owner   = "ernst.haagsman@jetbrains.com"
    project = "RemoteDevelopmentUxTest"
    Name = "SSH-RD-UX-Test"
  }
}

resource "aws_subnet" "test_subnet" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.test_vpc.id
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    owner   = "ernst.haagsman@jetbrains.com"
    project = "RemoteDevelopmentUxTest"
  }
}

resource "aws_route_table" "test_routes" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }


  tags = {
    owner   = "ernst.haagsman@jetbrains.com"
    project = "RemoteDevelopmentUxTest"
  }
}

resource "aws_main_route_table_association" "test" {
  route_table_id = aws_route_table.test_routes.id
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_security_group" "test_sg" {
  name        = "ux_test_sg"
  description = "Security group for the SSH Remote Development usability test"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    owner   = "ernst.haagsman@jetbrains.com"
    project = "RemoteDevelopmentUxTest"
  }
}
