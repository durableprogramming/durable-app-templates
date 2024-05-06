# Durable Programming Ruby on Rails App Template

This Ruby on Rails app template, created by Durable Programming, provides a solid foundation for building web applications. It incorporates a range of features and best practices to jumpstart your Rails development.

## Features

1. **Database Support**: The template supports both PostgreSQL and MySQL databases. You can specify your preferred database when creating a new Rails project using the `--database` flag.

2. **Docker Integration**: The template includes a `docker-compose.yml` file that sets up the necessary services for running your Rails application in a containerized environment. It defines services for the web application, database, and optional tools like Dozzle (log viewer) and docker-etchosts.

3. **.env File Generation**: The template includes a script (`generate_dotenv`) that generates a `.env` file based on a template (`.env.erb`). This allows you to easily manage environment-specific configurations for your application. The .env file will be integrated with your shell (if direnv is installed) and with docker-compose. 

4. **Debugging and Environment Management**: The template includes the `pry` gem for debugging and the `dotenv-rails` gem for managing environment variables.

5. **asdf and mise**: The template creates a `.tool-versions` file that specifies the Ruby version for use with the asdf or mise tool management software.

6. **Helpful Scripts**: The template provides a `scripts/` directory with useful scripts, such as `docker_shell` for launching a bash shell inside a Docker container and `generate_dotenv` for generating the `.env` file.

7. **Database Configuration**: Depending on your choice of database (PostgreSQL or MySQL), the template configures the appropriate Docker service and sets up the necessary environment variables for database connectivity.

8. **Nix Flake Support**: If the `USE_NIX` environment variable is set or the user confirms the use of Nix, the template initializes a `flake.nix` file using the `bobvanderlinden/nixpkgs-ruby` repository. It also adds build dependencies specific to your chosen database. You can then use nix-direnv to automatically load the relevant paths, or else explicitly launch a shell using `nix develop`.

9. **.envrc Customization**: The template customizes the `.envrc` file to load environment variables from the `.env` file and set up the Ruby environment using the specified version.

## Usage

To create a new Rails project using this template, run the following command:

```bash
rails new your_app_name --database=postgresql -m https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/ruby-on-rails/template.rb
```

Replace `your_app_name` with the desired name for your Rails application. You can choose between `postgresql` and `mysql` for the `--database` flag.

The template will prompt you for additional options, such as using Dozzle, docker-etchosts, and Nix flake support. You can also set the corresponding environment variables (`USE_DOZZLE`, `USE_DOCKER_ETCHOSTS`, `USE_NIX`) to automatically answer these prompts.

## Requirements

Docker support requires Docker installed, although Docker should not be required to use this template.

mise or asdf required to use mise or asdf; if neither are installed, you can still use nix-shell or docker. Additionally, nothing prevents you from using rbenv or rvm either - this template is designed to provide maximum flexibility to developers.

envrc support requires direnv.

## License

This template is marked with CC0 1.0. To view a copy of this license, visit the following URL:
https://creativecommons.org/publicdomain/zero/1.0/

## About Durable Programming

For more information about Durable Programming and their work, visit their website:
https://durableprogramming.com

