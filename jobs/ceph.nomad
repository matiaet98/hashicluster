job "ceph" {
  datacenters = ["matinet"]
  type = "service"

  group "ceph" {
    count = 1
    
    #Lo fuerzo porque en este server es donde esta el storage grande
    constraint {
      attribute = "${attr.unique.hostname}"
      value     = "gaia"
    }
    
    restart {
      attempts = 5
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    volume "pg_vol_grp" {
      type = "host"
      source = "pg_vol"
      read_only = false
    }

    ephemeral_disk {
      migrate = true
      size = 100
      sticky = true
    }

    task "pg12" {
      driver = "docker"
      config {
        image = "postgres:12-alpine"
        port_map {
          db = 5432
        }
      }
      volume_mount {
        volume      = "pg_vol_grp"
        destination = "/var/lib/postgresql/data"
        read_only = false
      }
      logs {
        max_files     = 5
        max_file_size = 10
      }
      env {
        POSTGRES_DB = "prueba"
        POSTGRES_USER = "prueba"
        POSTGRES_PASSWORD = "prueba"
      }
      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
        network {
          port "db" {
            static = 5432
          }
        }
      }
      service {
        name = "database"
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
