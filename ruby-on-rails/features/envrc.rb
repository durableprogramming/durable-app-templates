
#    _____ _   ___     ______   ____ 
#   | ____| \ | \ \   / /  _ \ / ___|
#   |  _| |  \| |\ \ / /| |_) | |    
#  _| |___| |\  | \ V / |  _ <| |___ 
# (_)_____|_| \_|  \_/  |_| \_\\____|
#                                    
# This section customizes our .envrc.

file '.envrc' do
  <<~ENVRC
    dotenv
    layout ruby
  ENVRC
end
