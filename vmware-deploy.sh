#!/bin/sh

source $1

govc ls /Datacenter/vm | grep -q "$NEWVM" &&
	govc vm.info "$NEWVM" && exit 0

govc vm.clone -vm "$TEMP" \
	-ds="$DS" -host="$HOST" \
	-c=$CPU -m=$MEM \
	-on=false -annotation="$DESC" "$NEWVM"

govc vm.customize -vm $NEWVM -ip $IP -netmask $MASK \
	-gateway $GATE -dns-server "$DNS" \
	"$SPEC"

govc vm.power -on "$NEWVM"

# open "$(govc vm.console "$NEWVM")"
