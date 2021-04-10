#|/bin/bash

# Fes un  arxiu de guió que descarregui error.logs i a continuació extregui totes les línies que tinguin un error per una data determinada
# que l'usuari haurà d'entrar per teclat (dia, mes i any) i desi aquesta informació dins d'un fitxer de nom errXXXXYYYDD.log dins una carpeta personal
# de l'usuari de nom FitxConfBackup. XXXX representa l'any introduit per teclat. YYY representa el mes i DD el dia.
# El programa ha de crear la carpeta si no existeix. Si el fitxer ja existeix, s'ha de sobreescriure. El programa finalitzarà amb el codi de retorn 0. El nom del programa serà errors.sh.

DIR=~/FitxConfBackup
LOGFILE=${DIR}/error.logs

function GET() {
    echo "[..] Comprovant si ${DIR} existeix"
    if [[ ! -d "${DIR}" ]]; then # Comprovem si existeix, si no creem el directori
        mkdir ${DIR} && echo "[OK] ${DIR} S'ha creat correctament." || echo "[ERROR] No s'ha pogut crear ${DIR}"
    else
        echo "[OK] ${DIR} ja existeix."
    fi
    # Descarreguem l'arxiu
    wget -P ${DIR} https://www.collados.org/asix2/m06/uf2/error.logs >/dev/null 2>&1 && echo "[OK] El fitxer ${LOGFILE} s'ha descarregat correctament." || echo "[ERROR] No s'ha pogut descarregar el fitxer ${LOGFILE}"
}

function USERINPUT() {
    # Demanem les dates
    echo -n "Introdueix l'any en format [YYYY]: "
    read YEAR
    echo -n "Introdueix el mes en format [MMM] amb la primera lletra en majúscula: "
    read MONTH
    echo -n "Introdueix el día en format [DD]: "
    read DAY
    TIMESTAMP=$(echo "${YEAR}${MONTH}${DAY}") # Aquest serà el timestamp per a l'arxiu en el que es guardaran
    OUTPUTFILE="err${TIMESTAMP}.log"          # L'arxiu on aniran guardats sera errYYYYMMDD.log
}
function GET_ERRORS() {
    cd ${DIR} # Canviem al directori on esta l'arxiu error.logs
    YEARAWK="${YEAR}]" # Afegim un "]" al final ja que la columna de l'any conté un ] al final i així ens asegurem que no dona errors
    awk -v d="$DAY" -v m="$MONTH" -v y="$YEARAWK" '$2==m && $3==d && $5==y {print $0}' error.logs >logtemp.log # Agafem tots els registres del dia concret introduït per l'usuari i el guardem en un arxiu temporal anomenat logtemp.log
    awk '$6=="[error]" {print $0}' logtemp.log >${OUTPUTFILE} && echo "[OK] S'han extret els errors de la data ${MONTH} ${DAY} ${YEAR} al fitxer ${DIR}/${OUTPUTFILE}" || echo "[ERROR] No s'han pogut extreure els errors de la data ${MONTH} ${DAY} ${YEAR}" #Agafem els registres de logtemp.log i agafem nomes els que tinguin "[error]" i el guardem a l'arxiu errYYYYMMMDD.log
    rm logtemp.log # Esborrem l'arxiu temporal logtemp.log  
    cd ~/
    echo "[..] Nota: Si al dia introduït no va haver-hi cap error el fitxer ${DIR}/${OUTPUTFILE} estarà en blanc."
}
function CLEAN() {
    rm ${LOGFILE} # Esborrem l'arxiu descarregat
}
function MAIN() {
    USERINPUT
    clear
    GET
    GET_ERRORS
    CLEAN
}

MAIN
