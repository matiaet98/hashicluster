log_level = "INFO"
log_rotate_bytes = 10485760 # 10MB
data_dir = "/opt/nomad"
datacenter = "matinet"

server {
  enabled = true
  bootstrap_expect = 1
  node_gc_threshold = "30m"
  job_gc_threshold = "5m"
}

client {
  enabled = true
  servers = ["localhost:4647"]
}

consul {
  address = "localhost:8500"
  server_service_name = "ark-nomad-server"
  client_service_name = "ark-nomad-client"
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

