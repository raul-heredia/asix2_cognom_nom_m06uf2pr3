#!/bin/bash

#Fes un arxiu de guió que demani a l'usuari una adreça URL
#comprovi si es correcta i a continuació cridi a firefox per obrir l'adreça introduida. 
#Si l'adreça URL no té el format correcte, llavors el programa finalitzarà immediatament enviant el codi de sortida 1.  
#Si l'adreça URL té el format correcte, llavors el programa obrirà firefox amb l'adreça indicada i finalitzarà el codi de sortida 0.  
#El nom del programa serà url.sh.

function INPUT(){
    echo -n "Introdueix una URL: " #Demana URL i la emmagatzema a la variable URL
    read URL
}

function CHECK(){
    curl --connect-timeout 3 $URL > /dev/null 2>&1 # Comprova si la URL retorna alguna cosa (Maxim 3 segons per establir connexió)

    if [[ "$?" -eq 0 ]]; then # Si la comanda anterior té un codi diferent a 0 surt del programa amb codi 1
        echo "URL correcte"
    else
        echo "URL incorrecte"
        exit 1;
    fi
}

function FIREFOX(){
    echo "Obrint pàgina $URL a Firefox" 
    firefox $URL & # Obre el firefox amb la URL que hem especificat
}

function MAIN(){
    INPUT
    CHECK
    FIREFOX
}

MAIN