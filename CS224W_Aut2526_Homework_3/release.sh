#!/bin/bash

# Download and compile flatex from https://ctan.org/pkg/flatex
# If you're on mac, this should work:
#   curl https://ctan.math.washington.edu/tex-archive/support/flatex/flatex.c > flatex.c && cc flatex.c -o flatex && mv flatex /usr/local/bin
#
# Run this with:
#   sh release.sh <hw-dir>

if ! command -v flatex &> /dev/null ; then
  echo "flatex could not be found"
  exit 1
fi

if [[ $# -eq 0 ]]; then
  echo "usage: sh release.sh <homework folder>"
  exit 1
fi

if [[ ! -d $1 ]]; then
  echo "error: invalid homework directory"
  exit 1
fi

cp "$1/main.tex" "$1/temp.tex"
sed -i '' -E "s/solutions/problems/g" "$1/main.tex"
flatex -q "$1/main.tex" &> /dev/null
mv "$1/main.flt" "$1/main.tex"

zip -r "$1-template.zip" "$1" --exclude "$1/problems/*" "$1/solutions/*" "$1/temp.tex"

cp "$1/temp.tex" "$1/main.tex"
sed -i '' -E "s/problems/solutions/g" "$1/main.tex"
flatex -q "$1/main.tex" &> /dev/null
mv "$1/main.flt" "$1/main.tex"

zip -r "$1-solutions.zip" "$1" --exclude "$1/problems/*" "$1/solutions/*" "$1/temp.tex"
