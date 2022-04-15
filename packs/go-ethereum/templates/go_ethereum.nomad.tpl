job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [[ .go_ethereum.datacenters  | toJson ]]
  type = "service"

  group [[ template "job_name" . ]] {

    count = [[ .go_ethereum.count ]]

    network {

    [[ if .go_ethereum.expose_ports ]]

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
        port "metrics-[[ template "job_name" . ]]" {
          to = "[[ .go_ethereum.metrics_port ]]"
        }
        [[ end ]]

    [[ end ]]
    [[ if .go_ethereum.register_consul_service ]][[ if not .go_ethereum.expose_ports ]]
        mode = "bridge"
    [[ end ]][[ end ]]
    }

    [[ if .go_ethereum.register_consul_service ]]

    [[ if .go_ethereum.http_enable ]]
    service {
      name = "[[ .go_ethereum.http_consul_service_name ]]"
      [[- if ne (len .go_ethereum.consul_service_tags) 0 ]]
      tags = [[ .go_ethereum.consul_service_tags | toStringList ]]
      [[- end ]]
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

    [[ if .go_ethereum.ws_enable ]]
    service {
      name = "[[ .go_ethereum.ws_consul_service_name ]]"
      [[- if ne (len .go_ethereum.consul_service_tags) 0 ]]
      tags = [[ .go_ethereum.consul_service_tags | toStringList ]]
      [[- end ]]
      port = "[[ .go_ethereum.ws_port ]]"
    }
    [[ end ]]

    [[ if .go_ethereum.metrics_enable ]]
    service {
      name = "[[ .go_ethereum.metrics_consul_service_name ]]"
      [[- if ne (len .go_ethereum.consul_service_tags) 0 ]]
      tags = [[ .go_ethereum.consul_service_tags | toStringList ]]
      [[- end ]]
      port = "[[ .go_ethereum.metrics_port ]]"

      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }
    [[ end ]]

    [[ end ]]

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task [[ template "job_name" . ]] {
      driver = "docker"

      config {
        image = "[[ .go_ethereum.image_name ]]:[[ .go_ethereum.image_tag ]]"
      }

      args = [
          [[ if .go_ethereum.http_enable ]]
          "--http",
          "--http.addr=[[ .go_ethereum.http_addr ]]",
          "--http.port=[[ .go_ethereum.http_port ]]",
          "--http.api=[[ .go_ethereum.http_api ]]",
          "--http.rpcprefix=[[ .go_ethereum.http_rpcprefix ]]"
          "--http.corsdomain=[[ .go_ethereum.http_corsdomain ]]",
          "--http.vhosts=[[ .go_ethereum.http_vhosts ]]",
          [[ end ]]
          [[ if .go_ethereum.ws_enable ]]
          "--ws",
          "--ws.addr=[[ .go_ethereum.ws_addr ]]",
          "--ws.port=[[ .go_ethereum.ws_port ]]",
          "--ws.api=[[ .go_ethereum.ws_api ]]",
          "--ws.rpcprefix=[[ .go_ethereum.ws_rpcprefix ]]"
          "--ws.origins=[[ .go_ethereum.ws_origins ]]",
          [[ end ]]
          "--snapshot=false",
          "--syncmode=full",
          "--cache="
      ]

    }
  }
}
