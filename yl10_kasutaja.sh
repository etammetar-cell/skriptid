#!/usr/bin/env bash

# Küsime kasutajalt uue kasutajanime ja salvestame muutujasse
read -p "Sisesta uus kasutajanimi: " kasutajanimi

# Küsime parooli nii, et sisestatavaid märke ekraanil ei kuvata
read -s -p "Sisesta parool: " parool

# Lisame reavahetuse pärast varjatud parooli sisestamist
echo

# Loome uue kasutaja koos kodukataloogi ja bash kestaga
sudo useradd -m -s /bin/bash "$kasutajanimi"

# Määrame loodud kasutajale sisestatud parooli
echo "$kasutajanimi:$parool" | sudo chpasswd

# Loome uue kasutaja kodukataloogi sisse alamkataloogi
sudo mkdir -p "/home/$kasutajanimi/kataloog"

# Loome alamkataloogi sisse tervitusfaili
echo "Tere tulemast, $kasutajanimi!" | sudo tee "/home/$kasutajanimi/kataloog/teretulemast_${kasutajanimi}.txt" > /dev/null

# Määrame loodud kataloogi ja faili omanikuks uue kasutaja
sudo chown -R "$kasutajanimi:$kasutajanimi" "/home/$kasutajanimi/kataloog"

# Teavitame kasutajat, et tegevus õnnestus
echo "Kasutaja $kasutajanimi ja fail /home/$kasutajanimi/kataloog/teretulemast_${kasutajanimi}.txt on loodud!"
