#!/bin/bash

OPTION=$(whiptail --title "跳转目录" --menu "选择要跳转的目录" 12 40 3 \
"1" "Movies" \
"2" "Series" \
"3" "Shares" 3>&1 1>&2 2>&3)

# Cancel
exitstatus=$?
if [ $exitstatus != 0 ]; then
    echo "You chose Cancel."
    return
fi

# Change Directory
if [ $OPTION = '1' ]; then
    cd /mnt/movies
elif [ $OPTION = '2' ]; then
    cd /mnt/series
elif [ $OPTION = '3' ]; then
    cd /mnt/common/shares
else
    echo "Unknown Option."
fi
