#!/bin/bash

clear
echo -e "\e[0;31mPort 443 Open Scanner by ChatGPT\e[0m 🔍"
echo -e "\nEste script escanea 256 IPs en un rango y muestra si el puerto 443 está abierto.\n"

read -p "Rango base (ej: 192.168.1.): " BASE
read -p "Puerto [default: 443]: " PUERTO

PUERTO=${PUERTO:-443}
OUTPUT="puertos_abiertos_${PUERTO}.txt"
> $OUTPUT

echo -e "\nIniciando escaneo en el puerto $PUERTO...\n"

# Número de hilos en paralelo
CONCURRENT=50

check_port() {
    ip=$1
    if nmap -p $PUERTO --open -Pn -T4 $ip | grep -q "$PUERTO/tcp open"; then
        echo "$ip" >> $OUTPUT
        echo -e "\e[0;32m$ip ➜ PUERTO ABIERTO\e[0m"
    else
        echo -e "\e[0;31m$ip ➜ PUERTO CERRADO\e[0m"
    fi
}

export -f check_port
export PUERTO OUTPUT

seq 0 255 | xargs -n1 -P $CONCURRENT -I {} bash -c 'check_port "'$BASE'{}"'

echo -e "\n\e[0;33mEscaneo completado. IPs con el puerto $PUERTO abierto guardadas en $OUTPUT\e[0m"
