#/bin/sh

. menu.sh

TEMPFILE=`tempfile`

echo -e $DEFAULT_MENU >> $TEMPFILE

cp -i $TEMPFILE ~/.fluxbox/menu

cp -i startup ~/.fluxbox/startup