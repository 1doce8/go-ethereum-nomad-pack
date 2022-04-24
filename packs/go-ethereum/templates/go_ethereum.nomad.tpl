job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [ [[ range $idx, $dc := .go_ethereum.datacenters ]][[if $idx]],[[end]][[ $dc | quote ]][[ end ]] ]
  type = "service"

  [[- if .go_ethereum.namespace ]]
  namespace   = [[ .go_ethereum.namespace | quote ]]
  [[- end]]

  [[ template "constraints" . ]]

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

    [[ else if .go_ethereum.register_consul_service ]]
        mode = "bridge"
    [[ end ]]
    }

    [[ if .go_ethereum.register_consul_service ]]

    [[ if .go_ethereum.http_consul_service_enable ]]
    service {
      name = "[[ .go_ethereum.http_consul_service_name ]]"
      [[- if not (eq .go_ethereum.consul_service_tags "") ]]
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

    [[ if .go_ethereum.ws_consul_service_enable ]]
    service {
      name = "[[ .go_ethereum.ws_consul_service_name ]]"
      [[- if not (eq .go_ethereum.consul_service_tags "") ]]
      tags = [[ .go_ethereum.consul_service_tags | toStringList ]]
      [[- end ]]
      port = "[[ .go_ethereum.ws_port ]]"
    }
    [[ end ]]

    [[ if .go_ethereum.metrics_consul_service_enable ]]
    service {
      name = "[[ .go_ethereum.metrics_consul_service_name ]]"
      [[- if not (eq .go_ethereum.consul_service_tags "") ]]
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

    [[ if .go_ethereum.authrpc_consul_service_enable ]]
    service {
      name = "[[ .go_ethereum.authrpc_consul_service_name ]]"
      [[- if not (eq .go_ethereum.consul_service_tags "") ]]
      tags = [[ .go_ethereum.consul_service_tags | toStringList ]]
      [[- end ]]
      port = "[[ .go_ethereum.authrpc_port ]]"
    }
    [[ end ]]

    [[ end ]]

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    [[ template "volume" . ]]

    [[- if not (eq .go_ethereum.template_path "") ]]
    template {
        data = <<EOH
        [[ fileContents .go_ethereum.template_path ]]
        EOH
        destination = "local/config.toml"
        change_mode = "noop"
    }
    [[- end ]]

    task [[ template "job_name" . ]] {
      driver = "docker"

      config {
        image = "[[ .go_ethereum.image_name ]]:[[ .go_ethereum.image_tag ]]"

        [[ template "auth" . ]]

        [[ template "args" . ]]

        [[ template "volume-mount" . ]]
      }
    }
  }
}
