variable "eks_cluster_name" {
    description = "EKS Cluster name"
}

variable "eks_cluster_role_name" {
    description = "EKS Cluster role name"
}

variable "eks_cluster_version" {
    description = "EKS Cluster Version"
}

variable "eks_subnet_ids_list" {
    description = "EKS Cluster subnet ID's"
    type        = list(string)
}

variable "eks_worker_node_instance_key_name" {
    # default = "devops-training"
    description = "EKS Worker Node instance key pair name"
}

variable "vpc_id" {
    description = "VPC ID"
}

# variable "s3_statefile_bucket_name" {
#     description = "S3 Bucket for Terraform Statefile"
# }