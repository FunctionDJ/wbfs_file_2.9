#!/bin/sh

# move_dirs.sh v2 by oggzee
#
# Usage:
# 1. place wbfs_file in same directory where this .sh file is located
# 2. run ./move_dirs.sh /path/to/wbfs
#
# or:
#
# 2. edit the below variable: WBFS_DIR
# 3. run: ./move_dirs.sh


WBFS_DIR=/mnt/usb/wbfs


##########################################


WBFS_FILE=./wbfs_file

if [ -n "$1" ]; then 
	echo Using specified wbfs dir: $1
	WBFS_DIR="$1"
fi

if [ ! -e "$WBFS_DIR" ]; then
	echo Error: missing wbfs dir: $WBFS_DIR
	exit
fi

if [ ! -e "$WBFS_FILE" ]; then
	echo Error: missing $WBFS_FILE
	exit
fi

echo Games to be moved in $WBFS_DIR:
echo

for I in "$WBFS_DIR"/*.wbfs; do
	#echo "$WBFS_FILE" "$I" id_title
	"$WBFS_FILE" "$I" id_title >/dev/null
	if [ $? != 0 ]; then
		echo ERROR $WBFS_FILE "$I" id_title
		exit
	fi
	"$WBFS_FILE" "$I" id_title | tail -1
done

echo
echo move these games?
read ASK
if [ "$ASK" != "y" ]; then
	echo bye
	exit
fi

echo
echo Moving: ...
echo

for I in "$WBFS_DIR"/*.wbfs; do
	FN=`basename $I .wbfs`
    IDT=`"$WBFS_FILE" "$I" id_title | tail -1`
	echo Moving to: "$IDT"
	echo mkdir "$WBFS_DIR/$IDT"
	mkdir "$WBFS_DIR/$IDT"
	echo mv "$WBFS_DIR/$FN*.*" "$WBFS_DIR/$IDT"
	mv "$WBFS_DIR/$FN"* "$WBFS_DIR/$IDT" 2>/dev/null
	echo
done

echo
echo ===== DONE =====
echo

