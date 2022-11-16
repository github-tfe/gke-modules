resource "google_project_service" "project_service_container" {
  project            = var.project_id
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "project_service_resource_manager" {
  project            = var.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute_engine_api" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "project_container" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "main" {
  project            = var.project_id
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "gke_cluster" {
  provider              = google-beta
  name                  = var.cluster_name
  location              = var.region
  project               = var.project_id
  network               = var.network
  subnetwork            = var.subnetwork
  enable_shielded_nodes = var.enable_shielded_nodes

  release_channel {
    channel = var.kubernetes_version_release_channel
  }
  min_master_version       = var.kubernetes_version
  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  enable_legacy_abac = false

  monitoring_service = "monitoring.googleapis.com/kubernetes"
  logging_service    = "logging.googleapis.com/kubernetes"

  dynamic "workload_identity_config" {
    for_each = var.workload_identity_enabled ? [1] : []
    content {
      workload_pool = "${var.project_id}.svc.id.goog"
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks_config
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_range_name
    services_secondary_range_name = var.service_range_name
  }

  network_policy {
    enabled  = var.network_policies_enabled
    provider = var.network_policy_provider
  }

  addons_config {
    # Set that as an option
    istio_config {
      disabled = var.disable_istio
    }

    horizontal_pod_autoscaling {
      disabled = var.disable_horizontal_pod_autoscaling
    }

    http_load_balancing {
      disabled = var.disable_http_load_balancing
    }

    network_policy_config {
      disabled = !var.network_policies_enabled
    }

    config_connector_config {
      enabled = var.config_connector_enabled
    }

    gce_persistent_disk_csi_driver_config {
      enabled = var.csi_addon_enabled
    }

    dns_cache_config {
      enabled = var.dns_cache_config
    }
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }

  lifecycle {
    ignore_changes = [node_pool]
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_window_start # UTC
    }
    dynamic "maintenance_exclusion" {
      for_each = var.maintenance_exclusion
      content {
        exclusion_name = maintenance_exclusion.value.exclusion_name
        start_time     = maintenance_exclusion.value.start_time
        end_time       = maintenance_exclusion.value.end_time
      }
    }
  }
}


resource "google_container_node_pool" "gke_node_pool" {
  for_each          = var.node_pools
  cluster           = google_container_cluster.gke_cluster.name
  location          = google_container_cluster.gke_cluster.location
  name              = each.key
  project           = lookup(each.value, "project_id", null)
  max_pods_per_node = lookup(each.value, "max_pods_per_node", 110)
  node_count        = lookup(each.value, "nodepool_initial_node_count", 1)
  version           = lookup(each.value, "version", null)


  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", false)
  }

  node_config {
    machine_type    = lookup(each.value, "machine_type", null)
    preemptible     = lookup(each.value, "preemptible", true)
    service_account = google_service_account.gke_cluster_sa.email
    disk_size_gb    = lookup(each.value, "disk_size_gb", null)
    disk_type       = lookup(each.value, "disk_type", null)
    image_type      = lookup(each.value, "image_type", null)
    dynamic "taint" {
      for_each = lookup(each.value, "taints", [])
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }

    metadata     = lookup(each.value, "metadata", {})
    oauth_scopes = lookup(each.value, "oauth_scopes", [])
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
  timeouts {
    create = lookup(each.value, "timeout", var.node_pool_timeout)
    update = lookup(each.value, "timeout", var.node_pool_timeout)
    delete = lookup(each.value, "timeout", var.node_pool_timeout)
  }
}


module "nginx_controller" {
  count      = var.enable_nginx_conftroler ? 1 : 0
  source     = "./modules/nginx_controller"
  depends_on = [google_container_cluster.gke_cluster, google_container_node_pool.gke_node_pool]
}