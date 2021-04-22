#!/usr/bin/env bash

set -o errexit -o pipefail

s='{{control_plane_service_ip}}:443'

if ipvsadm -L -n -t "$s" >/dev/null 2>&1; then
  ipvsadm -D -t "$s"
fi

ipvsadm -A -t "$s" -s rr
{{#control_plane_nodes}}
ipvsadm -a -t "$s" -r '{{.}}:{{apiserver_port}}' -m
{{/control_plane_nodes}}
