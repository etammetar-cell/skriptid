#!/usr/bin/env bash

# Määratleme funktsiooni varunda, mis võtab argumendiks faili tee
varunda() {
    local faili_tee="$1"

    # Kontrollime, kas fail on olemas
    if [ ! -f "$faili_tee" ]; then
        echo "Viga: faili $faili_tee ei leitud!"
        return 1
    fi

    # Määrame backup kataloogi asukoha kasutaja kodukaustas ja loome selle
    local backup_kaust="$HOME/backup"
    mkdir -p "$backup_kaust"

    # Eraldame failinime ja faililaiendi
    local failinimi
    failinimi=$(basename "$faili_tee")
    local nimi="${failinimi%.*}"
    local laiend="${failinimi##*.}"

    # Koostame ajatempli kujul AAAA-KK-PP_TT-MM-SS
    local aeg
    aeg=$(date +%Y-%m-%d_%H-%M-%S)

    # Koostame sihtfaili tee koos kuupäeva ja kellaajaga
    local sihtfail="$backup_kaust/${nimi}_${aeg}.${laiend}"

    # Kopeerime algfaili backup kataloogi
    cp "$faili_tee" "$sihtfail"
    echo "Varukoopia loodud: $sihtfail"
}

# Kutsume funktsiooni välja skriptile antud esimese argumendiga (või vaikimisi ~/minufail.txt)
varunda "${1:-$HOME/minufail.txt}"
