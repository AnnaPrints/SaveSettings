locals {
  dns_name = "petclinic.sandbox.intellij.net"
}

data "aws_ami" "rd_latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RD*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["self"]
}

resource "aws_instance" "test" {
  ami = data.aws_ami.rd_latest.id
  instance_type = "t3.large"

  tags = {
    owner = "ernst.haagsman@jetbrains.com"
    project = "RemoteDevelopmentUxTest"
  }

  subnet_id = aws_subnet.test_subnet.id
  vpc_security_group_ids = [
    aws_security_group.test_sg.id
  ]

  count = var.instance_should_exist ? 1 : 0

  key_name = aws_key_pair.eh_key.key_name
}

data "aws_route53_zone" "sandbox" {
  name = "sandbox.intellij.net"
}

resource "aws_route53_record" "test" {
  name    = local.dns_name
  type    = "A"
  zone_id = data.aws_route53_zone.sandbox.zone_id
  ttl = 30
  records = aws_instance.test[*].public_ip
  count = var.instance_should_exist ? 1 : 0
}

resource "aws_key_pair" "eh_key" {
  public_key = file("~/.ssh/id_rsa.pub")
  key_name = "EH_Key"
}

output "dns_name" {
  value = length(aws_instance.test) > 0 ? local.dns_name : "var.instance_should_exist set to false"
}
