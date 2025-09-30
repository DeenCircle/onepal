FROM elixir:1.18

ARG MIX_ENV
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_HOST

ENV DB_USERNAME ${DB_USERNAME}
ENV DB_PASSWORD ${DB_PASSWORD}
ENV DB_HOST ${DB_HOST}
ENV DB_NAME ${DB_NAME}

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
