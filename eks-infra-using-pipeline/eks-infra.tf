terraform {
    backend "s3" {
    bucket          =   "terraform-statefile-s3-backend-storage"
    key             =   "eks/terraform.tfstate"
    region          =   "us-east-1"
    # encrypt       =   true
    # dynamodb_table=   "terraform-lock"
    }
}

module "eks" {
    source                                  =   "../modules/eks"
    eks_cluster_name_value                  =   var.eks_cluster_name
    eks_cluster_role_value                  =   var.eks_cluster_role_name
    eks_cluster_version_value               =   var.eks_cluster_version
    # eks_subnet_ids_value_list             =   [var.eks_subnet_ids_list]
    eks_subnet_ids_value_list               =   var.eks_subnet_ids_list
    eks_worker_node_instance_key_name_value =   var.eks_worker_node_instance_key_name
    vpc_id_value                            =   var.vpc_id
}
