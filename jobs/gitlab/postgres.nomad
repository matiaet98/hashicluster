job "gitlab-postgres" {
  datacenters = ["matinet"]
  type = "service"
  
  group "gitlab-postgres" {
    count = 1
    
    task "postgres" {
      driver = "docker"
      
      config {
        image = "postgres:12-alpine"
        port_map {
          db = 5432
        }
        volumes = [
          "/volume/gitlab/postgres:/var/lib/postgresql/data"
        ]
      }

      env {
        POSTGRES_DB = "gitlab"
        POSTGRES_USER = "gitlab"
        POSTGRES_PASSWORD = "gitlab"
      }

      resources {
        cpu    = 200
        memory = 128
        network {
          port "db" {}
        }
      }

      service {
        name = "gitlab-postgres"
        port = "db"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "10s"
        }
      }
    }
  }
}

