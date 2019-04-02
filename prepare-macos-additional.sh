#!/bin/bash

# exit on errors
set -e

cd compile
cd community/repos
cd BOKONTEPByteBeatMachine
patch -p1 < ../../../../community-BOKONTEPByteBeatMachine.macos.patch
cd ../Fundamental
patch -p1 < ../../../../community-Fundamental.macos.patch
cd ../TriggerFish-Elements
patch -p1 < ../../../../community-TriggerFish-Elements.macos.patch
cd ../../..
if [ -d ../au-sdk ]; then
  cd Bridge
  cp -r ../../au-sdk/* AU
  patch -p1 < ../../Bridge.macos.patch
  cd ..
fi
rm build.sh
cp ../build-macos.sh .
