resource "google_project_iam_member" "gke_iam_membership_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.gke_cluster_sa.email}"
}

resource "google_project_iam_member" "gke_iam_membership_container_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.gke_cluster_sa.email}"
}

resource "google_project_iam_member" "secretmanager" {
  project = var.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.gke_cluster_sa.email}"
}


resource "google_service_account_iam_member" "gke_iam_membership_sa_token_creator" {
  service_account_id = google_service_account.gke_cluster_sa.name
  member             = "serviceAccount:${google_service_account.gke_cluster_sa.email}"
  role               = "roles/iam.serviceAccountTokenCreator"
}

resource "google_service_account_iam_member" "gke_iam_membership_sa_token_creator_deploy" {
  service_account_id = google_service_account.deploy_sa.name
  member             = "serviceAccount:${google_service_account.deploy_sa.email}"
  role               = "roles/iam.serviceAccountTokenCreator"
}