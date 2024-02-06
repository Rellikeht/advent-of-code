#!/usr/bin/env sh
ocamlfind ocamlc \
    -package yojson -linkpkg \
    data_parser.ml -o data_parser
