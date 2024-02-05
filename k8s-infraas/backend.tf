terraform {
  cloud {
    organization = "dellabeneta"

    workspaces {
      name = "k8s-project"
    }
  }

  required_version = ">= 1.1.2"
}