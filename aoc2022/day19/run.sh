#!/usr/bin/env sh

if [ -n "$1" ]
then dune exec data_parser "$1"
else dune exec data_parser
fi
