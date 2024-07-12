# Durable Programming App Templates
# Ruby on Rails.
#
# Usage
# -----
#
# For PostgreSQL:
#
# rails new bob --database=postgresql -m https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/ruby-on-rails/template.rb
# 
# For MySQL: 
# rails new bob --database=mysql -m https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/ruby-on-rails/template.rb
require 'active_record'
require 'erb'
#   ____ ___  _   _ _____ ___ ____ 
#  / ___/ _ \| \ | |  ___|_ _/ ___|
# | |  | | | |  \| | |_   | | |  _ 
# | |__| |_| | |\  |  _|  | | |_| |
#  \____\___/|_| \_|_|   |___\____|
                               
cli_database = self.options['database'] 

if cli_database == 'sqlite3' && ! ENV['SKIP_CHECK_SQLITE']
  puts "This template does not support sqlite3. Please specify MySQL or PostgresSQL explicitly,
    with --database=postgresql or --database=mysql as an option on your 'rails new' command. If you want to run the template anyway, set the environment variable SKIP_CHECK_SQLITE."

  exit
end

# Determine if dozzle (log viewer) should be used.
# Check environment variable 'USE_DOZZLE' if set.
# If not set, prompt the user.
use_dozzle = if ENV.has_key?('USE_DOZZLE')
  ActiveRecord::Type::Boolean.new.cast(ENV['USE_DOZZLE'])
else
  yes?("Add amir20/dozzle (log viewer)?")
end

# Determine if docker-etchosts should be used.
# Check environment variable 'USE_DOCKER_ETCHOSTS' if set.
# If not set, prompt the user.
use_docker_etchosts = if ENV.has_key?("USE_DOCKER_ETCHOSTS")
  ActiveRecord::Type::Boolean.new.cast(ENV['USE_DOCKER_ETCHOSTS'])
else
  yes?("Add costela/docker-etchosts (log viewer)?")
end

# Determine if MySQL should be used.
use_mysql = if ENV.has_key?('USE_MYSQL')
  ActiveRecord::Type::Boolean.new.cast(ENV['USE_MYSQL'])
else
  cli_database == 'mysql'
end

# Determine if PostgreSQL should be used.
use_postgresql = if ENV.has_key?('USE_PG')
  ActiveRecord::Type::Boolean.new.cast(ENV['USE_PG'])
else
  cli_database == 'postgresql'
end
 
# Determine if Nix support should be used.
# Check environment variable 'USE_NIX' if set.
# If not set, prompt the user.
use_nix = if ENV.has_key?('USE_NIX')
  ActiveRecord::Type::Boolean.new.cast(ENV['USE_NIX'])
else
  yes?("Use bobvanderlinden/nixpkgs-ruby for Nix flake?")
end

# Get the Ruby version from .ruby-version file
# Remove the leading "ruby-" if present
ruby_version = File.read('.ruby-version').chomp.gsub(/^ruby-/, '')

#   ____ _____ __  __ _____ ___ _     _____ 
#  / ___| ____|  \/  |  ___|_ _| |   | ____|
# | |  _|  _| | |\/| | |_   | || |   |  _|  
# | |_| | |___| |  | |  _|  | || |___| |___ 
#  \____|_____|_|  |_|_|   |___|_____|_____|
                                           
# Add debugger
run "bundle add pry"
# Add environment variable management
run "bundle add dotenv-rails"


#  ____   ___   ____ _  _______ ____  
# |  _ \ / _ \ / ___| |/ / ____|  _ \ 
# | | | | | | | |   | ' /|  _| | |_) |
# | |_| | |_| | |___| . \| |___|  _ < 
# |____/ \___/ \____|_|\_\_____|_| \_\
#                                     
#   ____ ___  __  __ ____   ___  ____  _____ 
#  / ___/ _ \|  \/  |  _ \ / _ \/ ___|| ____|
# | |  | | | | |\/| | |_) | | | \___ \|  _|  
# | |__| |_| | |  | |  __/| |_| |___) | |___ 
#  \____\___/|_|  |_|_|    \___/|____/|_____|
                                           
