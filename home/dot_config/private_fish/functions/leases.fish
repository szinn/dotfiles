function leases --description "Show VyOS DHCP leases"
  ssh gateway -- /opt/vyatta/bin/vyatta-op-cmd-wrapper show dhcp server leases
end
