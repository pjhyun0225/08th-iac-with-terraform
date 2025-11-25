// 보안 그룹 생성하기

locals {
  security_groups = {
    practice-web-sg = {
      description = "practice-web-sg"
    }
    practice-bastion-sg = {
      description = "practice-bastion-sg"
    }
  }
}

resource "aws_security_group" "practice_sg" {
  for_each    = local.security_groups               // 이 한 줄로 SG가 두 개 자동 생성됨

  name        = each.key
  description = each.value.description
  vpc_id      = aws_vpc.practice_vpc.id

  ingress {
    description = "Allow ALL inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = each.key
  }
}

# 1. 로컬 private key 생성
resource "tls_private_key" "practice_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. AWS key pair 생성
resource "aws_key_pair" "practice_keypair" {
  key_name   = "practice-key"
  public_key = tls_private_key.practice_key.public_key_openssh

  tags = {
    Name = "practice-key"
  }
}

# 3. private key 파일 로컬에 저장
resource "local_file" "practice_key_pem" {
  content         = tls_private_key.practice_key.private_key_pem
  filename        = "${path.module}/practice-key.pem"
  file_permission = "0400"
}

// ****** 인스턴스 구성 ******
resource "aws_instance" "practice_web_2a" {
  ami           = "ami-01310a971d963e88b"                             # ARM64 최신 Amazon Linux 2
  instance_type = "t4g.micro"                                         # 교육 계정 Free Tier Eligible

  key_name      = aws_key_pair.practice_keypair.key_name

  subnet_id                    = aws_subnet.private_2a.id             # 프라이빗 서브넷
  associate_public_ip_address  = false                                # 퍼블릭 IP 비활성화

  vpc_security_group_ids = [
    aws_security_group.practice_sg["practice-web-sg"].id              # locals + for_each 로 만든 SG들을 이렇게 참조
  ]

  user_data = <<-EOF
    #!/bin/bash
    dnf install httpd -y
    systemctl start httpd
    systemctl enable httpd
  EOF

  tags = {
    Name = "practice-web-2a"
  }
}


// ****** Bastion Host EC2 인스턴스 구성 ******
resource "aws_instance" "practice_bastion" {
  ami           = "ami-01310a971d963e88b"       # ARM64 Amazon Linux 2 AMI (서울 리전 최신)
  instance_type = "t4g.micro"                   # Free Tier eligible in education accounts

  key_name = aws_key_pair.practice_keypair.key_name

  # ✔ Bastion Host는 반드시 퍼블릭 서브넷에 위치해야 함
  subnet_id = aws_subnet.public_2a.id

  # ✔ 퍼블릭 IP 자동 할당 = 활성화 (필수)
  associate_public_ip_address = true

  # ✔ BastionHost용 SG 연결
  vpc_security_group_ids = [
    aws_security_group.practice_sg["practice-bastion-sg"].id
  ]

  tags = {
    Name = "practice-bastion"
  }
}
