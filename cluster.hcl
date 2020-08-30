log_level = "INFO"
log_rotate_bytes = 10485760 # 10MB
data_dir = "/data/nomad"
datacenter = "matinet"

server {
  enabled = true
}

client {
  enabled = true
  servers = ["gaia:4647", "ark:4647"]
  host_volume "postgres-vol" {
    path = "/volume/keycloak/postgres-vol"
    read_only = false
  }
}

consul {
  address = "localhost:8500"
  server_service_name = "gaia-nomad"
  client_service_name = "gaia-nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}