create_file 'docker-compose.yml' do

  out = ERB.new(<<~DOCKER_COMPOSE).result(binding)
    version: '3'
    services:
      web:
        build: .
        command: bundle exec rails s -p 3000 -b '0.0.0.0'
        volumes:
          - .:/app
        ports:
          - "127.0.0.1:3000:3000"
        depends_on:
          - db
        env_file:
          - .env

    <% if use_dozzle %>
      dozzle: 
        image: amir20/dozzle:latest
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock:ro
        ports:
          - "127.0.0.1:8080:8080"
    <% end %>

    <% if use_docker_etchosts %>
      docker-etchosts:
        image: costela/docker-etchosts
        restart: always
        network_mode: none
        volumes:
          - /etc/hosts:/etc/hosts
          - /var/run/docker.sock:/var/run/docker.sock
    <% end %>
  DOCKER_COMPOSE

  out
end

#  __  __ ___ ____  _____      __     _    ____  ____  _____ 
# |  \/  |_ _/ ___|| ____|    / /    / \  / ___||  _ \|  ___|
# | |\/| || |\___ \|  _|     / /    / _ \ \___ \| | | | |_   
# | |  | || | ___) | |___   / /    / ___ \ ___) | |_| |  _|  
# |_|  |_|___|____/|_____| /_/    /_/   \_\____/|____/|_|    
#
# This secction creates a .tools-version file for use by the
# asdf or mise en place tool management software.

create_file '.tool-versions' do
  "ruby #{ruby_version}"
end

#  ____   ____ ____  ___ ____ _____ ____  
# / ___| / ___|  _ \|_ _|  _ \_   _/ ___| 
# \___ \| |   | |_) || || |_) || | \___ \ 
#  ___) | |___|  _ < | ||  __/ | |  ___) |
# |____/ \____|_| \_\___|_|    |_| |____/ 
#
# This section creates a scripts/ directory with several
# helpful scripts.
                                        
run 'mkdir -p scripts'

create_file 'scripts/docker_shell' do
  # This script will drop you into a bash shell inside 
  # an instance of your docker container.
  <<~BASH
    #!/bin/bash

    cd "$(dirname "$0")"
    cd ..

    docker compose run web /bin/bash

  BASH
end

create_file './scripts/generate_dotenv' do
  # This script will generate a new .env file based on the
  # .env.erb template.
  <<~SCRIPT
  #!/bin/env -S rails runner

  File.write(".env", ERB.new(File.read(".env.erb")).result)
  SCRIPT
end

run 'chmod 700 scripts/*'

#  ____   ___ _____ _____ _   ___     __
# |  _ \ / _ \_   _| ____| \ | \ \   / /
# | | | | | | || | |  _| |  \| |\ \ / / 
# | |_| | |_| || | | |___| |\  | \ V /  
# |____/ \___/ |_| |_____|_| \_|  \_/   
#                                       
# This section creates a sample template for your .env file
# and runs the script to initialize this installation.

create_file '.env.erb' do
  <<~ENV
    DB_USERNAME=app_database_user
    DB_PASSWORD=<%=SecureRandom.hex(16)%>
  ENV
end

run './scripts/generate_dotenv'


#  ____    _  _____  _    ____    _    ____  _____ 
# |  _ \  / \|_   _|/ \  | __ )  / \  / ___|| ____|
# | | | |/ _ \ | | / _ \ |  _ \ / _ \ \___ \|  _|  
# | |_| / ___ \| |/ ___ \| |_) / ___ \ ___) | |___ 
# |____/_/   \_\_/_/   \_\____/_/   \_\____/|_____|
#                                                  
# This section configures your selected database connection.

if use_postgresql

  # Add the pg container to our docker-compose.yml file:
  #
  append_file "docker-compose.yml",  "
  db:
    image: postgres
    volumes:
      - ./tmp/db:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: ${DB_USERNAME}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    env_file:
      - .env
  "
end

if use_mysql


  # Add the MySQL container to our docker-compose.yml file:
  append_file "docker-compose.yml",  "
  db:
    image: mysql
    volumes:
      - ./tmp/db:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
      MYSQL_USER: ${DB_USERNAME}
      MYSQL_PASSWORD: ${DB_PASSWORD}
    env_file:
      - .env
"
end

#  _   _ _____  __
# | \ | |_ _\ \/ /
# |  \| || | \  / 
# | |\  || | /  \ 
# |_| \_|___/_/\_\
#                 
# If selected, this section initializes a flake.nix using the bobvanderlinden/nixpkgs-ruby
# repository.

