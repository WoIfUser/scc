#!/bin/bash

clear
echo -e "\e[0;31mLocal Port 443 Scanner (Sin Internet) by ChatGPT\e[0m 🔍"
echo -e "\nEscanea IPs en rango local para verificar puertos abiertos sin requerir Internet.\n"

read -p "Rango base (ej: 192.168.1.): " BASE
read -p "Puerto [default: 443]: " PUERTO

PUERTO=${PUERTO:-443}
OUTPUT="puertos_abiertos_${PUERTO}_local.txt"
> $OUTPUT

echo -e "\nIniciando escaneo en el puerto $PUERTO...\n"

CONCURRENT=50

check_local_port() {
    ip=$1
    timeout 2 bash -c "echo >/dev/tcp/$ip/$PUERTO" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "$ip" >> $OUTPUT
        echo -e "\e[0;32m$ip ➜ PUERTO ABIERTO\e[0m"
    else
        echo -e "\e[0;31m$ip ➜ PUERTO CERRADO\e[0m"
    fi
}

export -f check_local_port
export PUERTO OUTPUT

seq 0 255 | xargs -n1 -P $CONCURRENT -I {} bash -c 'check_local_port "'$BASE'{}"'

echo -e "\n\e[0;33mEscaneo completado. IPs con el puerto $PUERTO abierto guardadas en $OUTPUT\e[0m"
