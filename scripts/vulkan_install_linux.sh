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

# Download vulkan
wget -O "$TMP/vulkan-sdk.tar.gz" https://sdk.lunarg.com/sdk/download/latest/linux/vulkan-sdk.tar.gz
tar -xvf `$TMP/vulkan-sdk.tar.gz` -C `$LIBS/vulkan`

mv `dirname $LIBS/vulkan/1.*/.` "$LIBS/vulkan/latest"

# Clear tmp
rm -r $TMP

# Install vulkan
sh $LIBS/vulkan/*/vulkansdk