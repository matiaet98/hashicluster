log_level = "INFO"
log_rotate_bytes = 10485760 # 10MB
data_dir = "/data/nomad"
datacenter = "matinet"

server {
  enabled = true
  bootstrap_expect = 1
  node_gc_threshold = "30m"
  job_gc_threshold = "5m"
}

client {
  enabled = true
  servers = ["gaia.matinet.org:4647"]
  
  host_volume "keycloak-postgres-vol" {
    path = "/volume/keycloak/postgres-vol"
    read_only = false
  }

  host_volume "gitea-postgres-vol" {
    path = "/volume/gitea/postgres-vol"
    read_only = false
  }
}

consul {
  address = "gaia.matinet.org:8500"
  server_service_name = "gaia-nomad"
  client_service_name = "gaia-nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}

plugin "docker" {
  config {    
    volumes {
      enabled      = true
      selinuxlabel = "z"
    }
    allow_privileged = true
    allow_caps = ["ALL"]
  }
}
