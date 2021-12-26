#!bin/bash
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
LIBS="$SCRIPT_PATH/../libs"

rm -r "$LIBS/vulkan/latest"