data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile = var.instance_profile
  associate_public_ip_address = false

  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y httpd awscli
yum install -y httpd
systemctl start httpd
systemctl enable httpd
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

echo "<h1>EC2 with ALB Demo</h1>" > /var/www/html/index.html
echo "<h2>Private IP: $PRIVATE_IP</h2>" >> /var/www/html/index.html
echo "<h3>Date: $(date)</h3>" >> /var/www/html/index.html
EOF
}

output "instance_id" {
  value = aws_instance.app.id
}
