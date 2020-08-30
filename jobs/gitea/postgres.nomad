job "gitea-postgres" {
  datacenters = ["matinet"]
  type = "service"
  
  group "gitea-postgres" {
    count = 1

    volume "gitea-postgres-vol" {
      type      = "host"
      read_only = false
      source    = "gitea-postgres-vol"
    }
    
    restart {
      attempts = 5
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    
    task "postgres" {
      driver = "docker"
      
      config {
        image = "postgres:12-alpine"
        port_map {
          db = 5432
        }
      }

      constraint {
        attribute = "${attr.unique.hostname}"
        value     = "gaia"
      }

      volume_mount {
        volume      = "gitea-postgres-vol"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }
      
      logs {
        max_files     = 5
        max_file_size = 10
      }

      env {
        POSTGRES_DB = "gitea"
        POSTGRES_USER = "gitea"
        POSTGRES_PASSWORD = "gitea"
      }

      resources {
        cpu    = 200
        memory = 128
        network {
          port "db" {}
        }
      }

      service {
        name = "gitea-postgres"
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

