terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.34.1"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {}


resource "digitalocean_project" "project" {
  name = var.project_name
  resources = [digitalocean_kubernetes_cluster.cluster.urn,
    digitalocean_domain.domain.urn
  ]
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name         = var.cluster_name
  region       = var.cluster_region
  version      = var.cluster_version
  vpc_uuid     = digitalocean_vpc.vpc.id
  auto_upgrade = false

  maintenance_policy {
    start_time = "03:00"
    day        = "saturday"
  }

  node_pool {
    name       = var.node_name
    size       = var.node_size
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
  }
}


resource "digitalocean_vpc" "vpc" {
  name     = var.vpc_name
  region   = var.vpc_region
  ip_range = var.vpc_range
}

resource "digitalocean_container_registry" "registry" {
  name                   = var.registry_name
  subscription_tier_slug = var.registry_slug
}