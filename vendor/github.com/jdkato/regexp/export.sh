#!/bin/sh

FROM="$HOME/src/matloob.io/regexp"
TO="$HOME/go/src/regexp"

cp $FROM/*.go $TO/
cp $FROM/syntax/*.go $TO/syntax/
cp $FROM/internal/dfa/*.go $TO/internal/dfa
cp $FROM/internal/input/*.go $TO/internal/input/

sed -i .bak -e "s/matloob.io\///g" $TO/*.go $TO/internal/dfa/*.go $TO/internal/input/*.go
rm $TO/*.go.bak $TO/internal/dfa/*.go.bak $TO/internal/input/*.go.bak
