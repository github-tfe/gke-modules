output "gke_cluster_name" {
  value       = module.gke_cluster.gke_cluster_name
  description = "GKE cluster name"
}

output "gke_cluster_version" {
  value       = module.gke_cluster.gke_cluster_version
  description = "GKE cluster name version"
}