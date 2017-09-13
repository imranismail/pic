use Mix.Config

config :pic, Pic.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "pic_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
