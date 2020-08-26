log_level = "INFO"
log_rotate_bytes = 10485760 # 10MB
data_dir = "/data/nomad"
datacenter = "matinet"

server {
  enabled = true
}

client {
  enabled = true
}

consul {
  address = "localhost:8500"
  server_service_name = "ark-nomad"
  client_service_name = "ark-nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}
