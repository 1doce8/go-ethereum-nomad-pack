// allow nomad-pack to set the job name

[[ define "job_name" ]]
[[- if eq .go_ethereum.job_name "" -]]
[[- .nomad_pack.pack.name | quote -]]
[[- else -]]
[[- .go_ethereum.job_name | quote -]]
[[- end ]]
[[- end ]]

// only deploys to a region if specified

[[ define "region" -]]
[[- if not (eq .go_ethereum.region "") -]]
  region = [[ .go_ethereum.region | quote]]
[[- end -]]
[[- end -]]

// Provide auth if specified
[[ define "auth" -]]
  [[- if not (eq .go_ethereum.registry_auth_username "") -]]
  [[- if not (eq .go_ethereum.registry_auth_password "") -]]
      auth {
        username = [[ .go_ethereum.registry_auth_username | quote]]
        password = [[ .go_ethereum.registry_auth_password | quote]]
      }
  [[- end -]]
  [[- end -]]
[[- end ]]

// Generic resources template
[[ define "resources" -]]
[[- $resources := . ]]
      resources {
        cpu    = [[ $resources.cpu ]]
        memory = [[ $resources.memory ]]
      }
[[- end ]]

// Generic constraint

[[ define "constraints" ]]
[[- if .go_ethereum.constraints ]]
[[ range $idx, $constraint := .go_ethereum.constraints ]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    [[ if $constraint.operator -]]
    operator  = [[ $constraint.operator | quote ]]
    [[ end -]]
    value     = [[ $constraint.value | quote ]]
  }
[[ end ]]
[[ end -]]
[[ end ]]


// Volume template
[[- define "volume" -]]
[[ if .go_ethereum.volume_enable ]]
    volume "[[ .go_ethereum.volume_name ]]" {
      type      = "[[ .go_ethereum.volume_type ]]"
      read_only = [[ .go_ethereum.volume_read_only ]]
      source    = "[[ .go_ethereum.volume_name ]]"
    }
[[ end ]]
[[- end ]]

// Volume mount if volume specified
[[- define "volume-mount" -]]
[[ if .go_ethereum.volume_enable ]]
        volume_mount {
          volume      = "[[ .go_ethereum.volume_name ]]"
          destination = "[[ .go_ethereum.datadir_path ]]"
          read_only   = [[ .go_ethereum.volume_read_only ]]
        }
[[ end ]]
[[- end ]]

