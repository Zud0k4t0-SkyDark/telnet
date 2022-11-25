#!/bin/bash

# Instalación del demonio de telnet


# Función para salir con CTRL + C

trap ctrl_c INT

function ctrl_c(){
	clear
	echo -e "Saliendo...."
	tput cnorm
	exit 1
}

function packages(){
	echo "Comprobando Paquetes: "
	echo -en "openbsd-inetd............................"
	test -f /etc/inetd.conf
	if [ $(echo $?) == "0" ];then
		echo -e "(V)"
	else
		echo -e "(X)"
		sudo apt-get install openbsd-inetd -y &>/dev/null
	fi
	echo -en "telnetd............................"
	cat /etc/passwd | grep "telnetd" &>/dev/null
	if [ $(echo $?) == "0" ];then
		echo -e "(V)"
	else
		echo -e "(X)"
		sudo apt-get install telnetd -y &>/dev/null
	fi
}


function inicio(){

	sudo /etc/init.d/openbsd-inetd restart &>/dev/null
	#Para ver el puerto 
	# netstat -ltpn
	# Para ver el nombre del servicio
	# netstat -ltp
	type=$(sudo netstat -ltp | grep "telnet" | awk '{print $1}')
	listen_port=$(sudo netstat -ltp | grep "telnet" | awk '{print $NF}')
	echo -en "Conexion establecida\n\tTipo\t$type\n\tPuerto\t$listen_port\n"
	tput cnorm

}

if [ $(id -u) == "0" ];then
	tput civis
	packages
fi
