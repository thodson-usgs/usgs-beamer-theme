MAKEFLAGS  := -j 1
PACKAGE_STY = $(wildcard source/*)
DEMO_SRC    = demo/demo.tex demo/demo.bib
DEMO_PDF    = demo/demo.pdf
DOC_PDF     = doc/usgstheme.pdf

DESTDIR     ?= $(shell kpsewhich -var-value=TEXMFHOME)
INSTALL_DIR  = $(DESTDIR)/tex/latex/usgs
DOC_DIR      = $(DESTDIR)/doc/latex/usgs
CACHE_DIR   := $(shell pwd)/.latex-cache

COMPILE_TEX := latexmk -xelatex -output-directory=$(CACHE_DIR)
export TEXINPUTS:=$(shell pwd):$(shell pwd)/source:${TEXINPUTS}

.PHONY: sty demo clean install uninstall clean-cache clean-sty

all:

demo: $(DEMO_PDF)

clean: clean-cache

install:
	@mkdir -p $(INSTALL_DIR)
	@cp -r $(PACKAGE_STY) $(INSTALL_DIR)

uninstall:
	@rm -f "$(addprefix $(INSTALL_DIR)/, $(PACKAGE_STY))"
	@rmdir "$(INSTALL_DIR)"

clean-cache:
	@rm -rf "$(CACHE_DIR)"

$(CACHE_DIR):
	@mkdir -p $(CACHE_DIR)

$(PACKAGE_STY): clean-cache $(CACHE_DIR)
	@cp $(addprefix $(CACHE_DIR)/,$(PACKAGE_STY)) .

$(DEMO_PDF): $(DEMO_SRC) $(PACKAGE_STY) | clean-cache $(CACHE_DIR)
	@cd $(dir $(DEMO_SRC)) && $(COMPILE_TEX) $(notdir $(DEMO_SRC))
	@cp $(CACHE_DIR)/$(notdir $(DEMO_PDF)) $(DEMO_PDF)
