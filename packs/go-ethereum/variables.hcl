variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  // If "", the pack name will be used
  default = "go-ethereum"
}

variable "region" {
  description = "The region where jobs will be deployed"
  type        = string
  default     = ""
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["dc1"]
}

variable "count" {
  description = "The number of app instances to deploy"
  type        = number
  default     = 1
}

variable "image_name" {
  description = "The docker image name (without tag)."
  type        = string
  default     = "ethereum/client-go"
}

variable "image_tag" {
  description = "The docker image tag."
  type        = string
  default     = "v1.10.17"
}

variable "register_consul_service" {
  description = "If you want to register a consul service for the job"
  type        = bool
  default     = true
}

variable "expose_ports" {
  description = "If you want to expose all ports to host"
  type        = bool
  default     = false
}

variable "http_enable" {
  description = "Enable the HTTP-RPC server"
  type        = bool
  default     = true
}

variable "http_port" {
  description = "The Nomad client port that routes to the RPC over HTTP port"
  type        = number
  default     = 8545
}

variable "http_consul_service_name" {
  description = "The consul service name for the geth HTTP-RPC server"
  type        = string
  default     = "geth-http"
}

variable "ws_enable" {
  description = "Enable the WS-RPC server"
  type        = bool
  default     = true
}

variable "ws_port" {
  description = "The Nomad client port that routes to the RPC over WS port"
  type        = number
  default     = 8546
}

variable "ws_consul_service_name" {
  description = "The consul service name for the geth application"
  type        = string
  default     = "geth-ws"
}

variable "metrics_enable" {
  description = "Enable metrics collection and reporting"
  type        = bool
  default     = true
}

variable "metrics_consul_service_name" {
  description = "The consul service name for the geth application"
  type        = string
  default     = "geth-metrics"
}

variable "metrics_port" {
  description = "The Nomad client port that routes to geth metrics port"
  type        = number
  default     = 6060
}

variable "consul_service_tags" {
  description = "The consul service name for the geth application"
  type        = list(string)
  // defaults to integrate with Fabio or Traefik
  // This routes at the root path "/", to route to this service from
  // another path, change "urlprefix-/" to "urlprefix-/<PATH>" and
  // "traefik.http.routers.http.rule=Path(`/`)" to
  // "traefik.http.routers.http.rule=Path(`/<PATH>`)"
  default = [
    "urlprefix-/",
    "traefik.enable=true",
    "traefik.http.routers.http.rule=Path(`/`)",
  ]
}
