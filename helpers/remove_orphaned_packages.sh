#!/bin/bash
[[ $(pacman -Qtdq) ]] && yes | pacman -Rns $(pacman -Qtdq)
