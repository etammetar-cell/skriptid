#!/usr/bin/env bash

# Lõputu tsükkel menüü kuvamiseks kuni kasutaja valib väljumise
while true; do
    echo "========================================="
    echo "Vali tegevus:"
    echo "1) Uuenda paketihalduri andmeid ja tarkvara"
    echo "2) Paigalda ja käivita apache2"
    echo "3) Eemalda apache2 ja seotud paketid"
    echo "4) Valju"
    echo "========================================="
    read -p "Sisesta valik (1-4): " valik

    case "$valik" in
        1)
            # Uuendame pakettide nimekirja ja tarkvara vaikimisi 'yes' vastusega
            echo "Uuendan paketihalduri andmeid ja tarkvara..."
            if sudo apt-get update && sudo apt-get upgrade -y; then
                echo "Tarkvara uuendamine onnestus!"
            else
                echo "Viga: tarkvara uuendamine ebaonnestus!"
            fi
            ;;
        2)
            # Kontrollime enne paigaldamist, kas apache2 on juba süsteemis olemas
            if dpkg -s apache2 >/dev/null 2>&1; then
                echo "Hoiatus: apache2 on juba paigaldatud!"
            else
                echo "Paigaldan apache2 tarkvara..."
                if sudo apt-get update && sudo apt-get install -y apache2; then
                    echo "apache2 paigaldamine onnestus!"
                    # Käivitame apache2 teenuse ja paneme selle automaatselt käivituma
                    if sudo systemctl enable --now apache2; then
                        echo "apache2 teenuse kaivitamine onnestus!"
                    else
                        echo "Viga: apache2 teenuse kaivitamine ebaonnestus!"
                    fi
                else
                    echo "Viga: apache2 paigaldamine ebaonnestus!"
                fi
            fi
            ;;
        3)
            # Kontrollime, kas apache2 on paigaldatud enne eemaldamist
            if dpkg -s apache2 >/dev/null 2>&1; then
                echo "Lülitan apache2 teenuse välja ja eemaldan tarkvara..."
                sudo systemctl stop apache2 2>/dev/null || true
                sudo systemctl disable apache2 2>/dev/null || true
                # Eemaldame apache2 ja sellega seotud paketid vaikimisi 'yes' vastusega
                if sudo apt-get purge -y apache2 && sudo apt-get autoremove -y; then
                    echo "apache2 eemaldamine onnestus!"
                else
                    echo "Viga: apache2 eemaldamine ebaonnestus!"
                fi
            else
                echo "Hoiatus: apache2 ei ole paigaldatud, pole midagi eemaldada!"
            fi
            ;;
        4)
            # Väljume menüüst
            echo "Valjun menüüst. Head aega!"
            exit 0
            ;;
        *)
            # Teavitame kasutajat, kui sellist valikut menüüs ei ole
            echo "Viga: sellist valikut pole olemas! Palun vali 1, 2, 3 või 4."
            ;;
    esac
done
