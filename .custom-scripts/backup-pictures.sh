#!/bin/bash

picture_dir="$HOME/Pictures"
backup_picture_dir="$HOME/Pictures-Backups"

rm -rf ${backup_picture_dir}

echo "Making backup dirs $backup_picture_dir"
find "${picture_dir}" -type d -print0 | while IFS='' read -r -d '' directory;
do
    backup_dir=${directory#$picture_dir}
    backup_dir_full=${backup_picture_dir}${backup_dir}
    echo "Making dir ${backup_dir_full}"
    mkdir -p $backup_dir_full
done

echo "Starting picture stuff $picture_dir"
find $picture_dir -type f -name "*.jpg" -print0 | while IFS='' read -r -d '' picture;
do
    relative=$backup_picture_dir${picture#$picture_dir}
    backup_name=$(echo "${relative}" | sed -r 's/.jpg$/.lep/')
    echo "Making backup of file ${picture}"
    lepton "$picture" "$backup_name" > /dev/null 2>&1
done

echo "Starting non picture stuff $picture_dir"
find $picture_dir -type f -not -name "*.jpg" -print0 | while IFS='' read -r -d '' not_picture;
do
    relative=$backup_picture_dir${not_picture#$picture_dir}
    echo "Making backup of file ${not_picture}"
    cp "$not_picture" "$relative"
done
