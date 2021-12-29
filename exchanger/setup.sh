#!/bin/bash

# compile all application code
MIX_ENV=$ENV mix compile

# setup database for the select ENV
MIX_ENV=$ENV mix run ./priv/repo/mnesia_migration.exs

echo "#### Howdy!!! Running exchanger in $ENV environment"
MIX_ENV=$ENV mix run --no-halt 
