job "gitea" {
  datacenters = ["matinet"]
  type = "service"

  group "gitea" {
    count = 1
    
    restart {
      attempts = 5
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "gitea" {
      driver = "docker"
      config {
        image = "gitea/gitea:latest"
        port_map {
          http = 3000
          ssh = 22
        }
        volumes = [
          "/etc/timezone:/etc/timezone",
          "/etc/localtime:/etc/localtime"
        ]
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      env {
        USER_UID = "1000"
        USER_GID = "1000"
        DB_TYPE = "postgres"
        DB_NAME = "gitea"
        DB_USER = "gitea"
        DB_PASSWD = "gitea"
        #DB_HOST = "10.0.0.2:24183"
      }
      
      template {
        data = <<EOH
        DB_HOST="{{ range service "gitea-postgres" }}{{ .Address }}:{{ .Port }}{{ end }}"
        EOH
        destination = "gitea-postgres.env"
        env         = true
      }

      resources {
        cpu    = 2000
        memory = 256
        network {
          port "http" {
            static = 3000
          },
          port "ssh" {
            static = 2222
          }
        }
      }
      
      service {
        name = "gitea"
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

  constraint {
    attribute = "${attr.unique.hostname}"
    value     = "gaia"
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