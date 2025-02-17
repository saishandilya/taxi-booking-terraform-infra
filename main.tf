module "ec2" {
    source = "./modules/ec2"
    ansible_instance_type_value = var.ansible_instance_type
    jenkins_instance_type_value = var.jenkins_instance_type
    instance_key_name_value = var.instance_key_name
    public_subnet_id_value = var.public_subnet_id
    security_group_id_value = [var.security_group_id]
}