###### BASTION SERVER TO ACCESS EC2 EKS NODES AND DATABASES (Future) #######
# SSH key pair for the bastion
resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = file("${path.module}/bastion.pub")  # pick up ssh key generated locally
}

# security group for the bastion, ideally to inc VPN IP address or be accessible from VPN Proxy (if bastion located in Private Network)
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = module.vpc_application.vpc_id  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  #  to be replaced with VPN IP(s) 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

