function fetch-k8s-config --description="Fetch cluster configuration"
    op read op://Kubernetes/cluster-main/kubeconfig >/tmp/kubeconfig-main
    op read op://Kubernetes/cluster-main/talosconfig >/tmp/talosconfig-main
    op read op://Kubernetes/cluster-staging/kubeconfig >/tmp/kubeconfig-staging
    op read op://Kubernetes/cluster-staging/talosconfig >/tmp/talosconfig-staging

    mkdir -p $HOME/.kube $HOME/.talos

    KUBECONFIG="/tmp/kubeconfig-main:/tmp/kubeconfig-staging" kubectl config view --flatten >$HOME/.kube/config
    cp /tmp/talosconfig-main $HOME/.talos/config
    talosctl --talosconfig $HOME/.talos/config config merge /tmp/talosconfig-staging
    chmod og-rwx $HOME/.kube/config
    chmod og-rwx $HOME/.talos/config
    kubectl --kubeconfig=$HOME/.kube/config config use-context main
    talosctl --talosconfig $HOME/.talos/config config context main

    rm /tmp/kubeconfig-* /tmp/talosconfig-*
end
