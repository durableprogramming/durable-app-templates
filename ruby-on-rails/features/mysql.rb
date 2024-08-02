
# Add the MySQL container to our docker-compose.yml file:
append_file "docker-compose.yml",  "
  db:
    image: mysql
    volumes:
      - ./tmp/db:/var/lib/mysql
    environment:
      DB_ROOT_PASSWORD: ${DB_PASSWORD}
      DB_USER: ${DB_USERNAME}
      DB_PASSWORD: ${DB_PASSWORD}
    env_file:
      - .env
"
create_file "config/database.yml", <<~DATABASE_YML
  default: &default
    adapter: mysql2
    encoding: unicode
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
    host: <%=ENV['DB_HOST']%>
    username: <%= ENV["DB_PASSWORD"] %>
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
