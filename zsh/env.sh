#!/bin/sh

export PATH=~/bin:~/.local/bin:$PATH

systemctl --user import-environment PATH HOME
