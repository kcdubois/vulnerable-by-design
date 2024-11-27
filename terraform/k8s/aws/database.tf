#
# IAM resources 
#

resource "aws_iam_role" "database_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2_policy"
  description = "Policy to allow full access to EC2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "ec2:*"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  role       = aws_iam_role.database_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "mongo-${random_string.project.result}-iam-profile"
  role = aws_iam_role.database_role.name
}

#
# Security group for SSH access
# 

resource "aws_security_group" "database" {
  name        = "database-sg"
  description = "Security group for allowing SSH access and database connections."
    vpc_id = aws_vpc.prod.id
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.database.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "mongo" {
  security_group_id = aws_security_group.database.id
  cidr_ipv4         = local.vpc_cidr_block
  from_port         = 27017
  ip_protocol       = "tcp"
  to_port           = 27017
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.database.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

}

#
# Instance configuration
#

resource "aws_instance" "database" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  network_interface {
    device_index         = 0
    network_card_index   = 0
    network_interface_id = aws_network_interface.databaseNic.id
  }

    key_name = aws_key_pair.personal.key_name

  tags = {
    Name = "mongo-${random_string.project.result}"
  }
}

resource "aws_network_interface" "databaseNic" {
  subnet_id       = aws_subnet.public_a.id
  security_groups = [aws_security_group.database.id]
}

resource "aws_eip" "database" {
  tags = {
    Name = "mongo-eip-${random_string.project.result}"
  }
}

resource "aws_eip_association" "database" {
  network_interface_id = aws_network_interface.databaseNic.id
  allocation_id = aws_eip.database.allocation_id
}

resource "aws_key_pair" "personal" {
  key_name = "default"
  public_key = file(var.public_key_path)
}
