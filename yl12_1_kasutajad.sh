#!/usr/bin/env bash

# Kuvame failist /etc/passwd esimese tulba (ainult kasutajanimed)
cut -d: -f1 /etc/passwd
