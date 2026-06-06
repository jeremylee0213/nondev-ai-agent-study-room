# 배포 상태

## GitHub

- Repository: `https://github.com/jeremylee0213/nondev-ai-agent-study-room`
- GitHub Pages: `https://jeremylee0213.github.io/nondev-ai-agent-study-room/`
- Pages source: `main` branch, root `/`

## NAS

- LAN URL: `http://192.168.0.7/agent/`
- Alternate LAN URL: `http://192.168.0.7/agent.html`
- NAS path: `/volume1/web/agent`
- Static container: `agent-study-static`
- Static container URL on NAS: `http://127.0.0.1:8098/`

## Custom Domain

Target domain requested: `https://agent.ai-hub-os.com`

Current status: DNS record is not created yet. `agent.ai-hub-os.com` does not resolve.

Direct public IP port 80 is closed, so a plain DNS A record to the home public IP is not enough.

Recommended connection:

`agent.ai-hub-os.com` -> Cloudflare Tunnel -> NAS `http://127.0.0.1:8098`

To complete this domain after Cloudflare auth:

1. Create or reuse a Cloudflare Tunnel for the NAS.
2. Add public hostname `agent.ai-hub-os.com`.
3. Route it to service `http://127.0.0.1:8098`.
4. Ensure the DNS record for `agent.ai-hub-os.com` is created by the Tunnel.
4. Verify with:

```bash
dig +short agent.ai-hub-os.com
curl -I -L https://agent.ai-hub-os.com
```

## Update Flow

After editing `index.html`:

```bash
git add .
git commit -m "Update lecture dashboard"
SSHPASS='NAS_PASSWORD' ./deploy.sh
```

Do not commit NAS passwords or API keys.
