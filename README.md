# docker-accent

Does what it sounds like - runs your [Accent](https://www.accent.reviews/) instance in Docker.

NOTE: I'm not 100% how well this works. Use at your own risk!

This image is hosted on Docker Hub: [`queer/accent:master`](https://hub.docker.com/r/queer/accent/)

## Usage

```Bash
# Start postgres
docker run -dit -v pgdata:/var/lib/postgresql/data -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=password postgresql:alpine

# Run migrations
docker run --rm -it --link postgres -e MIX_ENV=prod -e PORT=4000 \
    -e WEBAPP_PORT=4200 -e DATABASE_URL="postgres://postgres:password@postgres/accent" \
    queer/accent:master mix ecto.setup

# Run Accent!
# This binds to ports on localhost so that you can set up eg. nginx to reverse-proxy to it, to make
# using it with a "real" domain behind eg. Cloudflare easier
docker run -dit --name=accent --link postgres -p 127.0.0.1:4200:4200 -p 127.0.0.1:4000:4000 \
    -e MIX_ENV=prod -e PORT=4000 -e WEBAPP_PORT=4200 \
    -e DATABASE_URL="postgres://postgres:password@postgres/accent" \
    -e GOOGLE_API_CLIENT_ID="<your token>" -e CANONICAL_HOST="hostname, but without https:// in front" \
    -e API_HOST="https://your-api-host.example.com" -e API_WS_HOST="wss://your-api-host.example.com" \
    -e RESTRICTED_DOMAIN="Put your domain here to prevent people without an email on that domain from creating projects" \
    queer/accent:master
```
