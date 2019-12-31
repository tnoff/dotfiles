#!/bin/bash


# Run backup actions
backup-tool directory backup /home/tnorth/Documents/ --overwrite --skip-files ".*/Backup Tool.*" ".*/Secrets.*"
backup-tool directory backup /home/tnorth/Music/ --overwrite
backup-tool directory backup /home/tnorth/Pictures/ --overwrite
backup-tool directory backup /home/tnorth/Videos/ --overwrite

# Copy database over to backup tool
cp /home/tnorth/.backup-tool/database.sql Documents/Backup\ Tool/$(date +%Y-%m-%d).database.sql
