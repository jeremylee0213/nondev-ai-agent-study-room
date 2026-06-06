# 배포 상태

## GitHub

- Repository: `https://github.com/jeremylee0213/nondev-ai-agent-study-room`
- GitHub Pages: `https://jeremylee0213.github.io/nondev-ai-agent-study-room/`
- Pages source: `main` branch, root `/`

## NAS

- LAN URL: `http://192.168.0.7/agent/`
- Alternate LAN URL: `http://192.168.0.7/agent.html`
- NAS path: `/volume1/web/agent`

## Custom Domain

Target domain requested: `https://agent.ai-hub-os.com`

Current status: DNS record is not created yet. `agent.ai-hub-os.com` does not resolve.

To complete this domain:

1. Create DNS record for `agent.ai-hub-os.com` in Cloudflare or the domain DNS provider.
2. Point it to the NAS public route, reverse proxy, or Cloudflare Tunnel target.
3. Configure Synology/Web Station or reverse proxy so host `agent.ai-hub-os.com` serves `/volume1/web/agent`.
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
