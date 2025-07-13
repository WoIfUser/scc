#!/bin/bash

clear
echo -e "\e[0;31mBy MrDarK\e[0m 🔍"
echo -e "\nsearching from the origin.\n"

read -p "Range base (ej: 192.168.1.): " BASE
read -p "Port [default: 443]: " PORT

PORT=${PORT:-443}
OUTPUT="Open_ports_${PORT}_local.txt"
> $OUTPUT

echo -e "\nStarting port scan $PORT...\n"

CONCURRENT=50

check_local_port() {
    ip=$1
    timeout 2 bash -c "echo >/dev/tcp/$ip/$PORT" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "$ip" >> $OUTPUT
        echo -e "\e[0;32m$ip ➜ OPEN PORT\e[0m"
    else
        echo -e "\e[0;31m$ip ➜ CLOSED PORT\e[0m"
    fi
}

export -f check_local_port
export PORT OUTPUT

seq 0 255 | xargs -n1 -P $CONCURRENT -I {} bash -c 'check_local_port "'$BASE'{}"'

echo -e "\n\e[0;33mscan completed. IPs with port $PORT open saved in $OUTPUT\e[0m"
