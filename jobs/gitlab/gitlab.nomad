job "gitlab" {
  datacenters = ["matinet"]
  type = "service"

  group "gitlab" {
    count = 1
    
    task "gitlab" {
      driver = "docker"
      config {
        hostname = "gitlab"
        image = "gitlab/gitlab-ee:latest"
        port_map {
          http = 80
          https = 443
          ssh = 22
        }
        volumes = [
          "/volume/gitlab/data:/var/opt/gitlab",
          "local/gitlab.rb:/etc/gitlab/gitlab.rb"
        ]
      }

      template {
        data      = <<EOH
        external_url 'http://{{ env "attr.unique.hostname" }}.matinet.org'
        gitlab_rails['object_store']['enabled'] = false
        gitlab_rails['object_store']['connection'] = {}
        gitlab_rails['object_store']['storage_options'] = {}
        gitlab_rails['object_store']['proxy_download'] = false
        gitlab_rails['object_store']['objects']['artifacts']['bucket'] = nil
        gitlab_rails['object_store']['objects']['external_diffs']['bucket'] = nil
        gitlab_rails['object_store']['objects']['lfs']['bucket'] = nil
        gitlab_rails['object_store']['objects']['uploads']['bucket'] = nil
        gitlab_rails['object_store']['objects']['packages']['bucket'] = nil
        gitlab_rails['object_store']['objects']['dependency_proxy']['bucket'] = nil
        gitlab_rails['object_store']['objects']['terraform_state']['bucket'] = nil
        postgresql['enable'] = false
        gitlab_rails['db_adapter'] = "postgresql"
        gitlab_rails['db_encoding'] = "utf8"
        gitlab_rails['db_collation'] = nil
        gitlab_rails['db_database'] = "gitlab"
        gitlab_rails['db_username'] = "gitlab"
        gitlab_rails['db_password'] = "gitlab"
        gitlab_rails['db_host'] = "{{ range service "gitlab-postgres" }}{{ .Address }}{{ end }}"
        gitlab_rails['db_port'] = "{{ range service "gitlab-postgres" }}{{ .Port }}{{ end }}"
        redis['enable'] = false
        nginx['enable'] = false
        prometheus['enable'] = false
        EOH
        destination = "local/gitlab.rb"
      }

      resources {
        cpu    = 10000
        memory = 2048
        network {
          port "http" {
            static = 8080
          },
          port "ssh" {
            static = 2022
          }
        }
      }
      
      service {
        name = "gitlab"
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
}
