#/bin/sh

. fluxbox/menu.sh

TEMPFILE=`tempfile`

echo -e $DEFAULT_MENU >> $TEMPFILE

cp -i $TEMPFILE ~/.fluxbox/menu
