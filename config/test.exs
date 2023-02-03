import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :book_club, BookClub.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "book_club_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :book_club, BookClubWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "9no0aXriqOejgVD5aId+psV2e6gMyycYyVwjnZTOV/+8eabIq6vB8NxxqGtJlIjR",
  server: false

# In test we don't send emails.
config :book_club, BookClub.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime