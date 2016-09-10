#!/bin/bash
# input: backup-pictures.sh <picture-dir> <picture-backup-dir>

# allow command line input, not neeeded

picture_dir="$HOME/Pictures"
backup_picture_dir="$HOME/Pictures-Backups"

if [ -z "${1}" ]; then
    echo "Picture dir not given, ${picture_dir} will be used"
else
    picture_dir="${1}"
fi

if [ -z "${2}" ]; then
    echo "Backup dir not given, ${backup_picture_dir} will be used"
else
    backup_picture_dir="${2}"
fi

echo "Removing any files in backup dir"
rm -rf "${backup_picture_dir}"

echo "Making backup dirs ${backup_picture_dir}"
find "${picture_dir}" -type d -print0 | while IFS='' read -r -d '' directory;
do
    backup_dir=${directory#$picture_dir}
    backup_dir_full=${backup_picture_dir}${backup_dir}
    echo "Making dir ${backup_dir_full}"
    mkdir -p "${backup_dir_full}"
done

echo "Starting picture stuff $picture_dir"
find $picture_dir -type f -name "*.jpg" -print0 | while IFS='' read -r -d '' picture;
do
    relative=$backup_picture_dir${picture#$picture_dir}
    backup_name=$(echo "${relative}" | sed -r 's/.jpg$/.lep/')
    echo "Making backup of file ${picture}"
    lepton "${picture}" "${backup_name}" > /dev/null 2>&1
done

echo "Starting non picture stuff $picture_dir"
find $picture_dir -type f -not -name "*.jpg" -print0 | while IFS='' read -r -d '' not_picture;
do
    relative=$backup_picture_dir${not_picture#$picture_dir}
    echo "Making backup of file ${not_picture}"
    cp "$not_picture" "$relative"
done
