import Config
require Logger

config :aoe,
  cache_dir: Path.join([File.cwd!(), ".api-cache"]),
  input_dir: Path.join([File.cwd!(), "priv", "input"])

import_config "secret.exs"
