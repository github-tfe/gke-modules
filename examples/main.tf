resource "google_compute_network" "gke_test" {
  name                    = "test-gke-module"
  auto_create_subnetworks = false
  project                 = "arctiq-test"
}

resource "google_compute_subnetwork" "subnet_k8s" {
  name          = "k8s-test-module"
  ip_cidr_range = "10.10.0.0/24"
  region        = "us-east1"
  network       = google_compute_network.gke_test.name
  project       = google_compute_network.gke_test.project
}

module "gke_cluster" {
  source = "../"

  region                   = "us-east1"
  project_id               = google_compute_network.gke_test.project
  cluster_name             = "test-module1"
  disable_istio            = "false"
  private_endpoint         = "false"
  network                  = google_compute_network.gke_test.self_link
  subnetwork               = google_compute_subnetwork.subnet_k8s.self_link
  master_ipv4_cidr_block   = "172.16.5.0/28"
  kubernetes_version       = "1.22.12-gke.2300"
  network_policies_enabled = true
  config_connector_enabled = true
  csi_addon_enabled        = true
  enable_nginx_conftroler = true

  master_authorized_networks_config = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "Every IPv4 address"
    },
  ]

  node_pools = {
    nodepool1 = {
      node_pools_names            = "nodepool2"
      machine_type                = "e2-medium"
      project_id                  = google_compute_network.gke_test.project
      version                     = "1.22.12-gke.2300"
      nodepool_initial_node_count = 1
      disk_size_gb                = "100"
      disk_type                   = "pd-standard"
      image_type                  = "cos_containerd"
      metadata = {
        disable-legacy-endpoints = true
      }
      oauth_scopes = [
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
  }
}

resource "google_service_account" "verifier" {
  project    = google_compute_network.gke_test.project
  account_id = "gke-mod-test-verifier"
}

resource "google_service_account_key" "verifier" {
  service_account_id = google_service_account.verifier.email
}

data "google_client_config" "default" {}
