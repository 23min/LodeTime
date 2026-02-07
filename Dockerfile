FROM elixir:1.16-alpine

WORKDIR /app

# Install build tools for dependencies
RUN apk add --no-cache build-base git

# Copy mix files and deps to leverage docker layer caching
COPY mix.exs mix.lock ./
COPY config ./config

RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get

# Copy source
COPY lib ./lib
COPY cmd ./cmd
COPY .lodetime ./.lodetime

# Compile
RUN mix compile

# Default command
CMD ["mix", "run", "--no-halt"]
