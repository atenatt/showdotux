#!/bin/bash

function menu_principal() {
    while true; do
        dialog --menu "Menu Principal" 15 40 4 \
            1 "Iniciar Jogo" \
            2 "Ranking" \
            3 "Sair" 2>menu_option.txt

        option=$(cat menu_option.txt)
        case $option in
            1) iniciar_jogo ;;
            2) exibir_ranking ;;
            3) sair ;;
            *) dialog --msgbox "Opção inválida." 6 30 ;;
        esac
    done
}

function sair() {
    dialog --msgbox "Obrigado por jogar, $nome!" 6 40
    clear
    exit 0
}
