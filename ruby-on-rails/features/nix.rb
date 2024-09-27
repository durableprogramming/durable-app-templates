
#  _   _ _____  __
# | \ | |_ _\ \/ /
# |  \| || | \  / 
# | |\  || | /  \ 
# |_| \_|___/_/\_\
#                 
# Initializes a flake.nix using the bobvanderlinden/nixpkgs-ruby
# repository.
#

def to_bool(_); %w[1 true yes].include?(_.to_s.downcase); end
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



ruby_version = File.read('.ruby-version').chomp.gsub(/^ruby-/, '')

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

