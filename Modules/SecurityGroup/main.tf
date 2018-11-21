resource "aws_security_group" "${var.group}-${var.name}}" {
  name        = "${var.group}-${var.name}"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.group}-${var.name}"
  }
}