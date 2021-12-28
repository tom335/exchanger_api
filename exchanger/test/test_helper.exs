ExUnit.start()

IO.inspect Mix.env

if Mix.env == :test do
  Mox.defmock(Exchanger.HttpMock, for: Exchanger.Api.Http)
  Application.put_env(:exchanger, :http, Exchanger.HttpMock)
end
