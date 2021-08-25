#!/usr/bin/env bash

temp_folder=/tmp/lsof

echo "COMMAND PID SIZE/OFF NODE NAME" > $temp_folder

for pid in `ls  /proc/ | grep -P "^[0-9]" | sort -n`
    do
        if [[ -d /proc/$pid ]]
        then
        command=$(cat /proc/$pid/comm)

        files=`readlink /proc/$pid/map_files/*; readlink /proc/$pid/cwd`
        files=`printf "%s\n" "${files[@]}" | sort -u`
        if ! [[ -z "$files" ]]
        then
        for num in $files
        do
        node=$(stat --format="%i" $num 2> /dev/null)
        size=$(stat --format="%s" $num 2> /dev/null)

        echo $command $pid $size $node $num >> $temp_folder
        done
        fi

        fi
    done

column -s " " -t  $temp_folder




#useful commmands
#printf "%-15s %-15s\n" first second
