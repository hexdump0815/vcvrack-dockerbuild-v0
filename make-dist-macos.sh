#!/bin/bash

mkdir dist
for i in LICENSE-dist.txt LICENSE.txt Rack res ; do  cp -r compile/Rack/$i dist; done
mkdir dist/Bridge
cp -r compile/Bridge/VST/dist/VCV-Bridge.vst dist/Bridge
cp -r compile/Bridge/AU/dist/VCV-Bridge.component dist/Bridge
cp -r compile/community/repos dist/plugins
rm -rf dist/plugins/Befaco
cp -r compile/Befaco dist/plugins
rm -rf dist/plugins/*/src dist/plugins/*/dep dist/plugins/*/build dist/plugins/*/Makefile dist/plugins/*/README.md
strip -S dist/Rack dist/plugins/*/plugin.dylib
mkdir dist/plugins.off
for i in dist/plugins/* ; do if [ ! -f $i/plugin.dylib ]; then mv -v $i dist/plugins.off ; fi ; done
# SkJack resulted in a core dump on vcvrack exit, so turn it off for now
mv dist/plugins/SkJack dist/plugins.off
