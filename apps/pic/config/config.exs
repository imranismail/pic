use Mix.Config

config :pic, ecto_repos: [Pic.Repo]

import_config "#{Mix.env}.exs"
