ExUnit.start()

Mox.defmock(Exchanger.HttpMock, for: Exchanger.Api.Http)
Application.put_env(:exchanger, :http, Exchanger.HttpMock)
