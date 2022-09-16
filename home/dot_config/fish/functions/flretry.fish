function flretry --description 'Retry a flux update'
  flux suspend $argv
  flux resume $argv
end
