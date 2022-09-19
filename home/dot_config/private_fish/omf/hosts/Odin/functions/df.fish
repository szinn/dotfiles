function df --wraps=df --description 'Filtered df'
  /bin/df -P -kH -T nfs,hfs,apfs,afpfs | grep -v disk1s | egrep -v "/\$" | grep -vi timemachine | egrep -v "Volumes/[VM|Preboot|Update|xarts|iscPreboot]" | grep -vi arqagent
end