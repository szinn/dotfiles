function kpsql --description 'Connect to cluster psql'
  eval (op signin)
  PGPASSWORD="$(op item get ijpt2jan25hzbe6eunkddnxmhi --fields password)" psql -U postgres -h postgres.zinn.ca
end
