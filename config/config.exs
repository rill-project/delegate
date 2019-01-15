use Mix.Config

import_config "./environment/#{Mix.env()}.exs"

path = Path.expand("./environment/#{Mix.env()}.secret.exs", __DIR__)
if File.exists?(path), do: import_config(path)
