variable "project_name" {
  default     = "k8s-project"
  description = "Nome para o projeto organizador na DO."
}

variable "cluster_name" {
  default     = "k8s-cluster"
  description = "Nome para o cluster DOKS na DO."
}

variable "cluster_version" {
  default     = "1.29.0-do.0"
  description = "Versão do DOKS disponibilizada na DO."
}

variable "cluster_region" {
  default     = "sfo3"
  description = "Região ou datacenter que o cluster será criado."
}

variable "node_name" {
  default     = "k8s-node"
  description = "Nome do node-pool para o cluster."
}

variable "node_size" {
  default     = "s-2vcpu-2gb"
  description = "Size para os nodes que serão criados, Droplets na DO."
}

variable "vpc_name" {
  default     = "k8s-vpc"
  description = "Nome para VPC que comporta o projeto k8S."
}

variable "vpc_range" {
  default     = "10.0.0.0/24"
  description = "Faixa de IPs privados dentro da rede do cluster."
}

variable "vpc_region" {
  default     = "sfo3"
  description = "Size para os nodes que serão criados, Droplets na DO."
}

variable "registry_name" {
  default     = "dellabeneta-k8s-project"
  description = "Nome do resistro de imagens de container."
}

variable "registry_slug" {
  default     = "basic"
  description = "Slug ou tipo de assinatura do registro de imagens."
}

variable "domain_name" {
  default     = "dellabeneta.online"
  description = "Meu domínio da GoDaddy para uma zone de dns na DO."
}