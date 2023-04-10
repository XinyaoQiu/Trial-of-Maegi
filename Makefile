ELM = elm make
ELM_DBG = elm make --debug

SRC = src/Main.elm
OBJ = assets/main.js
OBJ_DBG = assets/debug.js

all: release debug

release: $(OBJ)

debug: $(OBJ_DBG)

$(OBJ): $(SRC)
	$(ELM) $^ --output=$@

$(OBJ_DBG): $(SRC)
	$(ELM_DBG) $^ --output=$@

clean:
	-rm -f $(OBJ) $(OBJ_DBG)

.PHONY: all clean
