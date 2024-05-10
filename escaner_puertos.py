#!/usr/bin/env python3
#Escaner de puertos con python
import socket
import sys

def escaneo_puertos(ip, puerto_inicial, puerto_final):
    print(f"Escaneando puertos en {ip}...")
    try:
        # Resuelve la dirección IP del objetivo
        target_ip = socket.gethostbyname(ip)

        # Escaneo de puertos
        for port in range(puerto_inicial, puerto_final + 1):
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(1)  # Establece un tiempo de espera para la conexión

            # Intenta conectarse al puerto
            result = sock.connect_ex((target_ip, port))
            if result == 0:
                print(f"Puerto {port}: Abierto")
            else:
                print(f"Puerto {port}: Cerrado")

            sock.close()

    except socket.gaierror:
        print("No se pudo resolver el nombre del host.")
        return
    except socket.error:
        print("No se pudo conectar al servidor.")
        return

if __name__ == "__main__":
    ip_objetivo = sys.argv[1]
    puerto_inicial = int(sys.argv[2])
    puerto_final = int(sys.argv[3])

    # Ejecuta el escaneo de puertos
    try:
        escaneo_puertos(ip_objetivo, puerto_inicial, puerto_final)
    except ValueError as e:
        print("Error:", e)
        
        print("Para ejecutar el programa debe ingresar la dirección IP del objetivo y el rango de puertos a escanear.\n")
        print("Ejemplo: python escaner_puertos.py [ip] [puerto_inicial] [puerto_final]")
        sys.exit(1)