// Args template
[[- define "args" -]]
      args = [
        [[/* ETHEREUM OPTIONS */]]
        [[ if not (eq .go_ethereum.config_path "") ]]
        "--config = [[ .go_ethereum.config_path ]]",
        [[ end ]]
        [[ if not (eq .go_ethereum.datadir_path "") ]]
        "--datadir = [[ .go_ethereum.datadir_path ]]",
        [[ end ]]
        [[ if not (eq .go_ethereum.datadir_ancient "") ]]
        "--datadir = [[ .go_ethereum.datadir_ancient ]]",
        [[ end ]]
        [[ if not (eq .go_ethereum.datadir_minfreedisk "") ]]
        "--datadir = [[ .go_ethereum.datadir_minfreedisk ]]",
        [[ end ]]
        [[ if not (eq .go_ethereum.datadir_keystore "") ]]
        "--keystore = [[ .go_ethereum.datadir_keystore ]]",
        [[ end ]]
        [[ if not (eq .go_ethereum.datadir_keystore "") ]]
        "--keystore = [[ .go_ethereum.datadir_keystore ]]",
        [[ end ]]
        [[ if .go_ethereum.usb ]]
        "--usb"
        [[ end ]]
        [[ if not (eq .go_ethereum.pcscdpath "") ]]
        "--pcscdpath = [[ .go_ethereum.pcscdpath ]]",
        [[ end ]]
        [[ if not (eq .go_ethereum.network_id "") ]]
        "--network_id = [[ .go_ethereum.network_id ]]",
        [[ else if .go_ethereum.dev_enable  ]]
        [[ else if not (eq .go_ethereum.network_alias "")  ]]
        "--[[ .go_ethereum.network_alias ]]"
        [[ end ]]
        [[ if not (eq .go_ethereum.sync_syncmode "") ]]
        "--syncmode = [[ .go_ethereum.sync_syncmode ]]",
        [[ end ]]
        [[ if .go_ethereum.sync_exitwhensynced ]]
        "--exitwhensynced"
        [[ end ]]
        [[ if not (eq .go_ethereum.sync_gcmode "") ]]
        "--gcmode = [[ .go_ethereum.sync_gcmode ]]",
        [[ end ]]
        [[ if not (eq .go_ethereum.txlookuplimit "") ]]
        "--txlookuplimit = [[ .go_ethereum.txlookuplimit ]]",
        [[ end ]]
        [[ if not (eq .go_ethereum.ethstats "") ]]
        "--ethstats = [[ .go_ethereum.ethstats ]]",
        [[ end ]]
        [[ if not (eq .go_ethereum.identity "") ]]
        "--identity = [[ .go_ethereum.identity ]]",
        [[ end ]]
        [[ if .go_ethereum.lightkdf ]]
        "--lightkdf = [[ .go_ethereum.lightkdf ]]",
        [[ end ]]
        [[ if not (eq .go_ethereum.eth_requiredblocks "") ]]
        "--eth.requiredblocks = [[ .go_ethereum.eth_requiredblocks ]]",
        [[ end ]]

        [[/* LIGHT CLIENT OPTIONS */]]
        [[ if eq .go_ethereum.sync_syncmode "light" ]]

        "--light.serve = [[ .go_ethereum.light_serve ]]",
        "--light.ingress = [[ .go_ethereum.light_ingress ]]",
        "--light.egress = [[ .go_ethereum.light_egress ]]",
        "--light.maxpeers = [[ .go_ethereum.light_maxpeers ]]",

          [[ if not (eq .go_ethereum.ulc_servers "") ]]
        "--ulc.servers  = [[ .go_ethereum.ulc_servers ]]",
          [[ end ]]

        "--ulc.fraction = [[ .go_ethereum.ulc_fraction ]]",

          [[ if .go_ethereum.ulc_onlyannounce ]]
        "--ulc.onlyannounce",
          [[ end ]]
          [[ if .go_ethereum.light_nopruning ]]
        "--light.nopruning",
          [[ end ]]
          [[ if .go_ethereum.light_nosyncserve ]]
        "--light.nosyncserve ",
          [[ end ]]

        [[ end ]]

        [[/* DEVELOPER CHAIN OPTIONS */]]
        [[ if .go_ethereum.dev_enable ]]
        "--dev",
        "--dev.period = [[ .go_ethereum.dev_period ]] ",
        "--dev.gaslimit = [[ .go_ethereum.dev_gaslimit ]] ",
        [[ end ]]

        [[/* ETHASH OPTIONS */]]
        [[ if not (eq .go_ethereum.ethash_cachedir "") ]]
        --ethash.cachedir = [[ .go_ethereum.ethash_cachedir ]],
        [[ end ]]
        [[ if not (eq .go_ethereum.ethash_cachesinmem "") ]]
        --ethash.cachesinmem = [[ .go_ethereum.ethash_cachesinmem ]],
        [[ end ]]
        [[ if not (eq .go_ethereum.ethash_cachesondisk "") ]]
        --ethash.cachesondisk = [[ .go_ethereum.ethash_cachesondisk ]],
        [[ end ]]
        [[ if .go_ethereum.ethash_cacheslockmmap ]]
        --ethash.cacheslockmmap,
        [[ end ]]
        [[ if .go_ethereum.ethash_cacheslockmmap ]]
        --ethash.cacheslockmmap,
        [[ end ]]
        [[ if not (eq .go_ethereum.ethash_dagdir "") ]]
        --ethash.dagdir = [[ .go_ethereum.ethash_dagdir ]],
        [[ end ]]
        [[ if not (eq .go_ethereum.ethash_dagsinmem "") ]]
        --ethash.dagsinmem = [[ .go_ethereum.ethash_dagsinmem ]],
        [[ end ]]
        [[ if not (eq .go_ethereum.ethash_dagsondisk "") ]]
        --ethash.dagsondisk = [[ .go_ethereum.ethash_dagsondisk ]],
        [[ end ]]
        [[ if .go_ethereum.ethash_dagslockmmap ]]
        --ethash.dagslockmmap,
        [[ end ]]

        [[/* ACCOUNT OPTIONS */]]
        [[ if not (eq .go_ethereum.account_unlock "") ]]
        "--unlock = [[ .go_ethereum.account_unlock ]]"
        [[ end ]]
        [[ if not (eq .go_ethereum.account_password "") ]]
        "--password = [[ .go_ethereum.account_password ]]"
        [[ end ]]
        [[ if not (eq .go_ethereum.account_signer "") ]]
        "--signer = [[ .go_ethereum.account_signer ]]"
        [[ end ]]
        [[ if .go_ethereum.account_allow_insecure_unlock ]]
        "--allow-insecure-unlock"
        [[ end ]]

        [[/* API AND CONSOLE OPTIONS */]]
        [[/* IPC options */]]
        [[ if .go_ethereum.ipc_disable ]]
        "--ipcdisable"
        [[ end ]]
        [[ if not (eq .go_ethereum.ipc_path "") ]]
        "--ipcpath = [[ .go_ethereum.ipc_path ]]"
        [[ end ]]

        [[/* HTTP options */]]
        [[ if .go_ethereum.http_enable ]]
        "--http",
        "--http.addr=[[ .go_ethereum.http_addr ]]",
        "--http.port=[[ .go_ethereum.http_port ]]",
        "--http.api=[[ .go_ethereum.http_api ]]",
        "--http.rpcprefix=[[ .go_ethereum.http_rpcprefix ]]"
        "--http.corsdomain=[[ .go_ethereum.http_corsdomain ]]",
        "--http.vhosts=[[ .go_ethereum.http_vhosts ]]",
        [[ end ]]

        [[/* Websockets options */]]
        [[ if .go_ethereum.ws_enable ]]
        "--ws",
        "--ws.addr=[[ .go_ethereum.ws_addr ]]",
        "--ws.port=[[ .go_ethereum.ws_port ]]",
        "--ws.api=[[ .go_ethereum.ws_api ]]",
        "--ws.rpcprefix=[[ .go_ethereum.ws_rpcprefix ]]"
        "--ws.origins=[[ .go_ethereum.ws_origins ]]",
        [[ end ]]

        [[/* Auth RPC options */]]
        [[ if .go_ethereum.ws_enable ]]
        [[ if not (eq .go_ethereum.authrpc_jwtsecret "") ]]
        "--authrpc.jwtsecret=[[ .go_ethereum.authrpc_jwtsecret ]]",
        [[ end ]]
        "--authrpc.addr=[[ .go_ethereum.authrpc_addr ]]",
        "--authrpc.port=[[ .go_ethereum.authrpc_port ]]",
        "--authrpc.vhosts=[[ .go_ethereum.authrpc_vhosts ]]",
        [[ end ]]

        [[/* GraphQL options */]]
        [[ if .go_ethereum.graphql_enable ]][[ if .go_ethereum.http_enable ]]
        "--graphql",
        "--graphql.corsdomain=[[ .go_ethereum.graphql_corsdomain ]]",
        "--graphql.vhosts=[[ .go_ethereum.graphql_vhosts ]]",
        [[ end ]][[ end ]]

        [[/* RPC settings */]]
        [[- if not (eq .go_ethereum.rpc_gascap "") ]]
        "--rpc.gascap=[[ .go_ethereum.rpc_gascap ]]",
        [[- end ]]
        [[- if not (eq .go_ethereum.rpc_evmtimeout "") ]]
        "--rpc.evmtimeout=[[ .go_ethereum.rpc_evmtimeout ]]",
        [[- end ]]
        [[- if not (eq .go_ethereum.rpc_txfeecap "") ]]
        "--rpc.txfeecap=[[ .go_ethereum.rpc_txfeecap ]]",
        [[- end ]]
        [[ if .go_ethereum.rpc_allow_unprotected_txs ]]
        "--rpc.allow-unprotected-txs",
        [[ end ]]

        [[/* JS settings */]]
        [[- if not (eq .go_ethereum.js_path "") ]]
        "--jspath=[[ .go_ethereum.js_path ]]",
        [[- end ]]
        [[- if not (eq .go_ethereum.js_exec "") ]]
        "--exec=[[ .go_ethereum.js_exec ]]",
        [[- end ]]
        [[- if not (eq .go_ethereum.js_preload "") ]]
        "--exec=[[ .go_ethereum.js_preload ]]",
        [[- end ]]
      ]
[[- end -]]
