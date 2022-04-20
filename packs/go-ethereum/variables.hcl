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
  description = "A list of datacenters in the region which are eligible for task placement (default: dc1)"
  type        = list(string)
  default     = ["dc1"]
}

variable "count" {
  description = "The number of app instances to deploy (default: 1)"
  type        = number
  default     = 1
}

variable "image_name" {
  description = "The docker image name without tag (default: ethereum/client-go)"
  type        = string
  default     = "ethereum/client-go"
}

variable "image_tag" {
  description = "The docker image tag (default: v1.10.17)"
  type        = string
  default     = "v1.10.17"
}

variable "register_consul_service" {
  description = "If you want to register a consul service for the job (default: true)"
  type        = bool
  default     = true
}

variable "expose_ports" {
  description = "If you want to expose all ports to host (default: false)"
  type        = bool
  default     = false
}

### RPC over HTTP

variable "http_enable" {
  description = "Enable the HTTP-RPC server (default: true)"
  type        = bool
  default     = true
}

variable "http_addr" {
  description = "The Nomad client port that routes to the RPC over HTTP port (default: 8545)"
  type        = string
  default     = "127.0.0.1"
}

variable "http_port" {
  description = "The Nomad client port that routes to the RPC over HTTP port (default: 8545)"
  type        = number
  default     = 8545
}

variable "http_api" {
  description = "The API's offered over the HTTP-RPC interface (default: eth,net,web3,txpool)"
  type        = string
  default     = "eth,net,web3,txpool"
}

variable "http_rpcprefix" {
  description = "The HTTP path path prefix on which JSON-RPC is served. Use '/' to serve on all paths. (default: /)"
  type        = string
  default     = "/"
}

 variable "http_corsdomain" {
   description = "The comma separated list of domains from which to accept cross origin requests (browser enforced) (default: *)"
   type        = string
   default     = "*"
 }

 variable "http_vhosts" {
   description = "The comma separated list of virtual hostnames from which to accept requests (server enforced). Accepts '*' wildcard. (default: localhost)"
   type        = string
   default     = "localhost"
 }


variable "http_consul_service_name" {
  description = "The consul service name for the geth HTTP-RPC server (default: geth-http)"
  type        = string
  default     = "geth-http"
}

## ACCOUNT OPTIONS

--allow-insecure-unlock

variable "account_unlock" {
  description = "Comma separated list of accounts to unlock (default: '')"
  type        = string
  default     = ""
}

variable "account_password" {
  description = "Password file to use for non-interactive password input (default: '')"
  type        = string
  default     = ""
}

variable "account_signer" {
  description = "External signer (url or path to ipc file) (default: '')"
  type        = string
  default     = ""
}

variable "account_allow_insecure_unlock" {
  description = "Allow insecure account unlocking when account-related RPCs are exposed by http (default: false)"
  type        = bool
  default     = false
}

## API AND CONSOLE OPTIONS

### IPC socket

variable "ipc_disable" {
  description = "Disable the IPC-RPC server (default: true)"
  type        = bool
  default     = true
}

variable "ipc_path" {
  description = "Filename for IPC socket/pipe within the datadir (explicit paths escape it) (default: '')"
  type        = string
  default     = ""
}

### RPC over websockets

variable "ws_enable" {
  description = "Enable the WS-RPC server (default: true)"
  type        = bool
  default     = true
}

variable "ws_addr" {
  description = "The WS-RPC server listening interface (default: localhost)"
  type        = string
  default     = "127.0.0.1"
}

variable "ws_port" {
  description = "The Nomad client port that routes to the RPC over WS port (default: 8546)"
  type        = number
  default     = 8546
}

variable "ws_api" {
  description = "API's offered over the WS-RPC interface (default: eth,net,web3,txpool)"
  type        = string
  default     = "eth,net,web3,txpool"
}

variable "ws_rpcprefix" {
  description = "HTTP path prefix on which JSON-RPC is served. Use '/' to serve on all paths (default: *)"
  type        = string
  default     = "*"
}

variable "ws_origins" {
  description = "Origins from which to accept websockets requests (default: *)"
  type        = string
  default     = "*"
}

variable "ws_consul_service_name" {
  description = "The consul service name for the geth application websocket port (default: geth-ws)"
  type        = string
  default     = "geth-ws"
}

### Auth RPC

variable "authrpc_jwtsecret" {
  description = "Path to a JWT secret to use for authenticated RPC endpoints (default: '')"
  type        = string
  default     = ""
}

variable "authrpc_addr" {
  description = "Listening address for authenticated APIs (default: 'localhost')"
  type        = string
  default     = "localhost"
}

variable "authrpc_port" {
  description = "Listening port for authenticated APIs (default: 8551)"
  type        = number
  default     = "8551"
}

variable "authrpc_vhosts" {
  description = "Comma separated list of virtual hostnames from which to accept requests (server enforced). Accepts '*' wildcard. (default: '*')"
  type        = string
  default     = "*"
}

variable "authrpc_consul_service_name" {
  description = "The consul service name for the geth application authrpc port (default: geth-authrpc)"
  type        = string
  default     = "geth-authrpc"
}

### GRAPTHQL

variable "graphql_enable" {
  description = "Enable GraphQL on the HTTP-RPC server. Note that GraphQL can only be started if an HTTP server is started as well. (default: false)"
  type        = bool
  default     = false
}

variable "graphql_corsdomain" {
  description = "Comma separated list of domains from which to accept cross origin requests (browser enforced) (default: *)"
  type        = string
  default     = "*"
}

variable "graphql_vhosts" {
  description = "Comma separated list of virtual hostnames from which to accept requests (server enforced). Accepts '*' wildcard (default: *)"
  type        = string
  default     = "*"
}

### RPC SETTING

variable "rpc_gascap" {
  description = "Sets a cap on gas that can be used in eth_call/estimateGas (0=infinite) (default: 50000000)"
  type        = number
  default     = 50000000
}

variable "rpc_evmtimeout" {
  description = "Sets a timeout used for eth_call (0=infinite) (default: 5s)"
  type        = number
  default     = 5
}

variable "rpc_txfeecap" {
  description = "Sets a cap on transaction fee (in ether) that can be sent via the RPC APIs (0 = no cap) (default: 1)"
  type        = number
  default     = 1
}

variable "rpc_allow_unprotected_txs" {
  description = "Allow for unprotected (non EIP155 signed) transactions to be submitted via RPC (default: true)"
  type        = bool
  default     = true
}

### JavaScript SETTINGS

variable "js_path" {
  description = "JavaScript root path for loadScript (default: '.')"
  type        = string
  default     = "."
}

variable "js_exec" {
  description = "Execute JavaScript statement (default: '')"
  type        = string
  default     = ""
}

variable "js_preload" {
  description = "Comma separated list of JavaScript files to preload into the console (default: '')"
  type        = string
  default     = ""
}

### METRICS
variable "metrics_enable" {
  description = "Enable metrics collection and reporting (default: true)"
  type        = bool
  default     = true
}

variable "metrics_consul_service_name" {
  description = "The consul service name for the geth application (default: geth-metrics)"
  type        = string
  default     = "geth-metrics"
}

variable "metrics_port" {
  description = "The Nomad client port that routes to geth metrics port (default: 6060)"
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
