#!/bin/sh

export PATH=~/bin:~/.local/bin:~/.cargo/bin:$PATH

systemctl --user import-environment PATH HOME
