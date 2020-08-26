log_level = "INFO"
data_dir = "/data/gaia-nomad-server"
datacenter = "matinet"

server {
    enabled = true
    bootstrap_expect = 1
}

consul {
  address = "gaia:8500"
  server_service_name = "gaia-nomad"
  client_service_name = "gaia-nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}