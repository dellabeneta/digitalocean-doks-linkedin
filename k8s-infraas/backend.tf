terraform {
  cloud {
    organization = "dellabeneta"

    workspaces {
      name = "k8s-project"
    }
  }
}