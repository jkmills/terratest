################################################################################
# Terraform Configuration and Backend Setup
#
# Configures required providers and S3-compatible backend for state management
# using Nutanix Object Storage.
################################################################################

terraform {
  # Require Terraform 1.5 or higher for stability
  required_version = ">= 1.5"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.19"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.2"
    }
  }

  # S3-compatible backend using Nutanix Object Storage
  backend "s3" {
    key    = "terraform.tfstate"
    region = "us-east-1" # Local Nutanix Object Storage region
    endpoints = { s3 = "http://obj02.somecompany.com" }
    bucket = "tf-nkp-dc1-cl01"
    encrypt = true
    # DynamoDB is not available on this platform

    # Nutanix Object Storage compatibility settings
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

################################################################################
# Provider Configurations
#
# Configures Kubernetes and Helm providers to use current kubeconfig context
################################################################################

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "jkmills-nkp-dc1-cl01.somecompany.com"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "jkmills-nkp-dc1-cl01.somecompany.com"
  }
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "jkmills-nkp-dc1-cl01.somecompany.com"
}
