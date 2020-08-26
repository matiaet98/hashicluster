log_level = "INFO"
log_rotate_bytes = 10485760 # 10MB
data_dir = "/data/nomad"
datacenter = "matinet"

server {
  enabled = true
  server_join {
    retry_join = ["gaia:4648"]
  }
}

client {
  enabled = true
  servers = ["gaia:4647", "ark:4647"]
}

consul {
  address = "localhost:8500"
  server_service_name = "ark-nomad"
  client_service_name = "ark-nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}
