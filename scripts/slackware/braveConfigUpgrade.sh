#!/bin/sh
cd /etc
find . -name "*.new" | while read configfile ; do
if [ ! "$configfile" = "./rc.d/rc.inet1.conf.new" \
    -a ! "$configfile" = "./rc.d/rc.local.new" \
    -a ! "$configfile" = "./group.new" \
    -a ! "$configfile" = "./passwd.new" \
    -a ! "$configfile" = "./shadow.new" ]; then
    cp -a $(echo $configfile | rev | cut -f 2- -d . | rev) \ $(echo $configfile | rev | cut -f 2- -d . | rev).bak 2> /dev/null
    mv $configfile $(echo $configfile | rev | cut -f 2- -d . | rev)
fi
done

