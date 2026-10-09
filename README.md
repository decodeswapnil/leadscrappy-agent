# LeadScrappy agent

The LeadScrappy agent runs your LeadScrappy searches from your own computer or server. You start searches in your LeadScrappy dashboard; the agent picks them up, reads public Google Maps listings, and sends the results back to your dashboard. It needs no inbound port, API key or paid proxy.

## Quick start

1. In your LeadScrappy dashboard, open **Connections → Create pairing code**.
2. Run the command the dashboard shows. It looks like this:

```bash
docker run -d --name leadscrappy-agent --restart unless-stopped --shm-size 1g \
  -e LEADSCRAPPY_URL=https://your-portal.example \
  -e LEADSCRAPPY_PAIRING_CODE=ABCD-EFGH \
  -v leadscrappy-agent:/data ghcr.io/decodeswapnil/leadscrappy-agent:latest
```

The agent pairs once and remembers its connection in the `leadscrappy-agent` volume. After that it reconnects by itself, including after restarts. Pairing codes work once and expire after 15 minutes.

The image runs on `linux/amd64` and `linux/arm64`, so it works on Intel and Apple Silicon Macs, Windows (with Docker Desktop) and Linux servers.

## Everyday use

| Task | Command |
|---|---|
| See what the agent is doing | `docker logs -f leadscrappy-agent` |
| Stop the agent | `docker stop leadscrappy-agent` |
| Start it again | `docker start leadscrappy-agent` |
| Update to the latest version | `docker pull ghcr.io/decodeswapnil/leadscrappy-agent:latest`, then remove and re-run the container (the volume keeps its pairing) |

## Pairing again

If you disconnect the agent in the dashboard, it forgets its connection and stops. Create a new pairing code and start the container with it:

```bash
docker rm -f leadscrappy-agent
docker run -d --name leadscrappy-agent --restart unless-stopped --shm-size 1g \
  -e LEADSCRAPPY_URL=https://your-portal.example \
  -e LEADSCRAPPY_PAIRING_CODE=NEW-CODE \
  -v leadscrappy-agent:/data ghcr.io/decodeswapnil/leadscrappy-agent:latest
```

## Troubleshooting

- **"This agent is not paired"**: start it with `LEADSCRAPPY_URL` and a fresh `LEADSCRAPPY_PAIRING_CODE`.
- **"This pairing code has expired"**: codes last 15 minutes and work once. Create a new one.
- **"Could not reach the portal"**: check the URL and this machine's internet connection.
- **Google asks for verification**: the agent stops and the dashboard pauses the queue. Wait a while, then resume it from **Connections**.

## Terms

This repository distributes the prebuilt LeadScrappy agent only. See [LICENSE](LICENSE). You are responsible for using collected data in line with the terms of the sources you search and with the privacy laws that apply to you.
