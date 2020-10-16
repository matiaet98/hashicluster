job "ark-volume" {
  datacenters = ["matinet"]
  type = "service"

  constraint {
    attribute = "${attr.unique.hostname}"
    value     = "ark"
  }
  
  group "ark-volume" {
    count = 1
    task "ark-volume" {
      driver = "docker"

      config {
        image = "quay.io/k8scsi/hostpathplugin:v1.4.0"
        args = [
          "--drivername=csi-hostpath",
          "--v=5",
          "--endpoint=unix://data/csi/csi.sock",
          "--nodeid=ark",
        ]
      }
      csi_plugin {
        id        = "csi-hostpath"
        type      = "monolith"
        mount_dir = "/data/csi"
      }
      resources {
        cpu    = 500
        memory = 256
        network {
          mbits = 100
          port  "plugin"{}
        }
      }
    }
  }
}