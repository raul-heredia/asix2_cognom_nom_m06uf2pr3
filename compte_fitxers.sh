#!/bin/bash

function GETDIR(){
    echo -n "Introdueix un directori: " 
    read DIR #Llegim el directori
}

function COMPTE(){
    TOTAL=$(find $DIR -maxdepth 1 -type f -user $USER -perm -u+r -size +0b | wc -l) # Posem la comanda per buscar els arxius amb permisos de lectura a la variable TOTAL
    echo "En total hi ha $TOTAL arxius amb mida superior a 0 en els que tens permís de lectura a $DIR" # Mostrem el total d'arxius amb permisos de lectura al directori introduit per l'usuari
}

function MAIN(){
    GETDIR
    COMPTE
}

MAIN
