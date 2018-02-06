{%- from "kubernetes/map.jinja" import common with context -%}
#!/bin/bash

export CERTFILE="$1"

# server url
server="$(awk '/server/ { print $2 }' /etc/kubernetes/kubelet.kubeconfig)"

# certificates
cert="$(base64 --wrap=0 /etc/kubernetes/ssl/${CERTFILE}.crt)"
key="$(base64 --wrap=0 /etc/kubernetes/ssl/${CERTFILE}.key)"
ca="$(base64 --wrap=0 /etc/kubernetes/ssl/ca-kubernetes.crt )"

echo "apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${ca}
    server: ${server}
  name: remote
contexts:
- context:
    cluster: remote
    user: ${CERTFILE}
  name: remote
current-context: remote
users:
- name: ${CERTFILE}
  user:
    client-certificate-data: ${cert}
    client-key-data: ${key}
kind: Config
preferences: {}"
