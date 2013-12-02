#!/bin/bash
#
# Last update: 01/09/2011
# by Spina <spina80@gmail.com>
#
# Scova i pacchetti slackware che non sono mai stati utilizzati
# nel mese corrente e li stampa sullo standard output
#
# Copyright (C) 2010 Emanuele Tomasi <spina80@gmail.com>
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA

# -h for help

SCRIPT_NAME=${0##*/} # Nome dello script
SCRIPT_AUTHOR='Spina <spina80@gmail.com>' # Nome autore <email>
SCRIPT_HOMEPAGE='http://www.slacky.eu/wikislack/index.php?title=Unused_SlackPkg'

### PERSONALIZZAZIONE ###

# La data di riferimento di default (1 mese fa)
DATE='now - 1 month'

# Il file in cui sono inseriti i nomi dei pacchetti da filtrare.
FILTER_FILE=~/.unused_SlackPkg

### FINE PERSONALIZZAZIONE ###

# Stampa l'argomento $1 seguito dalle informazioni per eseguire l'help.
# Poi ritorna uno stato di uscita pari a $2
function _exit
{
    echo -e "${1}\n\n${SCRIPT_NAME} -h for other infos.\n"
    exit $2
}

# Stampa l'help dello script
function _help
{
    echo -en "Usage: ${SCRIPT_NAME} [option]...
Show the packages which files are not used in the last times.\n
Options:
  -d <date>\tDate in the past before which the files aren't been used.
    \t\tThe format is the same of '-d' for date(1) (default '${DATE}')
  -h\t\tDisplay this help and exit
  -s\t\tShow also the size of package non compressed\n
Home: ${SCRIPT_HOMEPAGE}
by ${SCRIPT_AUTHOR}"
}

# Controlla l'esistenza di tutti i programmi dati i loro nomi come argomento.
# Se Un programma non viene trovato, allora, stampa il nome del o dei programmi mancanti ed esce.
# Si usa il programma which per controllare che esistono i programmi passati. Si assume che
# which sia in /bin/.
function _check_extern_program
{
    local error=0
    local string_error

    if [ ! -x /bin/which ]
    then
	error=1
	string_error="which : missimg program.\n";
    else
	for progr in $@
	do
	    if ! /bin/which $progr >& /dev/null
	    then
		let ++error
		string_error=${string_error}"${progr} : missing program.\n"
	    fi
	done
    fi

    if (( $error ))
    then
	if (( $error == 1 ))
	then
	    string_error=${string_error}"\n Missing needed program "
	else
	    string_error=${string_error}"\nMissing nedded programs "
	fi
	_exit "$string_error" 1
    fi
}

# Ritorna la lista dei file connessi al pacchetto ma che non si trovano
# direttamente nel pacchetto.
# Attualmente sono:
# - quei file "rinominati" dallo script doinst.sh
#
# $1: il pacchetto da controllare
#
function _get_other_file
{
    if [ -f /var/log/scripts/$1 ]
    then
	sed -n '/^ *mv  *[^$]*$/{s;^ *mv  *[^ ]*  *\([^ ]*\).*;\1;p}' /var/log/scripts/$1
    fi
}

# Controllo degli argomenti dello script in cerca di opzioni
enable getopts echo exit

# Impostazione del separatore di campi al valore di default
IFS=$'\n\t '

# Controllo dell'esistenza di tutti i programmi esterni (quindi non comandi interni alla bash) usati
_check_extern_program date grep sed stat

FLAG_S=0

while getopts :hsd: opzione
do
    case $opzione in
	d) DATE=${OPTARG}
	    ;;

	h) _help
	    exit
	    ;;

	s) FLAG_S=1
	    ;;

	?) _exit "-${OPTARG} : invalid argument." 1
	    ;;
    esac
done

# Shift degli argomenti in modo da avere $1 che punta al primo argomento che non è una opzione
while (( $OPTIND != 1 ))
do
    shift
    let --OPTIND
done

### Il cuore dello script inizia qui ###
# Sanity check
# Checking if root filesystem have been mounted as 'noatime'
if grep ' / .*\<noatime\>' /proc/mounts
then
    echo "Sorry, your root filesystem have been mounted with noatime option. With this option the time of the last access isn't updated. I can't continue!"
    exit 2
fi

! date=$(date -d"${DATE}" '+%s') && exit 1

if (( $(date '+%s') - $date < 0 ))
then
    echo 'Error:' $(date -d"@$date") 'is in the future!'
    exit 2
fi

IFS=$'\n\t'
cd /var/log/packages
for pkg in *
do
    # Salto gli eventuali pacchetti filtrati
    if [ -f $FILTER_FILE ]
    then
	pkgname=$(echo $pkg | sed 's/\(.*\)\(-[^-]*\)\{3\}$/\1/')
	grep "^$pkgname$" $FILTER_FILE >/dev/null && continue
    fi

    # Se il pacchetto è stato installato dopo la data di riferimento, lo salto
    (( $(date -d$(stat -c '%y' ${pkg}) '+%s') >= $date )) && continue

    used=0
    skip_header=1
    for line in $(<$pkg) $(_get_other_file $pkg)
    do
	# Salto l'intestazione del file
	if (( $skip_header ))
	then
	    # Prelevo la dimensione del pacchetto decompresso
	    [[ ${line:0:12} == 'UNCOMPRESSED' ]] && pkg_size=$(echo $line | sed 's/.*:[[:space:]]*\([[:digit:]]*\).*/\1/') && continue

	    # Controllo se l'intestazione è finita
	    [[ $line == './' ]] && skip_header=0 && continue

	    continue
	fi

	file=/${line}

	# Salto i file riservati
	[[ ${file:0:9} == '/install/' ]] && continue

	# Salto le directory
	[ -d $file ] && continue

        # Controllo i file di configurazione
	[[ ${file: -4} == '.new' ]] && [ ! -f ${file} ] && [ -f ${file%.new} ] && file=${file%.new}

	# Controllo se si è acceduti al file dopo la data di riferimento
        [ -e $file ] && (( $(date -d$(stat -c '%x' ${file}) '+%s') >= $date )) && used=1 && break
    done

    # Se il pacchetto non è usato
    if (( $used == 0 ))
    then
	echo -n $pkg

	if (( ${FLAG_S} ))
	then
	    let mb=pkg_size/1024 # Quanti mega sono il pacchetto decompresso?
	    if (( $mb > 0 ))
	    then
		pkg_size="${mb}Mb"
	    else
		pkg_size="${pkg_size}Kb"
	    fi
	    echo " " $pkg_size
	else
	    echo
	fi
    fi
done
