#!/bin/bash
if [ ! -z "$(pacman -Qtdq)" ]; then
  yes | pacman -Rns $(pacman -Qtdq)
fi
