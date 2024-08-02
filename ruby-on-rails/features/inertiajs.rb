
# Inertia.js, Vite, Svelte Rails Template

# Add Inertia.js
run "yarn add @inertiajs/inertia @inertiajs/svelte @sveltejs/vite-plugin-svelte svelte"

# Add Vite and Svelte
run "yarn create svelte app/frontend"

gem 'vite_rails'
gem 'foreman'

run 'bundle install'
run 'bundle exec vite install'

file 'vite.config.ts', <<-CODE

import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import { svelte } from '@sveltejs/vite-plugin-svelte'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    svelte(),
  ],
})
CODE

# Update package.json

require 'json'

file_path = 'package.json'

# Read package.json file
data = File.read(file_path)

# Parse JSON data
json = JSON.parse(data)

# Add "type": "module" as a top level key
json["type"] = "module"

# Write the updated JSON data back to the file
File.open(file_path, 'w') do |f|
  f.write(JSON.pretty_generate(json))
end

puts "Added 'type': 'module' to package.json"



# update config/vite.json

file = File.read('config/vite.json')
data = JSON.parse(file)

data['all']['sourceCodeDir'] = 'app/frontend'

File.open('config/vite.json', 'w') do |f|
  f.write(JSON.pretty_generate(data))
end


file "app/frontend/entrypoints.application.js", <<-CODE

import { createInertiaApp } from '@inertiajs/svelte'

createInertiaApp({
  resolve: name => {
    const pages = import.meta.glob('../pages/**/*.svelte', { eager: true })
    return pages[`../pages/${name}.svelte`]
  },
  setup({ el, App, props }) {
    new App({ target: el, props })
  },
})
CODE


file "bin/dev", <<-CODE
#!/bin/env bash

exec foreman start -f Procfile.dev "$@"
CODE



file "Procfile.dev", <<-CODE
vite: bin/vite dev
web: bin/rails s
CODE


