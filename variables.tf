#DEFINE PATH TO THE SSH KEY YOU WILL USE FOR THIS ENVIROMENT
#Key Path Details (SSH KEY)
variable "key_path" {
  description = "SSH Public Key path"

# EXAMPLE :: default = "/Users/ryanivis/.ssh/id_rsa.pub"
  default = "/Users/georgeormanis/.ssh/georgeormanis-keypair.pub"
#                  ^^^^^^^^^^ 

}

# DEFINE THE USERNAME
variable "name_of_user" {
  description = "Username"

# ENTER YOUR USERNAME HERE AND PROJECT NAME
# YOU MUST USE THE REQUIRED SYNTAX ALL LOWER AND ONLY HYPHENS NO SPACES NO OTHER CHARS!!!

  default = "georgeormanis-terraform-eks"

}


# YOU MUST ADD YOUR USERNAME INTO THE BELOW ZONE NAME OTHERWISE YOUR BUILD MAY FAIL!!!!!!!

variable "dns_zone_name" {
  description = "dns zone name"

# EXAMPLE : default = "pro-serv-test.ryanivis.local"
  default = "terraform-eks.georgeormanis.local"
#                         ^^^^^^^^^^  
}


#
# DEFAULT OPERATION REGION CHANGING THIS REQUIRES UPDATE TO THE BASE AMI FOR DEPLOYMENT!!!!!!!!
#
variable "aws_region_server" {
  description = "Terraform-EKS Private VPC"
  default = "eu-west-2"
}

#---------------------------------------------------------------------------------------------

#
# DNS SETTINGS MUST ONLY BE IF CHANGING AWAY FROM ROUTE 53
#

variable "dns_route53_ip" {
  description = "Internal DNS Reslover via AWS Route53"
  default = "10.161.0.2"
}



#---------------------------------------------------------------------------------------------

#
#Server Subnet Details
#

#
# DEFINE THE SCOPE OF YOUR IP RANGE FOR THE ENTIRE VPC
#
variable "vpc_cidr_server" {
  description = "CIDR for the VPC"
  default = "10.161.0.0/16"
}

#
# DEFINE THE PRIVATE IP SCOPE FOR PUBLIC SUBNET
#
variable "public_subnet_cidr_server" {
  description = "CIDR for the public subnet"
  default = "10.161.1.0/24"
}

#
# DEFINE THE PRIVATE IP SCOPE FOR THE PRIVATE SUTNET
#
variable "private_subnet_cidr_server" {
  description = "CIDR for the private subnet"
  default = "10.161.2.0/24"
}

#
# YOUR COMPUTER'S EXTERNAL IP
#
variable "accessing_computer_ip" {
    type = "string"
    description = "IP of the computer to be allowed to connect to EKS master and nodes."
    default = "31.52.170.111"
}

#
# DEFINE THE CLUSTER NAME
#
variable "cluster-name" {
  type    = "string"
  description = "Cluster name to be used in the tags to identify the cluster"
  default = "tf-eks-PF"
}

#
# SUBNET IDS
#
variable "aws_subnet_ids" {
  type = "string"
  description = "ID of the AWS subnets"
}
