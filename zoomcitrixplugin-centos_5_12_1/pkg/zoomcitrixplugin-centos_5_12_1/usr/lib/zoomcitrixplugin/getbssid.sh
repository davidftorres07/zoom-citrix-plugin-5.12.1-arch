DEVICE_LIST=`iw dev | awk '$1=="Interface"{print $2}'`
for d in $DEVICE_LIST ; do
	bssid=`iwconfig ${d} | sed -n 's/.*Access Point: \([0-9\:A-F]\{17\}\).*/\1/p'`
	if [ ! -z "$bssid" ]; then
		echo $bssid
	fi
done
