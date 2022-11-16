
variable "region" {
  type        = string
  description = "The region where the cluster will be created"
}

variable "scopes" {
  type    = list(string)
  default = []
}

variable "project_id" {
  type        = string
  description = "The project id where the cluster will be created"
}

variable "node_pools" {
  type        = map(any)
  default     = {}
  description = "A map of nodes pools to create"
}

# Consider switching initial_node_count to min_node_count
# once the core terraform-0.12.31 bug is fixed
# https://github.com/hashicorp/terraform/issues/18209
variable "initial_node_count" {
  type        = string
  default     = "1"
  description = "Define the initial number of nodes to create for the cluster"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.19"
  description = "The qualified version of kubernetes for the cluster"
}

variable "kubernetes_version_release_channel" {
  type        = string
  default     = "UNSPECIFIED"
  description = "The channel to follow version releases for this cluster"
}

variable "network" {
  type        = string
  default     = ""
  description = "The network where the cluster will be created"
}

variable "subnetwork" {
  type        = string
  default     = ""
  description = "The subnetwork where the cluster will be created"
}

variable "master_ipv4_cidr_block" {
  type        = string
  default     = ""
  description = "The block of IPs used to allocate the master nodes"
}

variable "master_authorized_networks_config" {
  type = list(object({
    cidr_block   = string,
    display_name = string,
    }
  ))
  description = "Master Authorized Networks configuration (see README)"

  default = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "CHANGEME old defaults"
    },
  ]
}

variable "cluster_range_name" {
  type        = string
  default     = ""
  description = "The subnet IP range name for the cluster"
}

variable "service_range_name" {
  type        = string
  default     = ""
  description = "The subnet IP range name for the SERVICES"
}

variable "maintenance_window_start" {
  type        = string
  default     = "08:00"
  description = "Hour for when a maintenance window can start for the cluster"
}

variable "dns_cache_config" {
  type        = bool
  default     = true
  description = "If the dns cache feature is enabled or not"
}

variable "disable_istio" {
  type        = bool
  default     = false
  description = "If istio is disabled or not"
}

variable "disable_horizontal_pod_autoscaling" {
  type        = bool
  default     = false
  description = "If hpa is disabled or not"
}

variable "disable_http_load_balancing" {
  type        = bool
  default     = false
  description = "If http load balancing is disabled or not"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "network_policies_enabled" {
  type        = bool
  default     = true
  description = "If network policies are enabled or not"
}

variable "csi_addon_enabled" {
  type        = bool
  description = "To disable or not the CSI add-on"
  default     = false
}

variable "network_policy_provider" {
  type        = string
  description = "The network policy provider."
  default     = "CALICO"
}

variable "private_endpoint" {
  type        = bool
  default     = true
  description = "If the private endpoint is enabled ot not"
}

variable "private_nodes" {
  type        = bool
  default     = true
  description = "If access to nodes is private or not"
}


variable "workload_identity_enabled" {
  type        = bool
  default     = true
  description = "To enable or not the workload identity feature"
}

variable "config_connector_enabled" {
  type        = bool
  default     = true
  description = "To disable or not the config connector add-on"
}

variable "config_connector_sa_roles" {
  type = list(string)
  default = [
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin"
  ]
  description = "Roles for the config connector to be able to manage gcp resources"
}

variable "maintenance_exclusion" {
  type = list(object({
    exclusion_name = string
    start_time     = string
    end_time       = string
  }))
  default     = []
  description = "Exceptions to maintenance window. Non-emergency maintenance should not occur in these windows. A cluster can have up to three maintenance exclusions at a time"
}

variable "cluster_metering_dataset" {
  type        = string
  default     = "gke_cluster_metering"
  description = "GKE cluster metering dataset name"
}

variable "cluster_metering_enable_egress" {
  type        = bool
  default     = true
  description = "GKE cluster metering enable egress metering"
}

variable "cluster_metering_enable_consumption" {
  type        = bool
  default     = true
  description = "GKE cluster metering enable consumption metering"
}

variable "max_unavailable" {
  type        = number
  description = "The number of nodes that can be simultaneously unavailable during an upgrade. Increasing max_unavailable raises the number of nodes that can be upgraded in parallel. Can be set to 0 or greater."
  default     = 0
}

variable "max_surge" {
  type        = number
  description = "The number of additional nodes that can be added to the node pool during an upgrade. Increasing max_surge raises the number of nodes that can be upgraded simultaneously. Can be set to 0 or greater."
  default     = 1
}

variable "node_pool_timeout" {
  type        = string
  description = "Timeout for nodepool creation, update and deletion"
  default     = "120m"
}

variable "notification_config" {
  type    = map(any)
  default = {}
}

variable "enable_shielded_nodes" {
  type        = bool
  default     = false
  description = "Disable Shielded Nodes features on all nodes in this cluster"
}


variable "enable_nginx_conftroler" {
  default = true
  type = bool
  description = "Enable installation of nginx_controller using helm chart "
}
