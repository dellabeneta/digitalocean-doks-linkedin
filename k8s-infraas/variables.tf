variable "projectname" {
    default = "k8s-project"
    description = "Nome para o projeto organizador na DO."
}

variable "clustername" {
    default = "k8s-cluster"
    description = "Nome para o cluster DOKS na DO."
}

variable "clusterversion" {
    default = "1.29.0-do.0"
    description = "Versão do DOKS disponibilizada na DO."
}

variable "clusterregion" {
    default = "sfo3"
    description = "Região ou datacenter que o cluster será criado."
}

variable "nodename" {
    default = "k8s-node"
    description = "Nome do node-pool para o cluster."
}

variable "nodesize" {
    default = "s-2vcpu-2gb"
    description = "Size para os nodes que serão criados, Droplets na DO."
}

variable "vpcname" {
    default = "k8s-vpc"
    description = "Nome para VPC que comporta o projeto k8S."  
}

variable "vpcrange" {
    default = "10.0.0.0/24"
    description = "Faixa de IPs privados dentro da rede do cluster."
}

variable "vpcregion" {
    default = "sfo3"
    description = "Size para os nodes que serão criados, Droplets na DO."
}

variable "registryname" {
    default = "dellabeneta-k8s-project"
    description = "Nome do resistro de imagens de container."  
}

variable "registryslug" {
    default = "basic"
    description = "Slug ou tipo de assinatura do registro de imagens."  
}

