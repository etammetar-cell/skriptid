#!/usr/bin/env bash

# Määrame nimekirja faili asukoha (vaikimisi ~/nimekiri.txt või esimene argument)
nimekiri="${1:-$HOME/nimekiri.txt}"

# Kontrollime, kas etteantud tee on ikka olemasolev fail
if [ ! -f "$nimekiri" ]; then
    echo "Hoiatus: faili $nimekiri ei leitud!"
    exit 1
fi

# Loeme nimekirja rida-realt sisse (eesnimi ja perenimi)
while read -r eesnimi perenimi; do
    # Jätame tühjad read vahele
    [ -z "$eesnimi" ] && continue

    # Liidame eesnime ja perenime punktiga, muudame väiketähtedeks ja asendame täpitähed
    kasutajanimi=$(echo "${eesnimi}.${perenimi}" | tr '[:upper:]' '[:lower:]' | sed 'y/õüäöÕÜÄÖ/ouaoOUAO/')

    # Koostame 12-märgilise juhusliku parooli
    parool=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c12)

    # Loome kasutaja süsteemi ja määrame parooli
    sudo useradd -m -s /bin/bash "$kasutajanimi" 2>/dev/null || true
    echo "$kasutajanimi:$parool" | sudo chpasswd 2>/dev/null || true

    # Väljastame kasutajanime ja parooli ekraanile ning faili
    echo "$kasutajanimi $parool" | tee -a ~/loodud_kasutajad.txt
done < "$nimekiri"
