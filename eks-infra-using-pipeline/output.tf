output "eks_cluster_arn" {
    value = module.eks.cluster_arn_value
}

output "eks_cluster_endpoint" {
    value = module.eks.cluster_endpoint
}