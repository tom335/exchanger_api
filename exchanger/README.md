# Exchanger

This project provides an API for currency convertions, using the [ExchangeRatesAPI](https://exchangeratesapi.io/) service.

The main goal is to retrieve, on a daily basis, the currency rates and store them in our database (Mnesia),
using the latest rates published in ExchangeRatesAPI.

## Running

If you just want to get the application running, use Docker to generate an image and run it.

In the root directory:

```
docker build .
docker run ...
```

## Installation

To get a complete development environment you must have Elixir installed and running.

First of all, clone the project at [Github](https://github.com/toms099/exchanger_api).

Enter the `exchanger` directory and run the commands:

```
mix deps.get

mkdir -p priv/data/mnesia/dev ...

mix setup.db
```

Then, setup a `.env` file containing your ExchangeRatesAPI access key:

```
export EX_API_ACCESS_KEY=<your_api_key>
```

Run the `source` command to create the environment variable:

```
source .env
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





