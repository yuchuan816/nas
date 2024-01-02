#!/bin/bash

OPTION=$(whiptail --title "拷贝媒体" --menu "选择要拷贝的媒体类型" 10 40 2 \
"1" "Movies" \
"2" "Series" 3>&1 1>&2 2>&3)

# Cancel
exitstatus=$?
if [ $exitstatus != 0 ]; then
    echo "You chose Cancel."
    exit
fi

# Copy
if [ $OPTION = '1' ]; then
    # 拷贝movies文件夹
    rsync -ah --preallocate --info=progress2 \
        /mnt/common/shares/factory-movies/* \
        /mnt/movies/
elif [ $OPTION = '2' ]; then
    # 拷贝series文件夹
    rsync -ah --preallocate --info=progress2 \
        /mnt/common/shares/factory-series/* \
        /mnt/series/
else
    echo "Unknown Option."
fi
