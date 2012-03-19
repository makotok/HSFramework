#!/bin/bash
cd `dirname $0`
rm -rf doc/*
luadoc -d doc hs/*.lua hs/*/*.lua
