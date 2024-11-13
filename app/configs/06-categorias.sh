#!/bin/bash

function selecionar_categorias() {
    categorias_disponiveis=$(psql -h $DB_HOST -U $DB_USER -d $DB_NAME -t -c \
        "SELECT id, nome FROM categorias;" | xargs -L1)

    # Converte as categorias em uma lista para o dialog
    categorias_menu=()
    while IFS= read -r linha; do
        id=$(echo "$linha" | awk '{print $1}')
        nome=$(echo "$linha" | awk '{print $2}')
        categorias_menu+=("$id" "$nome" "off")
    done <<< "$categorias_disponiveis"

    while true; do
        dialog --checklist "Selecione pelo menos uma categoria:" 15 50 5 \
            "${categorias_menu[@]}" 2>categorias_escolhidas.txt

        categorias=$(cat categorias_escolhidas.txt | tr -d '"')

        if [[ -z "$categorias" ]]; then
            dialog --msgbox "Voce deve selecionar pelo menos uma categoria!" 6 50
        else
            break
        fi
    done

    echo "$categorias" > categorias_selecionadas.txt
}