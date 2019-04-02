#!/bin/bash

# exit on errors
set -e

MYARCH=`uname -m`

mkdir compile
cd compile
if [ "$MYARCH" == "armv7l" ] || [ "$MYARCH" == "aarch64" ]; then
  git clone https://github.com/nemequ/simde.git
  cd simde
  # git checkout operator-overloading
  # this is the version i used this script last with
  git checkout 0ab31983d2407b76b1de7078a5628c90f6dd39cf
  cd ..
fi
git clone https://github.com/Rcomian/Rack.git
cd Rack
# this is the version i used this script last with
git checkout 116d119468d8f1ba5bbaa0be1b1a31cb6bf73b38
git submodule update --init --recursive
if [ -f ../../Rack.$MYARCH.patch ]; then
  patch -p1 < ../../Rack.$MYARCH.patch
fi
patch -p1 < ../../more-samplerates.patch
if [ -f ../../Rack-nanovg.$MYARCH.patch ]; then
  cd dep/nanovg
  patch -p1 < ../../../../Rack-nanovg.$MYARCH.patch
  cd ../..
fi
cd ..
git clone https://github.com/VCVRack/community.git
cd community
# this is the version i used this script last with
git checkout 2421d67a0bae4264060ea3560a95e77a857b6f89
git submodule update --init --recursive
cd repos/AudibleInstruments
git checkout v0.6
cd eurorack
git checkout 9d30467bb157c64d015e2e2b7de871ad69caf88b
cd ../../..
if [ -f ../../community-Fundamental.$MYARCH.patch ]; then
  cd repos/Fundamental
  patch -p1 < ../../../../community-Fundamental.$MYARCH.patch
  cd ../..
fi
cd ..
git clone https://github.com/VCVRack/Befaco.git
cd Befaco
# this is the version i used this script last with
git checkout 0febbea1c21c7fac66b427be09829f0e37a70a3a
cd ..
git clone https://github.com/VCVRack/Bridge.git
cd Bridge
# this is the version i used this script last with
git checkout 2b695859d67fee27fa02383f84004a5dba786f23
if [ -d ../../vst2-sdk ]; then
  cp -r ../../vst2-sdk/* VST
fi
cd ..
if [ "$MYARCH" == "armv7l" ] || [ "$MYARCH" == "aarch64" ]; then
  cd Rack/include
  ln -s ../../simde/simde/hedley.h
  ln -s ../../simde/simde/simde-arch.h
  ln -s ../../simde/simde/simde-common.h
  ln -s ../../simde/simde/x86
  cd ../..
  find community/repos/squinkylabs-plug1 -type f -exec ../simde-ify.sh {} \;
  find community/repos/Valley -type f -exec ../simde-ify.sh {} \;
  cd community/repos/Valley
  patch -p1 < ../../../../Valley-simde-compile-hack.patch
  cd ../../..
fi
cp ../resample_neon.h ../build.sh .
