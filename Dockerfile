FROM elixir:1.12-alpine

RUN apk update && \
    mix local.hex --force && \
    mix local.rebar --force

ENV APP_HOME exchanger/
RUN mkdir $APP_HOME

COPY exchanger/ $APP_HOME

WORKDIR $APP_HOME

RUN mix deps.get
RUN mix compile

RUN mkdir -p priv/data/mnesia/dev && \
    mkdir -p priv/data/mnesia/test && \
    mkdir -p priv/data/mnesia/integration && \
    mkdir -p priv/data/mnesia/prod

CMD ["sh", "setup.sh"]
