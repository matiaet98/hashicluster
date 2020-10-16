job "minio" {
  datacenters = ["matinet"]
  type = "service"
  
  group "minio" {
    count = 1
    task "minio" {
      driver = "docker"
      
      config {
        image = "minio/minio:latest"
        command = "server"
        args = ["/data/nomad"]
        port_map {
          http = 9000
        }
      }
      env {
        MINIO_ACCESS_KEY="minio"
        MINIO_SECRET_KEY="minio1234"
      }
      resources {
        cpu    = 512
        memory = 1024
        network {
          port "http" {
            static = 9000
          }
        }
      }
      service {
        name = "minio"
        tags = ["urlprefix-/"]
        port = "http"
        check {
          name     = "alive"
          type     = "http"
          path     = "/minio"
          interval = "20s"
          timeout  = "10s"
        }
      }
    }
  }
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }  
}

