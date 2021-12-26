#!/bin/bash
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`

LIBS="$SCRIPT_PATH/../libs"
TMP="$SCRIPT_PATH/tmp"

if [ -d "$LIBS/vulkan/latest" ]; then
    echo "Vulkan already installed, to reinstall it please use \`vulkan_delete.sh\`."
    exit -1
fi

mkdir $LIBS
mkdir $LIBS/vulkan
mkdir $TMP

wget -O "$TMP/vulkan-sdk.dmg" https://sdk.lunarg.com/sdk/download/latest/mac/vulkan-sdk.dmg