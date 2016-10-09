#!/bin/bash
# input: backup-pictures.sh [<backup-picture-dir>] [<picture-dir>]
# backup-picture-dir : Directory to place backup pictures
# picture-dir : Directory with files to backup


picture_dir="$HOME/Pictures"
backup_picture_dir="$HOME/Pictures-Backups"

if [ -z "${1}" ]; then
    echo "Backup dir not given, ${backup_picture_dir} will be used"
else
    backup_picture_dir="${1}"
fi

if [ -z "${2}" ]; then
    echo "Picture dir not given, ${picture_dir} will be used"
else
    picture_dir="${2}"
fi

echo "Making restorative dirs ${picture_dir}"
find "${backup_picture_dir}" -type d -print0 | while IFS='' read -r -d '' directory;
do
    restore_dir=${directory#$backup_picture_dir}
    restore_dir_full=${picture_dir}${restore_dir}
    echo "Making dir ${restore_dir_full}"
    mkdir -p "${restore_dir_full}"
done

echo "Starting picture stuff ${backup_picture_dir}"
find ${backup_picture_dir} -type f -name "*.lep" -print0 | while IFS='' read -r -d '' picture;
do
    relative=$picture_dir${picture#$backup_picture_dir}
    backup_name=$(echo "${relative}" | sed -r 's/.lep$/.jpg/')
    echo "Restoring from backup file ${picture}"
    lepton "${picture}" "${backup_name}" > /dev/null 2>&1
done

echo "Starting non picture stuff ${backup_picture_dir}"
find ${backup_picture_dir} -type f -not -name "*.lep" -print0 | while IFS='' read -r -d '' not_picture;
do
    relative=$picture_dir${not_picture#$backup_picture_dir}
    echo "Restoring from backup file ${not_picture}"
    cp "${not_picture}" "${relative}"
done
