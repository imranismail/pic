use Mix.Config

config :pic, Pic.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "pic_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
