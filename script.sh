#!/usr/bin/env bash

temp_file=/tmp/lsof

echo "COMMAND PID SIZE/OFF NODE NAME" > $temp_file

#перечисление процессов в папке proc
for pid in `ls  /proc/ | grep -P "^[0-9]" | sort -n`
    do
        if [[ -d /proc/$pid ]] 
        then
        command=$(cat /proc/$pid/comm)  #получение команды, которая запустила процесс

        files=`readlink /proc/$pid/map_files/*; readlink /proc/$pid/cwd` #чтение симлинков
        files=`printf "%s\n" "${files[@]}" | sort -u`                    #удаление повторяющихся файлов
        if ! [[ -z "$files" ]]                                          
        then
        for f in $files
        do
        node=$(stat --format="%i" $f 2> /dev/null)  #inode number
        size=$(stat --format="%s" $f 2> /dev/null)  #total size

        echo $command $pid $size $node $f >> $temp_file  #вывод значений в файл
        done
        fi

        fi
    done

#вывод файла в виде таблицы
column -s " " -t  $temp_file
rm -rf $temp_file



#useful commmands
#printf "%-15s %-15s\n" first second
