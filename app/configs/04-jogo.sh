#!/bin/bash

function iniciar_jogo() {
    selecionar_categorias
    categorias=$(cat categorias_selecionadas.txt)
    dialog --msgbox "Categorias selecionadas: $categorias" 6 50
    # Aqui irá a lógica de perguntas e respostas...
}