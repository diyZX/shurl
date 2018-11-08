#!/bin/sh

set -e

mix compile
mix ecto.create
mix ecto.migrate
elixir --name shurl@127.0.0.1 --cookie shurl -S mix run --no-halt
