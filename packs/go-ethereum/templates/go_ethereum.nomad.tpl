job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [[ .go_ethereum.datacenters  | toJson ]]
  type = "service"

  group "app" {

    count = [[ .go_ethereum.count ]]

    network {
    [[ if .go_ethereum.expose_ports ]][[ if .go_ethereum.register_consul_service ]]

        mode = "host"

        [[ if .go_ethereum.http_enable ]]
            port "http-[[ template "job_name" . ]]" {
              to = [[ .go_ethereum.http_port ]]
            }
        [[ end ]]
        [[ if .go_ethereum.ws_enable ]]
            port "ws-[[ template "job_name" . ]]" {
              to = [[ .go_ethereum.ws_port ]]
            }
        [[ end ]]
        [[ if .go_ethereum.metrics_enable ]]
          network {
            port "metrics-[[ template "job_name" . ]]" {
              to = "[[ .go_ethereum.metrics_port ]]"
            }
          }
        [[ end ]]

    [[ end ]][[ end ]]
    [[ if .go_ethereum.register_consul_service ]]
        mode = "bridge"
    [[ end ]]
    }

    [[ if .go_ethereum.register_consul_service ]]
    service {
      name = "[[ .go_ethereum.http_consul_service_name ]]"
      tags = [[ .go_ethereum.consul_service_tags | toJson ]]
      port = "[[ .go_ethereum.http_port ]]"

      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }
    [[ end ]]

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "[[ template "job_name" . ]]" {
      driver = "docker"

      config {
        image = "[[ .go_ethereum.image_name ]]:[[ .go_ethereum.image_tag ]]"
      }
    }
  }
}
