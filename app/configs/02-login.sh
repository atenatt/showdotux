#!/bin/bash

# Função de login
function login() {
    while true; do
        nome=$(dialog --inputbox "Digite seu nome:" 8 40 3>&1 1>&2 2>&3 3>&-)
        
        # Cancelar operação
        if [ $? -ne 0 ]; then
            dialog --msgbox "Operação cancelada." 6 30
            return
        fi

        # Verificação do input
        if [[ -z "$nome" || ! "$nome" =~ ^[a-zA-Z0-9_-]{3,}$ ]]; then
            dialog --msgbox "Nome invalido! Utilize 3 caracteres, sem espacos ou caracteres especiais." 8 50
        else
            break
        fi
    done

    # Inserir ou verificar nome no banco
    psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c \
    "INSERT INTO jogadores (nome) VALUES ('$nome') ON CONFLICT (nome) DO NOTHING;" > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        dialog --msgbox "Erro ao acessar o banco de dados. Verifique suas credenciais e tente novamente." 8 50
        return
    fi

    jogador_existente=$(psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -t -c \
    "SELECT nome FROM jogadores WHERE nome='$nome';" | xargs)

    menu_principal
}
