#!/bin/sh

qemu-system-x86_64 -m 2048 -enable-kvm -boot order=d -drive format=raw,file=/mnt/hd/vm/$1.img
