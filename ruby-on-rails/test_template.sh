#!/bin/bash

rm -rf tmp-railsapp-*
USE_NIX=1 USE_DOZZLE=1 USE_DOCKER_ETCHOSTS=1 rails new tmp-railsapp-pg -m template.rb --database=postgresql 
USE_NIX=1 USE_DOZZLE=1 USE_DOCKER_ETCHOSTS=1 rails new tmp-railsapp-mysql -m template.rb --database=mysql
