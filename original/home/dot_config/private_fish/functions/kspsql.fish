function kspsql --description 'Connect to staging psql'
  eval (op signin)
  PGPASSWORD="$(op item get ijpt2jan25hzbe6eunkddnxmhi --fields password)" psql -U postgres -h postgres.test.zinn.ca
end
