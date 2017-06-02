#!/bin/bash -xe

# Refresh minion's pillar data
salt -C 'I@kubernetes:pool' saltutil.refresh_pillar

# Sync all salt resources
salt -C 'I@kubernetes:pool' saltutil.sync_all

# Bootstrap all nodes
salt -C 'I@kubernetes:pool' state.sls linux,openssh,salt.minion,ntp

# Create and distribute SSL certificates for services using salt state
salt -C 'I@kubernetes:pool' state.sls salt.minion.cert

# Install docker
salt -C 'I@docker:host' state.sls docker.host
salt -C 'I@docker:host' cmd.run "docker ps"

# Install Kubernetes and Calico
salt -C 'I@kubernetes:pool' state.sls kubernetes.pool
salt -C 'I@kubernetes:pool' cmd.run "calicoctl node status"
salt -C 'I@kubernetes:pool' cmd.run "calicoctl get ippool"
