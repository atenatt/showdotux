#!/bin/bash

function selecionar_categorias() {
    local categorias_disponiveis
    categorias_disponiveis=$(psql -h $DB_HOST -U $DB_USER -d $DB_NAME -t -c \
        "SELECT nome FROM categorias;" | xargs -L1)

    local categorias_menu=()
    while IFS= read -r categoria; do
        categorias_menu+=("$categoria" "$categoria" "off")
    done <<< "$categorias_disponiveis"

    while true; do
        local selecionadas
        selecionadas=$(dialog --checklist "Selecione pelo menos uma categoria:" 15 50 5 \
            "${categorias_menu[@]}" 3>&1 1>&2 2>&3)

        if [[ -z "$selecionadas" ]]; then
            dialog --msgbox "Você deve selecionar pelo menos uma categoria!" 6 50
        else
            echo "$selecionadas" | tr -d '"'
            break
        fi
    done
}
