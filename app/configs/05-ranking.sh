#!/bin/bash

function exibir_ranking() {
    ranking=$(psql -h $DB_HOST -U $DB_USER -d $DB_NAME -t -c "SELECT nome, pontuacao FROM jogadores ORDER BY pontuacao DESC LIMIT 10;")
    dialog --msgbox "Ranking:\n$ranking" 15 50
}
