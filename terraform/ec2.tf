data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "watchman" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.watchman_vpc_subnet.id

  vpc_security_group_ids = [aws_security_group.ssh_ok.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  key_name = "watchman"

  user_data = <<-EOF
        #!/bin/bash
        apt-get update -y
        apt-get install docker.io -y
        apt-get install unzip curl -y
        systemctl enable --now docker
        usermod -aG docker ubuntu

        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        ./aws/install

        aws ecr get-login-password | docker login --username AWS --password-stdin ${data.aws_caller_identity.me.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
        docker pull ${aws_ecr_repository.watchman_repo.repository_url}:0.5

        docker run -e AWS_REGION=${var.aws_region} -d --name watchman --restart always ${aws_ecr_repository.watchman_repo.repository_url}:0.5
        EOF

  tags = {
    Name = "Watchman_Host"
  }
}

// to get account ID
data "aws_caller_identity" "me" {}
