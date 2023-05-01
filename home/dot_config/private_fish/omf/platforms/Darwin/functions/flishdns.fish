function flishdns --description 'Flush DNS cache'
  sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
end
