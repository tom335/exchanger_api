alias Exchanger.Conversions.Service
import Mox

Mox.defmock(Exchanger.HttpMock, for: Exchanger.Api.Http)
Application.put_env(:exchanger, :http, Exchanger.HttpMock)

Exchanger.HttpMock
|> expect(:get, fn _ -> nil end)

ExUnit.start()

# save some rates and conversions for use on tests
Service.save_rates(%{
  BRL: 6.43,
  USD: 1.13,
  GPB: 0.84
})

# user 1 conversions
Enum.each(1..10, fn _n ->
  {:ok, _conv} =
    Service.create_conversion(%{
      user_id: 1,
      from: "USD",
      to: "BRL",
      amount: 152.32
    })
end)

# user 2 conversions
Enum.each(1..5, fn _n ->
  {:ok, _conv} =
    Service.create_conversion(%{
      user_id: 2,
      from: "GPB",
      to: "USD",
      amount: 991.32
    })
end)
