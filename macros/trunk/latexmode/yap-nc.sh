#!/bin/sh
export DISPLAY=127.0.0.1:0.0
export HOME=/cygdrive/c/nedit
export NEDIT_HOME=/cygdrive/c/nedit
export XKEYSYMDB=/cygdrive/c/cygwin/bin/xkeysymdb
export PATH=/cygdrive/c/cygwin/bin:/cygdrive/c/cygwin/bin/shell-co:$PATH

# Start your X server for example
#/cygdrive/c/mix_95/xs &
#/cygdrive/c/cygwin/bin/waimea &

filename=`cygpath -u "$2" | tr A-Z a-z`
nc +$1 "$filename"

#For hiding the console window
#hidewndw /n /c /fh ConsoleWindowClass