if use_nix

  run "nix flake init --template github:bobvanderlinden/nixpkgs-ruby#"

  # Add some build dependencies to the generated nix flake:
  
  inject_into_file 'flake.nix', after: 'buildInputs = [' do '
              libxml2
              libxslt
              libyaml
              zlib' + (
                use_postgresql ? 
                "\n
              postgresql\n"  : ""
              ) + (
                use_mysql ? 
                "\n
              mysql\n
              libmysqlclient\n"  : "")
  end

  # For technical reasons, our nix setup won't work properly if 
  # .ruby-version isn't at least a tracked file.
  
  run 'git add .ruby-version'


end

#    _____ _   ___     ______   ____ 
#   | ____| \ | \ \   / /  _ \ / ___|
#   |  _| |  \| |\ \ / /| |_) | |    
#  _| |___| |\  | \ V / |  _ <| |___ 
# (_)_____|_| \_|  \_/  |_| \_\\____|
#                                    
# This section customizes our .envrc.

append_file '.envrc' do
  <<~ENVRC
    dotenv
    layout ruby
  ENVRC
end


#                        .::::           lkkkkkkkkkd  lkkko  dkkk: 'kkkkkkkkkd.    .kkkkx    .kkkkkkkkkx.  kkkk.     xkkkkkkkx
#                   ...  llll;           dKKKKKKKKKK' dKKKx  OKKKl ,KKKKKKKKKKx    lKKKKK.   .KKKKKKKKKKx  KKKK.     OKKKKKKKK.
#            ..  ..llllc,llll.           dKKKc  OKKK' dKKKx  OKKKl ,KKKk  :KKKx    KKKKKKl   .KKKK  'KKKx  KKKK.     OKKKc
#           cllllllllllllllll            dKKKc  OKKK' dKKKx  OKKKl ,KKKk  :KKKx   .KKKKKKK   .KKKK  'KKKx  KKKK.     OKKKc
#          ,lllllll,    clll; KO0O'      dKKKc  OKKK' dKKKx  OKKKl ,KKKk  :KKKx   dKKKcKKK.  .KKKK;.kKKKl  KKKK.     OKKKO'''
#       ',cllll' .cloo.      'KKKKc      dKKKc  OKKK' dKKKx  OKKKl ,KKKK:'0KKKx   KKKk KKKk  .KKKKKKKKKKl  KKKK.     OKKKKKKK.
#      llllll;   cKKKK       .KKKK0      dKKKc  OKKK' dKKKx  OKKKl ,KKKKKKKKKKc  ,KKKc OKKK  .KKKK  'KKK0  KKKK.     OKKKl
#       llll;    KKKKd        .KKKKk:    dKKKc  OKKK' dKKKx  OKKKl ,KKKk.KKKK    0KKKk'KKKK; .KKKK  .KKK0  KKKK.     OKKKc
#      .llll    .KKKK.         oKKKKKl   dKKKk .KKKK' dKKKK..KKKKl ,KKKk lKKKx  .KKKKKKKKKK0 .KKKK. lKKK0  KKKKx.... OKKKO....
#     :lllll    oKKKK          oKKKK     dKKKKKKKKKK. :KKKKKKKKKK, ,KKKk  0KKK' lKKKo   KKKK..KKKKKKKKKKx  KKKKKKKK. OKKKKKKKk
#     llllll'   KKKKo          KKKKd
#       'llll. .KKKK.         OKKKKK'
#        lllll oKKK0        ;0KKKKK0     ;llllll clllllc :lllllc :llllc  llllll;  .lll   lll  :ll..ll:  lll cl: lll ll' lllll.
#       .llll, KKKKd    .,o0KKKKc        ;lc .ll cl: 'll :l: ,ll :l:     ll' :l:  ;lll.  lll..lll..lll ;lll cl: lll,ll'.ll.
#             'KKKKKK00KKKKKKKKd         ;lc .ll cl: 'll :l: ,ll :l:     ll' :l:  ll;l;  llllclll..llllllll cl: llllll'.ll.
#             kKKKKKKKKKKK: 0K.          ;ll.cll cll,cll :l: ,ll :l: ;lc llc,ll: .lc.ll  ll:ll;ll..ll;ll;ll cl: llllll'.ll. ll.
#             KKKK: cKKk                 ;lc     cl:,ll  :l: ,ll :l: ;lc ll,:lc  cll;ll. ll.;c ll..ll l''ll cl: ll'lll'.ll. ll.
#            :KKKK                       ;lc     cl: ll' :ll'lll :ll;llc ll' ll. ll. :l: ll. . ll..ll . .ll cl: ll.'ll' ll:;ll.
#
#                                        https://durableprogramming.com
#
#
# This work is marked with CC0 1.0. 
# To view a copy of this license, visit the following URL:
#     https://creativecommons.org/publicdomain/zero/1.0/
