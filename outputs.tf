output "gke_endpoint" {
  value       = google_container_cluster.gke_cluster.endpoint
  description = "Kubernetes cluster API endpoint"
}

output "gke_cluster_name" {
  value       = google_container_cluster.gke_cluster.name
  description = "GKE cluster name"
}

output "gke_cluster_version" {
  value       = google_container_cluster.gke_cluster.master_version
  description = "GKE cluster name"
}

output "gcp_sa_email" {
  value       = google_service_account.gke_cluster_sa.email
  description = "Email of the GCP SA used for cluster operations"
}

output "encrypted_gcp_sa_key" {
  value       = google_service_account_key.gke_cluster_sa_key.private_key
  description = "Encrypted key of the GCP SA used for cluster operations"
}

output "deploy_sa_email" {
  value       = google_service_account.deploy_sa.email
  description = "Email of the Deploy SA used for cluster bootstrap and operations"
}

output "encrypted_deploy_sa_key" {
  value       = google_service_account_key.deploy_sa_key.private_key
  description = "Encrypted key of the Deploy SA used for cluster bootstrap and operations"
}

output "gke_connect_cmd" {
  value       = "gcloud beta container clusters get-credentials --region ${var.region} --project ${var.project_id}"
  description = "gcloud command to configure kubectl for that cluster"
}


output "gcp_config_connector_sa_email" {
  value       = flatten(google_service_account.config_connector_system.*.email)
  description = "The service account configured for config connector"
}


output "cluster_ca_certificate" {
  value       = base64decode(google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate)
  description = "Base64 encoded public certificate that is the root of trust for the cluster"
}


output "client_certificate" {
  value       = base64decode(google_container_cluster.gke_cluster.master_auth[0].client_certificate)
  description = "Base64 encoded public certificate that is the root of trust for the cluster"
}

output "client_key" {
  value       = base64decode(google_container_cluster.gke_cluster.master_auth.0.client_key)
  description = "Base64 encoded public certificate that is the root of trust for the cluster"
}