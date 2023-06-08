#!/bin/bash

post_install() {

# Program:
#	script to be run after package installation

echo "run post install script, action is $1..."

# try to find the module.ini
CONFIG_LINK_FILE=/opt/Citrix/ICAClient/config/module.ini
if [ ! -f "$CONFIG_LINK_FILE" ]; then
	echo "error $CONFIG_LINK_FILE not exist!!!"
	exit
fi

if [ ! -L "$CONFIG_LINK_FILE" ]; then
	CONFIG_FILE=$CONFIG_LINK_FILE
else
	CONFIG_FILE=`readlink -f $CONFIG_LINK_FILE`
	# CONFIG_FILE=/etc/icaclient/nls/en/module.ini

	if [ ! -f "$CONFIG_FILE" ]; then
		echo "error $CONFIG_FILE not exist!!!"
		exit
	fi
fi

line=`grep -n "VirtualDriver" $CONFIG_FILE |cut -d ":" -f 1`

VIRTUAL_CONTENT=`sed -n "$line p" $CONFIG_FILE |grep  "ZoomMedia"`

if [ -z "$VIRTUAL_CONTENT" ]; then
	echo "you never installed zoom media plugin before"
else
	echo "you has installed zoom media plugin before, skip this step"
	exit
fi


# find empty line
EMPTY_LINES=`sed -n '/^$/='  $CONFIG_FILE`

FIRST_EMPTY_LINE=1

for itemline in $EMPTY_LINES
do
	if [ $itemline -gt $line ]; then
		FIRST_EMPTY_LINE=$itemline
		break
	fi
done

if [ $FIRST_EMPTY_LINE -eq 1 ]; then
	echo"exit"
	exit
fi

echo "add ZoomMedia config item in $CONFIG_FILE"

sed -i '/VirtualDriver/s/$/, ZoomMedia/' $CONFIG_FILE

sed -i "${FIRST_EMPTY_LINE}i ZoomMedia=On" $CONFIG_FILE
FIRST_EMPTY_LINE=$[FIRST_EMPTY_LINE+2]
sed -i "${FIRST_EMPTY_LINE}i [ZoomMedia]" $CONFIG_FILE
FIRST_EMPTY_LINE=$[FIRST_EMPTY_LINE+1]
sed -i "${FIRST_EMPTY_LINE}i DriverName=ZoomMedia.so" $CONFIG_FILE

}

echo "Post-install"

post_install
