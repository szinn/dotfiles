function df --wraps=df --description 'Filtered df'
  /bin/df -P -kH -T nfs,hfs,apfs,afpfs | grep -v disk1s | ggrep -E -v "/\$" | grep -vi timemachine | ggrep -E -v "Volumes/[VM|Hardware|Preboot|Update|xarts|iscPreboot]" | grep -vi arqagent
end
