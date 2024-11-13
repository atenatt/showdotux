#!/bin/bash

for file in configs/*.sh; do
    source "$file"
done

# Ponto de entrada do jogo
login