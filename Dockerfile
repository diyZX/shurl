FROM elixir:1.6

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y inotify-tools build-essential postgresql-client

ENV MIX_ENV prod

ADD mix.exs mix.lock /app/
ADD config /app/config

WORKDIR /app
        
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile

ADD . /app

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8888/tcp

CMD ["./run.sh"]
