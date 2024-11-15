#!/bin/bash

yaml_file="/docker-entrypoint-initdb.d/perguntas.yaml"
sql_file="/docker-entrypoint-initdb.d/03-import_questions.sql"

# Inicializa o arquivo SQL
echo "BEGIN TRANSACTION;" > $sql_file

while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^- ]]; then
        if [[ -n "$categoria" && -n "$enunciado" ]]; then
            categoria=$(echo "$categoria" | tr -d '\r' | sed "s/'/''/g")
            resposta_correta=$(echo "$resposta_correta" | tr -d '\r' | xargs | cut -c1)
            enunciado=$(echo "$enunciado" | tr -d '\r' | sed "s/'/''/g")
            opcao_a=$(echo "$opcao_a" | tr -d '\r' | sed "s/'/''/g")
            opcao_b=$(echo "$opcao_b" | tr -d '\r' | sed "s/'/''/g")
            opcao_c=$(echo "$opcao_c" | tr -d '\r' | sed "s/'/''/g")
            opcao_d=$(echo "$opcao_d" | tr -d '\r' | sed "s/'/''/g")

            echo "INSERT INTO perguntas (categoria, enunciado, opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta) VALUES ('$categoria', '$enunciado', '$opcao_a', '$opcao_b', '$opcao_c', '$opcao_d', '$resposta_correta');" >> $sql_file
        fi
        unset categoria enunciado opcao_a opcao_b opcao_c opcao_d resposta_correta
    fi
    [[ "$line" =~ categoria:\ (.+) ]] && categoria="${BASH_REMATCH[1]}"
    [[ "$line" =~ enunciado:\ (.+) ]] && enunciado="${BASH_REMATCH[1]}"
    [[ "$line" =~ opcao_a:\ (.+) ]] && opcao_a="${BASH_REMATCH[1]}"
    [[ "$line" =~ opcao_b:\ (.+) ]] && opcao_b="${BASH_REMATCH[1]}"
    [[ "$line" =~ opcao_c:\ (.+) ]] && opcao_c="${BASH_REMATCH[1]}"
    [[ "$line" =~ opcao_d:\ (.+) ]] && opcao_d="${BASH_REMATCH[1]}"
    [[ "$line" =~ resposta_correta:\ (.+) ]] && resposta_correta="${BASH_REMATCH[1]}"
done < "$yaml_file"

if [[ -n "$categoria" && -n "$enunciado" ]]; then
    categoria=$(echo "$categoria" | tr -d '\r' | sed "s/'/''/g")
    resposta_correta=$(echo "$resposta_correta" | tr -d '\r' | xargs | cut -c1)
    enunciado=$(echo "$enunciado" | tr -d '\r' | sed "s/'/''/g")
    opcao_a=$(echo "$opcao_a" | tr -d '\r' | sed "s/'/''/g")
    opcao_b=$(echo "$opcao_b" | tr -d '\r' | sed "s/'/''/g")
    opcao_c=$(echo "$opcao_c" | tr -d '\r' | sed "s/'/''/g")
    opcao_d=$(echo "$opcao_d" | tr -d '\r' | sed "s/'/''/g")

    echo "INSERT INTO perguntas (categoria, enunciado, opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta) VALUES ('$categoria', '$enunciado', '$opcao_a', '$opcao_b', '$opcao_c', '$opcao_d', '$resposta_correta');" >> $sql_file
fi

echo "COMMIT;" >> $sql_file