#!/bin/bash

# exit on errors
set -e

MYWD=`pwd`

cd $MYWD/compile/Rack
make -j2 clean
make -j2 dep
make -j2
cd $MYWD/compile/community/repos
# do not exit on errors during plugin compiles
set +e
for i in *; do echo $i; RACK_DIR=$MYWD/compile/Rack make -C $i -j2 clean ; done
for i in *; do echo $i; RACK_DIR=$MYWD/compile/Rack make -C $i -j2 dep ; done
for i in *; do echo $i; RACK_DIR=$MYWD/compile/Rack make -C $i -j2 ; done
# exit on errors 
set -e
cd ../..
RACK_DIR=$MYWD/compile/Rack make -C Befaco -j2 clean
RACK_DIR=$MYWD/compile/Rack make -C Befaco -j2 dep
RACK_DIR=$MYWD/compile/Rack make -C Befaco -j2
cd Bridge/VST
if [ -d public.sdk ]; then
  VST2_SDK=$MYWD/compile/Bridge/VST RACK_DIR=$MYWD/compile/Rack make -j2 clean
  VST2_SDK=$MYWD/compile/Bridge/VST RACK_DIR=$MYWD/compile/Rack make -j2 dist
fi
cd ../AU
if [ -d AUPublic ]; then
AU_SDK=$MYWD/compile/Bridge/AU RACK_DIR=$MYWD/compile/Rack make -j2 clean
AU_SDK=$MYWD/compile/Bridge/AU RACK_DIR=$MYWD/compile/Rack make -j2 dist
cd ../..
