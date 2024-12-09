#!/bin/bash

# podman  run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

# export ALL_MODELS="granite3-moe:3b granite3-dense:8b llama3.1:8b llama3.2:1b granite-code:8b codellama"
export ALL_MODELS="codellama"

TS=`date +%s`

scp -r input root@10.8.231.211:/root/workflows/input-${TS}

ssh root@10.8.231.211 "cd /root/workflows/input-${TS} ; \
  export OLLAMA_HOST=127.0.0.1:11435 ; \
  echo Models to try: ${ALL_MODELS} ; \
  for MODEL in ${ALL_MODELS} ; do \
    echo Using \"\${MODEL}\" - \"output-\"\${MODEL}\"\" | tee -a stats.txt ; \
    cat \`ls|sort\` | \
      podman exec -i ollama ollama run \"\${MODEL}\" --verbose 2>> stats.txt | tee -a \"output-\"\${MODEL}\"\" ; \
      echo >> stats.txt ; \
  done ; \
"

scp -r root@10.8.231.211:/root/workflows/input-${TS} ./
