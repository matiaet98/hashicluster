terraform {
  required_version = "~> 0.13.0"
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 1.4.0"
    }
  }
}

provider "nomad" {
    address = "http://ark.matinet.org:4646"
}

resource "nomad_job" "minio" {
    provider = nomad
    jobspec = file("${path.module}/minio.nomad")
}
