#!/bin/bash

# Run backup actions
backup-tool directory backup --overwrite --skip-files ".*/Documents/Secrets.*" --dir-paths "${HOME}/Documents/" "${HOME}/Music/" "${HOME}/Pictures/" "${HOME}/Videos/"

# Copy database over to backup tool
cp "${HOME}/.backup-tool/database.sql" "${HOME}/Documents/Secrets/Backup Tool/$(date +%Y-%m-%d).database.sql"
