output ansible_instance_id {
    value = module.ec2.ansible_instance
}

output "jenkins_master_instance_id" {
    value = module.ec2.jenkins_master_instance
}

output "jenkins_slave_instance_id" {
    value = module.ec2.jenkins_slave_instance
}