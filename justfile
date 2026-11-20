# ollama + openwebui (compose.yml in this directory)

# start ollama and openwebui
up:
    docker compose up -d

# shut down ollama and openwebui
down:
    docker compose down

# tail the logs of a service (ollama or openwebui)
logs service="ollama":
    docker compose logs -f {{service}}

# pull an ollama model
pull model:
    docker exec -it ollama ollama pull {{model}}

# remove an ollama model
rm model:
    docker exec -it ollama ollama rm {{model}}

# list ollama models
models:
    docker exec -it ollama ollama list

# show details of a model
show model:
    docker exec -it ollama ollama show {{model}}

# run a query against an ollama model
ask query model="qwen2.5-coder:3b":
    docker exec -it ollama ollama run {{model}} "{{query}}"
