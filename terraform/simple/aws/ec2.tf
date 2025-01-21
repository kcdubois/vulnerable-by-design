resource "aws_security_group" "instance_sg" {
  name        = "${var.name}-instance-sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.latest.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  key_name = aws_key_pair.main.key_name

  user_data = filebase64("${path.module}/../../../deploy/docker-app/deploy.sh")

  tags = merge(var.tags, {
    Name = "${var.name}-${random_string.project.result}-instance"
  })
}

resource "aws_key_pair" "main" {
  key_name   = "${var.name}-${random_string.project.result}-key"
  public_key = file(var.public_key_path)
}


resource "aws_iam_instance_profile" "main" {
  name = "${var.name}-${random_string.project.result}-instance-profile"
  role = aws_iam_role.instance_role.name
}

# Create an EC2 instance role
data "aws_iam_policy_document" "instance_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_role" {
  name               = "${var.name}-${random_string.project.result}-instance-role"
  assume_role_policy = data.aws_iam_policy_document.instance_role_policy.json
}

# Attach the Amazon S3 Full Access policy to the instance role
data "aws_iam_policy" "amazon_s3_full_access" {
  name = "AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.instance_role.name
  policy_arn = data.aws_iam_policy.amazon_s3_full_access.arn
}
