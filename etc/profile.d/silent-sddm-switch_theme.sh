#!/bin/bash

# silent-sddm-customizer - Professional AUR maintainer helper
# Copyright (c) 2026 Elppans
# Licensed under the MIT License.
# See LICENSE file for details.

# Path to the metadata.desktop file
FILE="/usr/share/sddm/themes/silent/metadata.desktop"

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

# Get all lines with "ConfigFile="
mapfile -t configs < <(grep -n "ConfigFile=" "$FILE")

# Identifies the active line (without a # at the beginning)
active_line=$(grep -n "^[[:space:]]*ConfigFile=" "$FILE" | cut -d: -f1)

# Comment on the active line
if [[ -n "$active_line" ]]; then
    content=$(sed "${active_line}s/^/  #/" "$FILE")
    echo "$content" > "$FILE"
    echo "$MSG_COMMENTED"
fi

# Randomly select another line
random_line=$(printf "%s\n" "${configs[@]}" | shuf -n 1 | cut -d: -f1)

# Uncomment on the chosen line
content=$(sed "${random_line}s/^#//" "$FILE")
echo "$content" > "$FILE"

# Displays final result
echo "$MSG_CHANGED"
echo "$MSG_ACTIVE"
grep "^[[:space:]]*ConfigFile=" "$FILE"

