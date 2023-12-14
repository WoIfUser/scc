#!/bin/bash

clear
nums=$(seq 100 301 | tr -s '\n' '|')
nums+=$(seq -s"|" 400 599)

while :; do
read -p "IP/Proxy: " IP
read -p "Puerto: " PUERTO
read -p "Dominio: " DOMINIO

dots=$(grep -F "." -o <<< $IP | wc -l)
> ips.txt; echo "By WolFUser" > a; > b
case $dots in
  1) echo -e "\e[01;33mAmigo... 3 rangos de ip, va demorar un culo\e[0m\n"; sleep 1
     #  VA DEMORAR UN CULO
     ;;                                                    
  2) ips=$(for i in {0..255}; do echo $IP$i.; done)
      for i in {0..255}; do                             
         case $i in 0) i=1; esac                        
         ips2=$(sed -n "$i"p <<< "$ips");
            for i1 in {0..255}; do
                echo $ips2$i1 >> ips.txt
            done
      done
      echo -e "\n\e[01;33mCerca de 65536 ips fueron generados\nLas solicitaciones seran jodidas en subshell\e[0m\n\e[02m(Puede demorar)\e[0m\n"
       x=$(($(wc -l < ips.txt)/3))

         $(for i in $(seq $x); do ip=$(sed -n "$i"p ips.txt); try=$(curl -m 3 -s -o /dev/null -w "%{http_code}" $DOMINIO -H "Upgrade: websocket" -x $ip:$PUERTO); eval "case $try in $nums\ ) echo \"$ip|$try\" >> OK.txt; echo \"\e[01;33m$ip\e[0m | \e[01;37mIP OK - STATUS $try\e[0m\" >> ips2.txt; echo \"By WolFUser\" >> a;; *):; esac"; done; echo a >> b) </dev/null >/dev/null 2>&1&

         $(for i in $(seq $(($x+1)) $(($x*2))); do ip=$(sed -n "$i"p ips.txt); try=$(curl -m 3 -s -o /dev/null -w "%{http_code}" $DOMINIO -H "Upgrade: websocket" -x $ip:$PUERTO); eval "case $try in $nums\ ) echo \"$ip|$try\" >> OK.txt; echo \"\e[01;33m$ip\e[0m | \e[01;37mIP OK - STATUS $try\e[0m\" >> ips2.txt; echo \"By WolFUser\" >> a;; *):; esac"; done; echo a >> b) </dev/null >/dev/null 2>&1&

         $(for i in $(seq $(($x*2+1)) $(wc -l < ips.txt)); do ip=$(sed -n "$i"p ips.txt); try=$(curl -m 3 -s -o /dev/null -w "%{http_code}" $DOMINIO -H "Upgrade: websocket" -x $ip:$PUERTO); eval "case $try in $nums\ ) echo \"$ip|$try\" >> OK.txt; echo \"\e[01;33m$ip\e[0m | \e[01;37mIP OK - STATUS $try\e[0m\" >> ips2.txt; echo \"By WolFUser\" >> a;; *):; esac"; done; echo a >> b) </dev/null >/dev/null 2>&1&
      
      while :; do
       linhas=$(wc -l < a)
         case $linhas in
              1) echo -e "\e[01;33m BUSCANDO IPS CON RETORNO OK...\e[0m"| pv -qL 10; sleep 5; tput cuu1; tput dl1;
                 linhas=$(wc -l < b)
                  case $linhas in
                      3) echo -e "\e[01;37m NINGÚN IP DE RETORNO OK\e[0m"| pv -qL 10; sleep 3; break
                  esac;;
              *) linhas=$(wc -l < b)
                  case $linhas in
                      3) break;
                  esac
                 echo -e "\e[01;37m ALGUNAS IPS RETORNARAN OK\e[0m"| pv -qL 10; sleep 5; tput cuu1; tput dl1;;
         esac
      done

      linhas=$(wc -l < a)
        case $linhas in
             1) echo -e "\e[01;33m NO HUBO NINGÚN RETORNO EN ESE RANGO DE IP $IP\255.255\e[0m"; break;;
             *) linhas=$(wc -l < b)
                OK=$(<ips2.txt)
                echo -e "$OK"; break
         esac
     ;;
  3) for i in {0..255}; do echo $IP$i >> ips.txt; done
      for i in $(seq $(wc -l < ips.txt)); do
         ip=$(sed -n "$i"p ips.txt)
         try=$(curl -m 3 -s -o /dev/null -w "%{http_code}" $DOMINIO -H "Upgrade: websocket" -x $ip:$PUERTO)
          eval "case $try in
                 $nums\ )
                      echo -e \"\e[01;33m$ip\e[0m | \e[01;37mIP OK - STATUS $try\e[0m\"
                      echo \"$ip|$try\" >> OK.txt;;
                   *)
                      echo -e \"$ip | \e[01;33mSTATUS $try\e[0m\"
           esac"
      done; echo ================= >> OK.txt; break
     ;;
  *) echo -e "\e[01;31mIngresa el formato corretamente\e[0m\n"; sleep 1
esac
done; rm ips.txt ips2.txt b a 2> /dev/null
