#!/bin/bash

function iniciar_jogo() {
    # Seleciona as categorias e armazena os nomes em uma variável
    local categorias
    categorias=$(selecionar_categorias)

    # Confirma as categorias selecionadas ao jogador
    dialog --msgbox "Categorias selecionadas: $categorias" 6 50

    # Formata as categorias para serem usadas na query SQL
    local categorias_formatadas
    categorias_formatadas=$(echo "$categorias" | sed "s/ /','/g" | sed "s/^/'/;s/$/'/")

    # Obtem perguntas aleatórias filtradas pelas categorias selecionadas
    local perguntas
    perguntas=$(psql -h $DB_HOST -U $DB_USER -d $DB_NAME -t -c \
        "SELECT enunciado, opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta 
         FROM perguntas 
         WHERE categoria IN ($categorias_formatadas) 
         ORDER BY random() 
         LIMIT 10;")

    # Verifica se as perguntas foram obtidas
    if [[ -z "$perguntas" ]]; then
        dialog --msgbox "Nenhuma pergunta encontrada para as categorias selecionadas." 6 50
        return
    fi

    local pontuacao=0
    local pulos_restantes=3

    # Loop de perguntas
    while IFS='|' read -r enunciado opcao_a opcao_b opcao_c opcao_d resposta_correta; do
        if [[ -z "$enunciado" || -z "$opcao_a" || -z "$opcao_b" || -z "$opcao_c" || -z "$opcao_d" || -z "$resposta_correta" ]]; then
            dialog --msgbox "Erro ao carregar pergunta. Verifique o banco de dados." 6 50
            return
        fi

        resposta=$(dialog --menu "$enunciado" 15 50 6 \
            A "$opcao_a" \
            B "$opcao_b" \
            C "$opcao_c" \
            D "$opcao_d" \
            P "Pular (Restantes: $pulos_restantes)" 3>&1 1>&2 2>&3)

        if [[ $resposta == "P" && $pulos_restantes -gt 0 ]]; then
            ((pulos_restantes--))
            continue
        elif [[ $resposta == "$resposta_correta" ]]; then
            ((pontuacao+=10))
            dialog --msgbox "Correto! Pontuação atual: $pontuacao" 6 50
        else
            dialog --msgbox "Errado! A resposta correta era $resposta_correta" 6 50
        fi
    done <<< "$perguntas"

    dialog --msgbox "Jogo finalizado! Sua pontuação: $pontuacao" 6 50
    salvar_pontuacao $pontuacao
}

function salvar_pontuacao() {
    local pontuacao=$1
    psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c \
        "UPDATE jogadores SET pontuacao = GREATEST(pontuacao, $pontuacao) WHERE nome = '$USER_NAME';"
}
