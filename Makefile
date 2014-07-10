##########################################################################
#                                                                        #
#  Combine - an OCaml library for combinatorics                          #
#                                                                        #
#  Copyright (C) 2012-2014                                               #
#    Remy El Sibaie                                                      #
#    Jean-Christophe Filliatre                                           #
#                                                                        #
#  This software is free software; you can redistribute it and/or        #
#  modify it under the terms of the GNU Library General Public           #
#  License version 2.1, with the special exception on linking            #
#  described in file LICENSE.                                            #
#                                                                        #
#  This software is distributed in the hope that it will be useful,      #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  #
#                                                                        #
##########################################################################


TEMPORARY_DIR=_obuild
AUTO_GEN_DIR=src/auto_gen
ERROR_GEN_EXE=./$(TEMPORARY_DIR)/error_gen/error_gen.byte
NOWORK_BIN_TMP=$(TEMPORARY_DIR)/nowork/nowork.byte
NOWORK_BIN=nowork

DOC_FILES=coding-style.tex dev-manual.tex user-manual.tex methodology.tex
DOC_PDF=$(DOC_FILES:.tex=.pdf)
PDF=$(addprefix doc/pdf/, $(DOC_PDF))


all: main


init:
	ocp-build -init

main:
	ocp-build build combine

debug: 
	ocp-build build combine_debug

install: main
	ocp-build install combine combinelib
	cp _obuild/combinelib/*.cmi `ocamlfind query combinelib`


examples: main
	ocp-build build sudoku queens backslide


test: main
	ocp-build test 
	./_obuild/tests/tests.byte

uninstall:
	ocp-build -uninstall combine

clean:
	ocp-build clean

clean-all: clean
	rm -rf ocp-build.*
