#  ____   ___ _____ _____ _   ___     __
# |  _ \ / _ \_   _| ____| \ | \ \   / /
# | | | | | | || | |  _| |  \| |\ \ / / 
# | |_| | |_| || | | |___| |\  | \ V /  
# |____/ \___/ |_| |_____|_| \_|  \_/   
#                                       
# This section creates a sample template for your .env file
# and runs the script to initialize this installation.

run "bundle add dotenv-rails"

create_file '.env.erb' do
  <<~ENV
    DB_HOST=db
    DB_NAME=app
    DB_USERNAME=app_database_user
    DB_PASSWORD=<%=SecureRandom.hex(16)%>
    SECRET_KEY_BASE=<%=SecureRandom.hex(64)%>

  ENV
end


create_file './scripts/generate_dotenv' do
  # This script will generate a new .env file based on the
  # .env.erb template.
  <<~SCRIPT
  #!/bin/env -S rails runner

  File.write(".env", ERB.new(File.read(".env.erb")).result)
  SCRIPT
end

run 'chmod 700 scripts/generate_dotenv'
run './scripts/generate_dotenv'

