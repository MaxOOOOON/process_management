#!/usr/bin/env bash

temp_folder=/tmp/lsof

for pid in `ls  /proc/ | grep -P "^[0-9]" | sort -n`
    do
        if [[ -d /proc/$pid ]]
        then
        command=$(cat /proc/$pid/comm)

        #files=


        echo ${command%/?*} $pid $task $user $fd $type $device $size $node $name >> $temp_folder
        fi
    done

column -s " " -t -N COMMAND,PID,TASKCMD,USER,FD,TYPE,DEVICE,SIZE/OFF,NODE,NAME $temp_folder
rm -rf $temp_folder






#useful commmands
#printf "%-15s %-15s\n" first second