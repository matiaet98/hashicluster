job "keycloak-postgres" {
  datacenters = ["matinet"]
  type = "service"
  
  group "keycloak-postgres" {
    count = 1
    
    restart {
      attempts = 5
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    
    ephemeral_disk {
      migrate = true
      size = 200
      sticky = true
    }
    
    task "postgres" {
      driver = "docker"
      
      constraint {
        attribute = "${attr.unique.hostname}"
        value     = "gaia"
      }

      config {
        image = "postgres:12-alpine"
        port_map {
          db = 5432
        }
      }
      
      logs {
        max_files     = 5
        max_file_size = 10
      }

      env {
        POSTGRES_DB = "keycloak"
        POSTGRES_USER = "keycloak"
        POSTGRES_PASSWORD = "keycloak"
      }

      resources {
        cpu    = 200
        memory = 128
        network {
          port "db" {}
        }
      }
      service {
        name = "keycloak-postgres"
        port = "db"
        check {
          type     = "tcp"
          interval = "5s"
          timeout  = "5s"
        }
      }
    }
  }

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }

  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }  
}

