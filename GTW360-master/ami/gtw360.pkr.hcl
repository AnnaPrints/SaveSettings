build {
  name = "GTW-360"

  sources = [
    "source.amazon-ebs.gtw-360"
  ]

  provisioner "shell" {
    // Get everything ready for Ansible to do its thing
    inline = [
      // First, we wait for cloud-init to complete
      // Apparently that's the cause of apt-get woes in early-life EC2 instances.
      // See: https://askubuntu.com/a/755969
      "/usr/bin/cloud-init status --wait && \\",


      "sudo apt-get update && \\",
      "sudo apt-get upgrade -y && \\",
      "sudo apt-get install python3-pip -y && \\",
      "sudo -H pip3 install ansible awscli"
    ]
  }

  provisioner "ansible-local" {
    playbook_dir  = "./playbook/"
    playbook_file = "./playbook/rd.yml"
  }
}

source "amazon-ebs" "gtw-360" {
  region        = "eu-north-1"
  ami_name      = "RD {{timestamp}}"
  instance_type = "t3.medium"

  source_ami_filter {
    filters     = {
      name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    }
    owners      = ["099720109477"] # Canonical
    most_recent = true
  }
  ssh_username = "ubuntu"
}

packer {
  required_version = "~> 1.7"

  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}