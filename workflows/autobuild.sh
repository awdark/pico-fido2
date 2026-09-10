#!/bin/bash
set -e

mkdir -p out

echo "::group::Build ESP32-S3"
export ESP_PRODUCT="esp32s3"
export ESP_NAME="ESP32-S3"

git submodule update --init --recursive

# Set up ESP-IDF v5.5
git clone --recursive https://github.com/espressif/esp-idf.git -b v5.5 --depth=1 esp-idf-dir
cd esp-idf-dir
./install.sh $ESP_PRODUCT
. ./export.sh
cd ..

# Build firmware
idf.py set-target $ESP_PRODUCT
idf.py all

# Merge into single flashable binary
cd build
esptool.py --chip $ESP_NAME merge_bin -o pico_fido_esp32s3.bin @flash_args
cp pico_fido_esp32s3.bin ../out/
cd ..

echo "::endgroup::"
