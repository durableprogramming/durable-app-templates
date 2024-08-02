#  __  __ ___ ____  _____      __     _    ____  ____  _____ 
# |  \/  |_ _/ ___|| ____|    / /    / \  / ___||  _ \|  ___|
# | |\/| || |\___ \|  _|     / /    / _ \ \___ \| | | | |_   
# | |  | || | ___) | |___   / /    / ___ \ ___) | |_| |  _|  
# |_|  |_|___|____/|_____| /_/    /_/   \_\____/|____/|_|    
#
# This secction creates a .tools-version file for use by the
# asdf or mise en place tool management software.

ruby_version = File.read('.ruby-version').chomp.gsub(/^ruby-/, '')

create_file '.tool-versions' do
  "ruby #{ruby_version}"
end
