#the main.tf file

resource "null_resource" "cluster" {
  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.bastion.public_ip
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("../../../keys/id_rsa")
  }

  provisioner "file" {
  source      = "../../../keys/id_rsa"
  destination = "~/.ssh/id_rsa"
}

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
    "sudo apt update; sudo apt install ansible -y",
    "export ANSIBLE_HOST_KEY_CHECKING=False;",
    "git clone https://github.com/YashDevops/Assignment.git",
    "ansible-playbook Assignment/Ansible/MediaWiki/playbooks/release.yml -i module.ec2.private_ip, -u ubuntu -e 'ansible_python_interpreter=/usr/bin/python3'"
    ]
  }
}

module "vpc"  {
  source = "../../../modules/vpc"
  Name = var.Name
  BussinessUnit = var.BussinessUnit
  Team = var.Team
  Project = var.Project
}

module "key" {
  source = "../../../modules/keys"
  key_name = "mediawiki-keys"
  PATH_TO_PUBLIC_KEY = "../../../keys/id_rsa.pub"
}

module "ec2" {
  source = "../../../modules/ec2"
  account_id = ["099720109477"]
  vpc_id = module.vpc.vpc_id
  sub_id = module.vpc.private_1a
  ssh_key = module.key.key_name
  Name = var.Name
  BussinessUnit = var.BussinessUnit
  Team = var.Team
  Project = var.Project
}

module "bastion" {
  source = "../../../modules/ec2"
  account_id = ["099720109477"]
  vpc_id = module.vpc.vpc_id
  sub_id = module.vpc.public_1a
  ssh_key = module.key.key_name
  Name = "${var.Name}-bastion"
  BussinessUnit = var.BussinessUnit
  Team = var.Team
  Project = var.Project
}

# module "elb" {
#   source = "../../../modules/elb"
#   vpc_id = module.vpc.vpc_id
#   subnets = data.aws_subnet_ids.subnet.ids
#   target_ids = module.ec2.instance_id
# }


# module "ebs" {
#   source = "../../../modules/ebs"
#   availability_zone = module.vpc.private_1a_subnet
#   instance_id = module.ec2.instance_id
#   size = 40
#   device_name = "/dev/xvdb"
# }
