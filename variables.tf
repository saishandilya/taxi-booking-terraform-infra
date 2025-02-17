variable "ansible_instance_type" {
    # default = "t2.micro"
    description = "Instance type for Ansible Instance"
}

variable "jenkins_instance_type" {
    # default = "t2.medium"
    description = "Instance type for Jenkins Instance"
}

variable "instance_key_name" {
    # default = "devops-training"
    description = "EC2 instance key name"
}

variable "security_group_id"{
    description = "Security Group ID for EC2 Instance"
}

variable "public_subnet_id" {
    description = "Default VPC public subnet id"
}