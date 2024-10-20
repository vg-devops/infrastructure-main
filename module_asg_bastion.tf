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

# the bastion server using the terraform-aws-autoscaling module
module "bastion" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 8.0"

  name = "bastion"

  vpc_zone_identifier = module.vpc_application.public_subnets  # Use public subnets from your VPC module
  min_size            = 0
  max_size            = 1
  desired_capacity    = 0

  image_id      = "ami-0b4c7755cdf0d9219"  # Amazon Linux 2 AMI ID for eu-west-2
  instance_type = "t2.micro"

  
  key_name        = aws_key_pair.bastion_key.key_name

   network_interfaces = [
        {
            delete_on_termination = true
            description           = "eth0"
            device_index          = 0
            security_groups       = [aws_security_group.bastion_sg.id]
            associate_public_ip_address = true
        }
   ]    

  launch_template_name        = "bastion-asg"
  launch_template_description = "Launch template for bastion"
  update_default_version      = true

  ebs_optimized     = true
  enable_monitoring = true

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "bastion-iam-role"
  iam_role_path               = "/ec2/" # self-explanotary role path
  iam_role_description        = "IAM role example"
  iam_role_tags = {
        CustomIamRole = "Yes"
  }
  iam_role_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"  ## extra policy to access bastion from AWS Console via SSM sessions
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}