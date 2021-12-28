# Exchanger
This project provides an API for currency convertions, using the [ExchangeRatesAPI](https://exchangeratesapi.io/) service.

The main goal is to retrieve, on a daily basis, the currency rates and store them in our database (Mnesia),
using the latest rates published in ExchangeRatesAPI.

## Concepts and stack

### Plug
Exchanger uses Plug/Cowboy to create and manage routes and HTTP connections. Due to its straightforward nature and simplicity, it allows us to build easily the requests interface.

### Finch
According to the project website, it's an "HTTP client with a focus on performance, built on top of Mint and NimblePool".

It provides a nice wrapper around the Mint HTTP library, facilitating our task of building a high-level API client for the exchange rates service.

### Ecto3 Mnesia adapter
Well this is weird. Why choosing Mnesia?

As a small project without hard requirements for a stronger option like Postgresql, I'd like to understand more about one the most famous (maybe intriguing?) Erlang databases.

First, it's embedded into the Erlang core. Another reasons found include:

* it allows us to store information on both, RAM or disk
* includes the ability to store data across multiple nodes
* easy to use syntax for reading and writing data
* rollback transactions

The main drawback here is, the adapter library is not mature enough and lacks a couple of important features, like migrations for example, one of the best parts of Ecto. Also, the documentation is scarce, and solving issues can be challenging.

With that said, it's not complex to replace it with the Sqlite3 adapter if needed, since we're using Ecto.

Regarding Ecto I don't have much to say, it's practically impossible to build something in Elixir without this great schema library.

It makes easy even the hardest tasks, and provides the ability to switch the database to something more robust at anytime, without having to modify the entire code base.

## Installation & API docs

The full documentation with installation instructions and API usage can be found [here]().


## Demo

A running version of the API can be seen at: [link]().
