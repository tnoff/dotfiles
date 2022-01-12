#!/bin/bash


# Run backup actions
backup-tool -w /home/tnorth/Downloads directory backup --overwrite --skip-files ".*/Documents/Secrets.*" /home/tnorth/Documents/ /home/tnorth/Music/ /home/tnorth/Pictures/ /home/tnorth/Videos/

# Copy database over to backup tool
cp /home/tnorth/.backup-tool/database.sql /home/tnorth/Documents/Secrets/Backup\ Tool/$(date +%Y-%m-%d).database.sql
