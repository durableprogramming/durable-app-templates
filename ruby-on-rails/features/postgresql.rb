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

create_file "config/database.yml", <<~DATABASE_YML
  default: &default
    adapter: postgresql
    encoding: unicode
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
    host: <%=ENV['DB_HOST']%>
    username: <%= ENV["DB_USERNAME"] %>
    password: <%= ENV["DB_PASSWORD"] %>

  development:
    <<: *default
    database: <%=ENV['DB_NAME']%>

  test:
    <<: *default
    database: <%=ENV['DB_NAME_TEST']%>

  production:
    <<: *default
    database: <%=ENV['DB_NAME']%>
DATABASE_YML
