# Exchanger

This project provides an API for currency convertions, using the [ExchangeRatesAPI](https://exchangeratesapi.io/) service.

The main goal is to retrieve, on an interval of 12 hours, the currency rates and store them in our database (Mnesia),
using the latest rates published in ExchangeRatesAPI.

## Running

### Initial steps

First of all, clone the project at [Github](https://github.com/toms099/exchanger_api).

Inside the `exchanger` directory, setup a `.env` file containing your ExchangeRatesAPI access key:

```
EX_API_ACCESS_KEY=<your_api_key>
```

### Using Docker

If you just want to get the application running, the easiest way is to use Docker (and `docker-compose`).

Choose a service to start, it can be either `exchanger_dev` or `exchanger` (production).

Then build a Docker image and run it:

```
docker-compose up <service>         # this will build & run the image
```

The development environment can be accessed at [http://localhost:4003/](http://localhost:4003/).

Production has the same address, but runs on port `4007`.


## Installation

To get a complete development environment you must have Elixir installed and running.

Enter the `exchanger` directory and run the commands:

```
mix deps.get

# create the database directories
mkdir -p priv/data/mnesia/dev
mkdir -p priv/data/mnesia/test
mkdir -p priv/data/mnesia/integration
mkdir -p priv/data/mnesia/prod

# this task will create the database for all 4 environments
mix setup.db
```

Run the `export` command to create the environment variable:

```
export $(cat .env)
```

Now, to see if everything is working as expected, try to run some tests:

```
# this will run only the unit test
mix test
```

There's also some `mix` tasks aliases for integration tests:

```
mix test.integration
```

Keep in mind that integration tests will use the API Client (`Exchanger.Api.Client`), which 
performs actual requests on the ExchangeRates API, consuming your API requests quota.

You can run the application in two different ways, using `mix` or `iex`.

Particularly, I use `iex` a lot to debug things straight into the REPL.

```
iex -S mix
```

Or using `mix`:

```
mix run --no-halt
```

That's it, if the steps finish successfully, you should have your app up and running!

It's time to see the API documentation, in the [/api/doc](localhost:4003/).

