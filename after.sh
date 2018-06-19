#!/bin/bash

#cat /etc/kubernetes/addons/dns/kubedns-sa.yaml | sed 's/kube-dns/kube-dns-autoscaler/' | kubectl apply -f -

kubectl taint nodes --all node-role.kubernetes.io/master-

salt -C I@kubernetes:master service.stop kube-scheduler
salt -C I@kubernetes:master service.stop kube-controller-manager
salt -C I@kubernetes:master service.stop kube-addons-manager
systemctl start kube-scheduler
systemctl start kube-controller-manager
