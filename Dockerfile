FROM elixir:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force

# Copy local files
COPY /start-accent /start-accent
RUN chmod +x /start-accent

# Install and start accent
WORKDIR /app

RUN \
  rm -rf ./* && \
  git clone https://github.com/mirego/accent.git && \
  mv accent/* ./ && \
  mv accent/.[!.]* ./ && \
  curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get update && \
  apt-get install -y gcc g++ make nodejs && \
  mix deps.get && \
  env MIX_ENV=prod mix deps.get && \
  npm --prefix webapp install

# Redirect log to stdout
RUN touch /var/log/accent.log && \
  ln -sf /dev/stdout /var/log/accent.log

CMD ["/start-accent"]

EXPOSE 4000
EXPOSE 4200
