#!/bin/bash

function GETDIR(){
    echo -n "Introdueix un directori: "
    read DIR
}

function COMPTE(){
    TOTAL=$(find $DIR -maxdepth 1 -type f -user rahema -perm -u+r -size +0b | wc -l)
    echo "En total hi ha $TOTAL arxius en els que tens permís de lectura a $DIR"
}

function MAIN(){
    GETDIR
    COMPTE
}

MAIN