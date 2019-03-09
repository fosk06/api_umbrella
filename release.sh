#!/bin/sh

# set port
export PORT=4000
# get deps
mix deps.get --only prod

# compile code
MIX_ENV=prod mix compile

#build assets with webpack
mix phx.digest

# create release 
MIX_ENV=prod mix release

# run the release
# PORT=4000 _build/prod/rel/api_umbrella/bin/api_umbrella foreground