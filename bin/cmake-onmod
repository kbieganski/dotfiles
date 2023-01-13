#!/bin/sh

while :; do
    cmake . -DCMAKE_BUILD_TYPE=Debug
    if make; then
	bin/Debug/vtest
    fi;
    inotifywait -qq -e modify CMakeLists.txt src/*{cpp,h}
    echo -e "\n\n\n"
done
