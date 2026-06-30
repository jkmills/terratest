################################################################################
# Root Terraform Module for NKP Cluster Management
#
# This module orchestrates the deployment of various Kubernetes resources and
# applications to the Nutanix Kubernetes Platform (NKP) cluster.
#
# Modules deployed:
# - ghrunners: GitHub Actions self-hosted runners
# - kubernetes-dashboard: Kubernetes web UI
#
# Note: Modules contain their own provider configurations (legacy pattern),
# which prevents use of depends_on. Deploy order is managed through implicit
# dependencies and manual coordination.
################################################################################

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

variable "kubeconfig_path" {
  description = "Path to kubeconfig file for cluster authentication"
  type        = string
  default     = "~/.kube/config"

  validation {
    condition     = can(regex("^[~/].*", var.kubeconfig_path))
    error_message = "The kubeconfig_path must be an absolute path starting with / or ~."
  }
}


# -----------------------------------------------------------------------------
# Modules
# -----------------------------------------------------------------------------

# GitHub Actions runners
module "ghrunners" {
  source = "./modules/ghrunners"

  kubeconfig_path = var.kubeconfig_path
}

# Kubernetes Dashboard
module "kubernetes-dashboard" {
  source = "./modules/kubernetes-dashboard"

  kubeconfig_path = var.kubeconfig_path
}

