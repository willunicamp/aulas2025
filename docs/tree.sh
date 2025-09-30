#!/bin/bash

# Função recursiva que lista o conteúdo de um diretório
# Argumento 1: O diretório a ser listado
# Argumento 2: O prefixo para a linha atual (usado para desenhar a árvore)
listar_diretorio() {
    local diretorio="$1"
    local prefixo="$2"
    
    # Pega todos os itens (arquivos e diretórios), exceto os ocultos,
    # e os coloca em um array. Usar 'find' é mais seguro para nomes com espaços.
    local itens=($(find "$diretorio" -maxdepth 1 -mindepth 1 -not -path '*/.*' | sort))
    local total_itens=${#itens[@]}
    local contador=0

    # Itera sobre cada item encontrado
    for item_path in "${itens[@]}"; do
        ((contador++))
        
        # Pega apenas o nome base do caminho completo
        local nome_item=$(basename "$item_path")

        # Define os conectores da árvore: '├──' para itens no meio, '└──' para o último
        if [ "$contador" -eq "$total_itens" ]; then
            local conector="└──"
            local prefixo_recursao="    " # Para o último item, o prefixo do próximo nível não tem a linha vertical
        else
            local conector="├──"
            local prefixo_recursao="│   " # Para itens no meio, mantém a linha vertical
        fi
        
        # Imprime a linha atual com o prefixo e o nome do item
        echo "${prefixo}${conector} ${nome_item}"

        # Se o item for um diretório, chama a função novamente para ele (recursão)
        if [ -d "$item_path" ]; then
            listar_diretorio "$item_path" "${prefixo}${prefixo_recursao}"
        fi
    done
}

# --- Ponto de Entrada do Script ---

# Define o diretório alvo. Se um argumento for passado, use-o.
# Caso contrário, use o diretório atual ('.').
DIRETORIO_ALVO="${1:-.}"

# Verifica se o diretório alvo existe
if [ ! -d "$DIRETORIO_ALVO" ]; then
    echo "Erro: O diretório '$DIRETORIO_ALVO' não foi encontrado."
    exit 1
fi

# Imprime o nome do diretório raiz e inicia a listagem
echo "$DIRETORIO_ALVO"
listar_diretorio "$DIRETORIO_ALVO" ""