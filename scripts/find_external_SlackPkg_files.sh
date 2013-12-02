#!/bin/bash
#
# Last update: 01/10/11
# by Spina <spina80@gmail.com>
#
# Scova i file presenti nella root directory ma che però non sono stati
# installati da nessuno dei pacchetti Slackware.
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
SCRIPT_HOMEPAGE='http://www.slacky.eu/wikislack/index.php?title=Find_external_SlackPkg_files'

## PERSONALIZZAZIONE ##

# Il file con l'elenco dei path da ignorare. Se il path si riferisce
# ad un file, allora il file sarà ignorato, se invece si tratta di una
# directory, questa non sarà scandita, con la conseguenza che tutti i
# file ivi presenti saranno ignorati.
#
# Sono ignorate le righe vuote e le righe che iniziano con il '#'. Il
# file deve contenere un path per ogni riga, eventualmente si può
# specificare un comando da controllare, in questo caso il path sarà
# ignorato solo se esiste tale comando. Il comando deve essere
# separato dal path da almeno un carattere di spaziatura. Ad esempio,
# se il file di filtro contiene le seguenti righe:
# ---
# # My comment
#
# /home
# /usr/share/fonts/*.dir
# /usr/share/mime                 update-mime-database
# ---
# Allora lo script ignorerà:
# * la directory /home
# * tutti i file generati dal comando 'mkfontdir'
# * la directory /usr/share/mime se, e solo se, esiste il comando
#   'update-mime-database'
#
# Nota: i path sono passati al comando 'find' tramite l'uso della sua
# opzione '-path'. Si veda il manuale di 'find' per conoscere il
# formato accettato.
#
# Nota: se il path da filtrare contiene uno spazio, allora lo script
# penserà che ciò che si trova dopo lo spazia sia un comando da
# controllare. In questo caso, affinché tutto funzioni, bisogna
# aggiungere un altro spazio e poi un comando sicuramente esistente
# (ad esempio 'bash', visto che questo script viene eseguito proprio
# dalla bash).
#
# Nota: altri path saranno comunque ignorati, si veda la funzione
# filter_system_path().
FILTER_FILE=~/.find_external_SlackPkg_files

## FINE PERSONALIZZAZIONE ##

# Ritorna l'elenco dei path di sistema da ignorare. Queste directory
# non vanno scandite.
function _filter_system_path()
{
    cat <<EOF
/dev
/proc
/root
/sys
/var/log/packages
/var/log/scripts
/var/log/removed_packages
/var/log/removed_scripts
EOF
}

# Ritorna l'elenco dei path utente da ignorare controllando che
# l'eventuale programma settato come condizione esiste.
function _user_path_filtered
{
    if [ -f $FILTER_FILE ]
    then
	(IFS=$'\n'
	    for line in $(sed '/^[[:space:]]*#/d;/^[[:space:]]$/d' ${FILTER_FILE})
	    do
		path=$(echo $line | sed 's/\(.*[^[:space:]]\)[[:space:]]\+[^[:space:]]\+/\1/')
		program=$(echo $line | sed 's/.*[[:space:]]\([^[:space:]]\+\)/\1/')

		if [[ $path == $program ]] || /bin/which $program >& /dev/null
		then
		    echo $path
		fi
	    done
	)
    fi
}

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
    echo -en "Usage: ${SCRIPT_NAME} [option]
Finds those files that aren't installed by any Slackware package.\n
Options:
  -f\t\tShows the filtered paths. Paths that will be ignored.
  -h\t\tDisplay this help and exit\n
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
	    string_error=${string_error}"\nMissing needed program "
	else
	    string_error=${string_error}"\nMissing needed programs "
	fi
	_exit "$string_error" 1
    fi
}

# Controllo degli argomenti dello script in cerca di opzioni
enable getopts echo exit let local shift

# Impostazione del separatore di campi al valore di default
IFS=$'\n\t '

# Controllo dell'esistenza di tutti i programmi esterni (quindi non comandi interni alla bash) usati
_check_extern_program awk comm find mktemp readlink rm sed sort uniq

FLAG_F=0
while getopts :fh opzione
do
    case $opzione in
	f)
	    FLAG_F=1
	    ;;

	h)
	    _help
	    exit 0
	    ;;
	?)
	    _exit "-${OPTARG} : invalid argument." 1
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
first=0
for path in $(_filter_system_path) $(_user_path_filtered)
do
    if (( $FLAG_F == 1 ))
    then
	echo $path
    elif (( $first == 0 ))
    then
	path_to_prune="-path $path"
	first=1
    else
	path_to_prune="$path_to_prune -o -path $path"
    fi
done
(( $FLAG_F == 1 )) && exit 0

# Creo la directory temporanea di lavoro
! WORK_DIR=$(mktemp -d -p /tmp) && exit 1

# Catturo il segnal SIGINT inviato dal ctrl-c per assicurarmi di
# eliminare la directory temporanea
trap "rm -r $WORK_DIR; exit 3" SIGINT

cd $WORK_DIR

# Scandiamo tutta la root directory saltando i path filtrati
find / -mindepth 1 \( $path_to_prune \) -prune -o \( -type d -printf "%p/\n" \) -o -print | sort >  found_files.s

