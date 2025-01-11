function kcon --description="Set the Kubernetes context"
  if count $argv > /dev/null
    set -e KUBECONFIG
    switch $argv
      case main
        talosctl config context main
        kubectl config use-context main
      case staging
        talosctl config context staging
        kubectl config use-context staging
    end
  else
    echo "kcon main | staging"
  end
end
