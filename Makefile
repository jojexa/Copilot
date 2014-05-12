# Build all the relevant packages in order.

CORE=copilot-core
LANG=copilot-language
LIB=copilot-libraries
SBV=copilot-sbv
C99=copilot-c99
CBMC=copilot-cbmc
COPILOT=Copilot

ALLDIR := $(CORE) $(LANG) $(LIB) $(SBV) $(C99) $(CBMC) $(COPILOT)

DISSTR=dist-
DIST := $(patsubst %, $(DISSTR)%, $(ALLDIR))
UPSTR=upload-
UPLOAD := $(patsubst %, $(UPSTR)%, $(ALLDIR))

CB=cabal
D=dist

all:
	$(CB) install ../$(CORE) ../$(LANG) ../$(LIB) ../$(SBV) ../$(C99) ../$(CBMC) $(COPILOT)

# Get the repos
.PHONY: get
get:
	git clone https://github.com/leepike/copilot-core.git ../$(CORE)
	git clone https://github.com/leepike/copilot-c99.git ../$(C99)
	git clone https://github.com/leepike/copilot-sbv.git ../$(SBV)
	git clone https://github.com/leepike/copilot-cbmc.git ../$(CBMC)
	git clone https://github.com/leepike/copilot-language.git ../$(LANG)
	git clone https://github.com/leepike/copilot-libraries.git ../$(LIB)

.PHONY: clean
clean:
	rm -rf $(CB)

.PHONY: veryclean
veryclean: clean $(CORE)/$(D) $(LANG)/$(D) $(LIB)/$(D) $(SBV)/$(D) $(C99)/$(D) $(CBMC)/$(D)
	rm -rf $(D)

.PHONY:
%/$(D):
	rm -rf ../$@

.PHONY: dist
dist: $(DIST)

.PHONY: $(DIST)
$(DIST):
	cd $(subst $(DISSTR),../, $@) && cabal sdist && cabal check

.PHONY: upload
upload: $(UPLOAD)

.PHONY: $(UPLOAD)
$(UPLOAD):
	cd $(subst $(UPSTR),../, $@) && cabal upload dist/*.gz
