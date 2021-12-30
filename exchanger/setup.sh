#!/bin/bash

# generates docs
mix docs

# setup database for the select ENV
MIX_ENV=$ENV mix run ./priv/repo/mnesia_migration.exs

echo "#### Howdy!!! Running exchanger in $ENV environment"
MIX_ENV=$ENV mix run --no-halt 