# Iniziamo a creare la lista dei file installati dai pacchetti...
# Per ogni file di info trovato sotto /var/log/packages/ bisogna:
# - saltare la parte introduttiva di descrizione del pacchetto
# - saltare la directory install/
# - inserire uno slash iniziale ai file
# - se il file finisce con '.new', aggiungerci anche il relativo file senza '.new'
sed -s -n '/^\.\//b print;d;:print n;/^install\//b print;s/^/\//;p;/\.new$/{s/\.new$//;p};b print' /var/log/packages/* > installed_files

# ...aggiungiamo i link simbolici creati dai doinst.sh dei pacchetti...
# Per ogni entry della forma '( cd dest_dir ; ln src link )' dei doinst.sh, per lo script awk:
# - $3 = dest_dir
# - $7 = src
# - $8 = link
# Lo script awk fa quanto segue:
# - elimina un eventuale slash finale da 'dest_dir'
# - se 'src' è un path assoluto, allora lo manda in output (ovviamente questo non è un link simbolico,
#   ma risolve i problemi come '/bin/bash' 'e /etc/localtime' che altrimenti non verrebbero trovati tra
#   i file installati in quanto creati da doinst.sh complessi).
# - se 'link' è un '.', allora allora il link simbolico è creato con lo stesso nome di 'src' ('/dest_dir/src')
#   altrimenti il link simbolico creato è '/dest_dir/link')
# L'output viene quindi ordinato ed epurato dalle doppie entry
awk '/^[^#]* cd .*; *ln /{ sub("/$", "", $3); if ( match($7, "^/") ) print $7; if ( $8 == "." ) { sub("/$", "", $7); sub(".*/", "", $7); print "/" $3 "/" $7} else print "/" $3 "/" $8}' /var/log/scripts/* | sort | uniq > symbolic_links.s
cat symbolic_links.s >> installed_files

# ...aggiungiamo tutte le librerie comprese nelle glibc...
# I pacchetti glibc-versione o glibc-solib-versione installano le librerie nella directory
# 'incoming' e poi le spostano con il doinst.sh. Questo viene fatto in modo tale da non eliminare
# tali librerie con la rimozione del pacchetto stesso.
sed -n '/\/incoming\/[^ ]/{s/\/incoming\//\//;s/^/\//;p}' /var/log/packages/glibc-* >> installed_files

# Scoviamo i file della root directory che non sono stati installati dai pacchetti
# L'output di 'comm' vede:
# - sulla prima colonna i file unici di 'found_files.s', quelli che non sono stati installati da nessun pacchetto
# - sulla seconda colonna i file unici di 'installed_files.s', ovvero quelli che pur essendo installati non sembrano
#   presenti nella root directory
# Lo script awk fa quanto segue:
# - tutte le entry della seconda colonna sono inviate al file 'installed_files_not_found.s'
# - per le entry della prima colonna esegue una compattazione delle directory stampando solo la directory madre
sort installed_files | uniq > installed_files.s
comm -3 --nocheck-order --output-delimiter=$'\t' found_files.s installed_files.s | awk -F '\t' 'BEGIN { row = "" }{ if ( $1 == "" ) { print $2 >> "installed_files_not_found.s" } else { if ( row == "" || ! match(row, "/$") || ! match($0, "^" row) ) { print; row = $0 } } }' > temp_output

# Scoviamo i file installati dai pacchetti sotto link simbolici
# Se '/usr/share/doc' è un link simbolico alla directory '/usr/doc', allora se un pacchetto installa dei file
# sotto '/usr/share/doc' li sta installando effettivamente sotto '/usr/doc' (questo è quello che ritorna 'find')
# e così per lo script, fino ad ora, questi file non sono stati installati da nessun pacchetto.
# Per ovviare a questo problema il codice seguente, per ogni link simbolico installato dai pacchetti che punta
# ad una directory, esegue questo algoritmo:
# - scova il percorso reale del link (nell'esempio sopra '/usr/doc')
# - elimina il sottoinsieme di righe da 'temp_output' che combaciano con il percorso reale
#   e le salva nel file 'subset.s', modificando il percorso reale con il link simbolico
#   (nell'esempio, ora 'subset.s' contiene entry col nome di '/usr/share/doc' mentre le entry
#    '/usr/doc' in 'temp_output' sono state eliminate)
# - manda in 'subset.tmp' tutte le entry di questo sottoinsieme creato che non sono state trovate tra i file installati
#   (a questo scopo si usa il file più piccolo 'installed_files_not_found.s', invece di 'installed_files.s')
# - se ce n'è qualcuno che non è stato installato dai pacchetti (condizione 'subset.tmp' di dimensioni diverse da 0)
#   allora ri-sostiuisce il link simbolico con il percorso reale e re-inserisce queste righe in 'temp_output'
#   (da ora in poi 'temp_output' non è più ordinato)
need_sort=0
for file in $(<symbolic_links.s)
do
    if [ -h $file -a -d $file ] # '-h' perché 'symbolic_links.s' non contiene solo link simbolici
    then
	real_path=$(readlink -m $file)
	sed -n -i "/^${real_path////\\/}\//{s;^${real_path}/;${file}/;;w subset.s
                                             ;d};p;" temp_output
	if [ -s subset.s ]
	then
	    comm --nocheck-order -23 subset.s installed_files_not_found.s > subset.tmp
	    if [ -s subset.tmp ]
	    then
		need_sort=1
		sed -i "/^${file////\\/}/s;^${file};${real_path};;" subset.tmp
		cat subset.tmp >> temp_output
	    fi
	fi
    fi
done
if (( need_sort == 1 ))
then
    sort temp_output
else
    cat temp_output
fi

rm -r $WORK_DIR

exit 0