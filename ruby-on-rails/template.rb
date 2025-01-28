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
require 'erb'
require 'bundler'

def to_bool(_)
  %w[1 true yes].include?(_.to_s.downcase)
end

#   ____ ___  _   _ _____ ___ ____ 
#  / ___/ _ \| \ | |  ___|_ _/ ___|
# | |  | | | |  \| | |_   | | |  _ 
# | |__| |_| | |\  |  _|  | | |_| |
#  \____\___/|_| \_|_|   |___\____|
                               
cli_database = self.options['database'] 

if cli_database == 'sqlite3' && ! ENV['SKIP_CHECK_SQLITE']
  puts "This template does not support sqlite3. Please specify MySQL or PostgresSQL explicitly, with --database=postgresql or --database=mysql as an option on your 'rails new' command. If you want to run the template anyway, set the environment variable SKIP_CHECK_SQLITE."

  exit
end

module DurableTemplate
	def self.script_directory
		File.expand_path(__dir__)
	end

	def self.apply_feature(feature_name)
		filename = feature_name + '.rb'
		local_paths = [ '~/.durable_template/features/' + filename, 
                    File.join(DurableTemplate.script_directory, './features/' + filename) ]
		matching_local_path = local_paths.detect { |_| File.exist?(_) }

		if matching_local_path
			system "bin/rails", "app:template", "LOCATION=#{matching_local_path}"
		else
			template_uri = 'https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/ruby-on-rails/features/' + filename
			system "bin/rails", "app:template", "LOCATION=#{template_uri}"
		end
			
	end
end

# Determine if dozzle (log viewer) should be used.
# Check environment variable 'USE_DOZZLE' if set.
# If not set, prompt the user.
use_dozzle = if ENV.has_key?('USE_DOZZLE')
 to_bool(ENV['USE_DOZZLE'])
else
  yes?("Add amir20/dozzle (log viewer)?")
end

# Determine if docker-etchosts should be used.
# Check environment variable 'USE_DOCKER_ETCHOSTS' if set.
# If not set, prompt the user.
use_docker_etchosts = if ENV.has_key?("USE_DOCKER_ETCHOSTS")
 to_bool(ENV['USE_DOCKER_ETCHOSTS'])
else
  yes?("Add costela/docker-etchosts (docker container DNS on host)?")
end

# Determine if MySQL should be used.
use_mysql =  if ENV.has_key?('USE_MYSQL')
 to_bool(ENV['USE_MYSQL'])
else
  Bundler.definition.dependencies.any? { |d| d.name == 'mysql2' }
end

# Determine if PostgreSQL should be used.
use_postgresql =  if ENV.has_key?('USE_PG')
 to_bool(ENV['USE_PG'])
else
  Bundler.definition.dependencies.any? { |d| d.name == 'pg' }
end
 
# Determine if Nix support should be used.
# Check environment variable 'USE_NIX' if set.
# If not set, prompt the user.
use_nix = if ENV.has_key?('USE_NIX')
 to_bool(ENV['USE_NIX'])
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
                                           
file 'docker-compose.yml' do

  out = ERB.new(<<~DOCKER_COMPOSE).result(binding)
    version: '3'
    services:
      web:
        build: .
        command: bundle exec rails s -p 3000 -b '0.0.0.0'
        volumes:
          - .:/rails
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

DurableTemplate.apply_feature( 'mise' )


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


run 'chmod 700 scripts/*'

DurableTemplate.apply_feature 'dotenv'

#  ____    _  _____  _    ____    _    ____  _____ 
# |  _ \  / \|_   _|/ \  | __ )  / \  / ___|| ____|
# | | | |/ _ \ | | / _ \ |  _ \ / _ \ \___ \|  _|  
# | |_| / ___ \| |/ ___ \| |_) / ___ \ ___) | |___ 
# |____/_/   \_\_/_/   \_\____/_/   \_\____/|_____|
#                                                  
# This section configures your selected database connection.

if use_postgresql

  DurableTemplate.apply_feature 'postgresql'
end

if use_mysql


  DurableTemplate.apply_feature 'mysql'
end


if use_nix
  DurableTemplate.apply_feature 'nix'

end


DurableTemplate.apply_feature 'envrc'

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
