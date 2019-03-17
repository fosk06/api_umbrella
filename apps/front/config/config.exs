# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :front, FrontWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "39JhLBNarnvR2uag+KhIV3W60mc9n72yssNGN3vynGQMu8thG74+VULr3DFZM1l/",
  render_errors: [view: FrontWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Front.PubSub, adapter: Phoenix.PubSub.PG2]

# configures Guardian
config :front, FrontWeb.Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "FrontWeb",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  # generated using: JOSE.JWK.generate_key({:oct, 16}) |> JOSE.JWK.to_map |> elem(1)
  secret_key: %{"k" => "vgEC-aQr3Zr7ksVO4BShiQ", "kty" => "oct"},
  serializer: FrontWeb.Guardian

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"