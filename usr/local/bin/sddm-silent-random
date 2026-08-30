#!/bin/bash

# sddm-silent-customizer - Professional AUR maintainer helper
# Copyright (c) 2026 Elppans
# Licensed under the MIT License.
# See LICENSE file for details.
# Nome do comando/script

# Path to the metadata.desktop file
FILE="/usr/share/sddm/themes/silent/metadata.desktop"
TMPFILE="/tmp/metadata.desktop"

# Envia o arquivo metadata.desktop para /tmp
cat "$FILE" > "$TMPFILE"

# 1. Comenta a linha que está atualmente ativa (se houver)
# Procura por linhas que começam com ConfigFile e adiciona o #
sed -i 's/^[[:space:]]*ConfigFile/# ConfigFile/' "$TMPFILE"

# 2. Identifica os números das linhas que contêm "#ConfigFile"
mapfile -t LINES < <(grep -n "^#[[:space:]]*ConfigFile" "$TMPFILE" | cut -d: -f1)

# 3. Sorteia um índice aleatório do array de linhas
RANDOM_INDEX=$(( RANDOM % ${#LINES[@]} ))
SELECTED_LINE=${LINES[$RANDOM_INDEX]}

# 4. Descomenta a linha sorteada
# Remove o # apenas da linha específica
sed -i "${SELECTED_LINE}s/^#[[:space:]]*//" "$TMPFILE"

# Retorna o arquivo metadata.desktop para o diretorio de temas
cat "$TMPFILE" > "$FILE"

echo "Configuração atualizada! Linha ativada: $(sed -n "${SELECTED_LINE}p" "$TMPFILE")"
