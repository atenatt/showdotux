#!/bin/bash

# Funções utilitárias podem ser adicionadas aqui, como logs ou mensagens personalizadas
function show_message() {
    dialog --msgbox "$1" 6 40
}
