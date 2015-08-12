#!/bin/bash

if [[ $# -lt 2 ]]; then
  echo -e "Usage: $0 NWORDS FILE\n" && exit;
fi

i=0
while [[ $i -lt $1 ]]; do
  perl -e 'srand;' -e 'rand($.) < 1 && ($it = $_) while <>;' \
       -e 'print $it' $2
  i=$[$i+1]
done
