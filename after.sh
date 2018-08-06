#!/bin/bash

kubectl delete -f /etc/kubernetes/addons/dns/
kubectl apply -f coredns.yml

kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl label nodes --all --overwrite node-role.kubernetes.io/master-

salt -C I@kubernetes:master service.stop kube-scheduler
salt -C I@kubernetes:master service.stop kube-controller-manager
salt -C I@kubernetes:master service.stop kube-addon-manager
systemctl start kube-scheduler
systemctl start kube-controller-manager
