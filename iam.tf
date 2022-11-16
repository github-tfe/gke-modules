resource "google_service_account" "gke_cluster_sa" {
  account_id   = "arctiq-${var.region}"
  display_name = "GKE ${google_container_cluster.gke_cluster.name} Service Account"
  project      = var.project_id
  depends_on = [
    google_project_service.project_service_resource_manager,
    google_project_service.project_service_container,
  ]
}

resource "google_service_account_key" "gke_cluster_sa_key" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${google_service_account.gke_cluster_sa.unique_id}"
}

# GCP SA used by deployment tools
resource "google_service_account" "deploy_sa" {
  account_id   = "arctiq-${var.region}-deploy"
  display_name = "GKE ${google_container_cluster.gke_cluster.name} Deployment Service Account"
  project      = var.project_id
}

resource "google_service_account_key" "deploy_sa_key" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${google_service_account.deploy_sa.unique_id}"
}

resource "google_service_account" "config_connector_system" {
  count = var.config_connector_enabled ? 1 : 0
  account_id = "cnrm-arctiq-${var.region}"
  display_name = "GKE ${google_container_cluster.gke_cluster.name} Config Connector Service Account"
  project = var.project_id
}