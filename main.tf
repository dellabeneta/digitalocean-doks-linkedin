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
  name = var.projectname
  resources = [ digitalocean_kubernetes_cluster.cluster.urn,
                digitalocean_domain.domain.urn
            ]
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name     = var.clustername
  region   = var.clusterregion
  version  = var.clusterversion
  vpc_uuid = digitalocean_vpc.vpc.id
  auto_upgrade = false

  maintenance_policy {
    start_time = "03:00"
    day        = "saturday"
  }

  node_pool {
    name       = var.nodename
    size       = var.nodesize
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
  }
}


resource "digitalocean_vpc" "vpc" {
  name     = var.vpcname
  region   = var.vpcregion
  ip_range = var.vpcrange
}

resource "digitalocean_container_registry" "registry" {
  name = var.registryname
  subscription_tier_slug = var.registryslug
}