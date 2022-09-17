function zstat --description "Statistics on atlas zpool"
  zpool status -v atlas ; echo " " ; zpool iostat -v ; echo " " ; zfs list ; echo " " ;zfs get compressratio -o all
end

