#!/bin/bash

# sddm-silent-customizer - Professional AUR maintainer helper
# Copyright (c) 2026 Elppans
# Licensed under the MIT License.
# See LICENSE file for details.
# Nome do comando/script
command="$(basename "$0")"

# Diretório de log
log_dir="$HOME/.var/log"
mkdir -p "$log_dir"

# Arquivos de log
timestamp="$(date +'%Y%m%d_%H%M%S')"
log_file="${log_dir}/${command}_${timestamp}.log"
log_error="${log_dir}/${command}_${timestamp}_error.log"

# Garantir arquivos e permissão
touch "$log_file" "$log_error"
chmod 644 "$log_file" "$log_error"

# Redirecionamento de saída
exec > >(tee -a "$log_file") 2> >(tee -a "$log_error" >&2)

# Função para log com timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Verificação de permissões
if [[ ! $EUID -ne 0 ]]; then
    log "Este script precisa ser executado como $USER."
    exit 1
fi

# Mensagem inicial
log "Iniciando script: $command"
log "Log de saída: $log_file"
log "Log de erro: $log_error"

# Exemplo de uso de comandos com log
log "Executando SDDM Silent Customizer..."

# Path to the metadata.desktop file
FILE="/usr/share/sddm/themes/silent/metadata.desktop"
TMPFILE="/tmp/metadata.desktop"

# Detects system language
if [[ "$LANG" == pt* ]]; then
    MSG_COMMENTED="Linha ativa comentada."
    MSG_CHANGED="Tema alterado com sucesso!"
    MSG_ACTIVE="Linha ativa agora:"
else
    MSG_COMMENTED="Active line commented."
    MSG_CHANGED="Theme successfully changed!"
    MSG_ACTIVE="Active line now:"
fi

log "Verificando linhas ConfigFile..."
if ! cat "$FILE" | grep "^ConfigFile" | grep '^#' ; then
    sed "/default.conf/! s/^ConfigFile/#ConfigFile/" "$FILE" > "$TMPFILE"
    cat "$TMPFILE" > "$FILE"
fi

# Get all lines with "ConfigFile="
log "Puxando todas as linhas ConfigFile..."
mapfile -t configs < <(grep -n "ConfigFile=" "$FILE")

# Identifies the active line (without a # at the beginning)
log "Identificando a linha ativa..."
active_line=$(grep -n "^[[:space:]]*ConfigFile=" "$FILE" | cut -d: -f1)

# Comment out the active line (by adding a # at the actual beginning of the line).
log "Comentando a linha ativa \"$active_line\"..."
if [[ -n "$active_line" ]]; then
    log "Usando arquivo temporario e sobrescrevendo \"${active_line}\"..."
    sed "/${active_line}/ s/^/#/" "$FILE" > "$TMPFILE"
    cat "$TMPFILE" > "$FILE"
    echo "$MSG_COMMENTED"
fi

# Choose a new random line.
log "Buscando nova linha aleatória..."
random_line=$(printf "%s\n" "${configs[@]}" | shuf -n 1 | cut -d: -f1)

# Uncomment the selected line (removing the # and any spaces around it).
log "Descomentando a linha selecionada \"${random_line}\"..."
sed "${random_line}s/^[[:space:]]*#[[:space:]]*//" "$FILE" > "$TMPFILE" && cat "$TMPFILE" > "$FILE"

# Displays final result
log "Mostrando resultado final..."
echo "$MSG_CHANGED"
echo "$MSG_ACTIVE"
#grep "^[[:space:]]*ConfigFile=" "$FILE"

log "Script finalizado com sucesso."
