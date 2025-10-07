FROM elixir:1.18

COPY . .
WORKDIR /app

# Install dependcies and add elixir as a user
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates build-essential curl inotify-tools \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean

# Install Phoenix packages
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new 1.5.1

RUN mix deps.clean --all
RUN mix deps.get
RUN mix assets.setup
RUN mix deps.compile

CMD ["mix", "phx.server"]
