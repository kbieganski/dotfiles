#!/bin/sh

RANDOM_NAME=$(mktemp XXXXXXXX)

date > $RANDOM_NAME
curl ipecho.net/plain >> $RANDOM_NAME

for TARGET_DIR in "$@"; do
	cp -f $RANDOM_NAME $TARGET_DIR/ip_$(hostname).txt
done

rm $RANDOM_NAME
