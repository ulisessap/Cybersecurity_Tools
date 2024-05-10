#! /bin/bash


AZUL_CLARO='\e[94m'
ROJO='\e[91m'
RESET='\e[0m'

#Funcion que sirve para poder usar Ctrl+C 
ctrl_c() {
    echo "(Ctrl+C). Saliendo del script..."
    exit 1
}

# Asigna la función ctrl_c al manejo de la señal SIGINT (Ctrl+C)
trap ctrl_c SIGINT

barrido_red(){
    # Obtiene la dirección IP de la máquina
    IP=$(hostname -I | cut -d' ' -f1)

    # Elimina la última parte de la dirección IP
    ip_prefijo=$(echo $IP | cut -d'.' -f1-3)
    
    inicio=1
    final=254

    # Escaneo con ping
    for ((i=$inicio; i<=$final; i++));do
        ip="$ip_prefijo.$i"
        if ping -c 1 $ip > /dev/null 2>&1; then
            echo -e  "${AZUL_CLARO}El Host $ip esta encendido${RESET}"

            # Extrae el TTL de la respuesta del ping
            ttl=$(ping -c 1 $ip | grep "ttl" | awk '{print $6}' | cut -d '=' -f2)

            # Verifica el sistema operativo basado en el TTL
            os=$(check_os $ttl)

            # Imprime el resultado
            echo "La dirección IP $ip está ejecutando: $os"
        else
            echo -e "${ROJO}El Host $ip esta apagado${RESET}"
        fi
    done

}

check_os() {
    ttl=$1
    if ((ttl >= 0 && ttl <= 63)); then
        echo "Unix/Linux"
    elif ((ttl >= 64 && ttl <= 127)); then
        echo "Windows"
    elif ((ttl >= 128 && ttl <= 255)); then
        echo "OS X / BSD"
    else
        echo "No se puede determinar el sistema operativo"
    fi
    
    
}
barrido_red
