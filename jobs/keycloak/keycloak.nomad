job "keycloak" {
  datacenters = ["matinet"]
  type = "service"
  
  group "keycloak" {
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
    
    task "keycloak" {
      driver = "docker"
      
      config {
        image = "quay.io/keycloak/keycloak:11.0.1"
        port_map {
          http = 8080
        }
      }

      constraint {
        attribute = "${attr.unique.hostname}"
        value     = "gaia"
      }
      
      logs {
        max_files     = 5
        max_file_size = 10
      }

      env {
        KEYCLOAK_USER="keycloak"
        KEYCLOAK_PASSWORD="keycloak"
        DB_VENDOR="postgres"
        DB_DATABASE="keycloak"
        DB_USER="keycloak"
        DB_PASSWORD="keycloak"
        KEYCLOAK_HOSTNAME="gaia.matinet.org"
        KEYCLOAK_ALWAYS_HTTPS=false
      }
      template {
        data = <<EOH
        DB_ADDR = "{{ range service "keycloak-postgres" }}{{ .Address }}{{ end }}"
        DB_PORT="{{ range service "keycloak-postgres" }}{{ .Port }}{{ end }}"
        EOH
        destination = "keycloak-postgres.env"
        env         = true
      }

      resources {
        cpu    = 2000
        memory = 2048
        network {
          port "http" {
            static = 8080
          }
        }
      }
      service {
        name = "keycloak"
        tags = ["urlprefix-/"]
        port = "http"
        check {
          name     = "alive"
          type     = "http"
          path     = "/"
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

