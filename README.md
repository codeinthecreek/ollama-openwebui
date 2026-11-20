# ollama-openwebui

A minimal Docker Compose setup for running [Ollama](https://ollama.com) with
[Open WebUI](https://github.com/open-webui/open-webui) on a local machine with
an NVIDIA GPU. It's tuned for GPUs with limited VRAM, and comes with a
`justfile` of shortcuts for common tasks.

## Requirements

- Docker with the Compose plugin
- An NVIDIA GPU with the
  [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
  installed
- [just](https://github.com/casey/just) (optional, for the shortcuts below)

## Quick start

```sh
docker compose up -d                          # or: just up
docker exec -it ollama ollama pull phi4-mini  # or: just pull phi4-mini
```

Then open <http://localhost:3000>, create the local admin account, and pick a
model.

- Open WebUI: <http://localhost:3000>
- Ollama API: <http://127.0.0.1:11434>

Open WebUI listens on all interfaces, so other machines on your network can
reach it at `http://<host-ip>:3000`. The Ollama API is bound to `127.0.0.1`,
so only this machine can reach it. Open WebUI talks to Ollama over the
internal Compose network.

## Low-VRAM settings

The Ollama service in `compose.yml` sets:

| Variable | Value | Purpose |
| --- | --- | --- |
| `OLLAMA_FLASH_ATTENTION` | `1` | Required for KV cache quantization to work |
| `OLLAMA_KV_CACHE_TYPE` | `q8_0` | Stores the context at 1 byte per token (vs 2 for `f16`) |
| `OLLAMA_KEEP_ALIVE` | `5m` | Unloads an idle model from VRAM after 5 minutes |

After changing `compose.yml`, restart with `docker compose down && docker compose up -d`.

## Some suggested models for a GPU with limited VRAM

Short names default to the `:latest` tag. Running `ollama pull` again later
fetches any updated version.

- `llama3.2:3b`: defaults to the instruct `q4_K_M` build
- `phi4-mini`: the 4-bit quantized build
- `qwen2.5-coder:3b`: the instruct `q4_K_M` build

## Commands

| Docker command | just shortcut |
| --- | --- |
| `docker compose up -d` | `just up` |
| `docker compose down` | `just down` |
| `docker compose logs -f <ollama\|openwebui>` | `just logs [service]` |
| `docker exec -it ollama ollama pull <model>` | `just pull <model>` |
| `docker exec -it ollama ollama rm <model>` | `just rm <model>` |
| `docker exec -it ollama ollama list` | `just models` |
| `docker exec -it ollama ollama show <model>` | `just show <model>` |
| `docker exec -it ollama ollama run <model> "<query>"` | `just ask "<query>" [model]` |

`just ask` uses `qwen2.5-coder:3b` unless you name another model.

## Data

Models and Open WebUI data (accounts, chats, settings) live in the named Docker
volumes `ollama` and `openwebui`, so they survive `docker compose down`. To
delete them as well, run `docker compose down -v`.

## License

[BSD 3-Clause](LICENSE)
