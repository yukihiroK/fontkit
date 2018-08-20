SOURCES = $(shell find src)

SHELL := /bin/bash
PATH := ./node_modules/.bin:$(PATH)

# all: index.js base.js
all: lib umd

src/opentype/shapers/trie.json:
	babel-node --no-babelrc --presets=env --plugins=transform-decorators-legacy,transform-class-properties,transform-runtime src/opentype/shapers/generate-data.js

src/opentype/shapers/trieUse.json:
	babel-node --no-babelrc --presets=env --plugins=transform-decorators-legacy,transform-class-properties,transform-runtime src/opentype/shapers/gen-use.js

src/opentype/shapers/trieIndic.json:
	babel-node --no-babelrc --presets=env --plugins=transform-decorators-legacy,transform-class-properties,transform-runtime src/opentype/shapers/gen-indic.js

#####

shapers:
	mkdir -p lib/opentype/shapers/
	mkdir -p es/opentype/shapers/

trie.json: shapers src/opentype/shapers/trie.json
	cp src/opentype/shapers/trie.json lib/opentype/shapers/trie.json
	cp src/opentype/shapers/trie.json es/opentype/shapers/trie.json

trieUse.json: shapers src/opentype/shapers/trieUse.json
	cp src/opentype/shapers/trieUse.json lib/opentype/shapers/trieUse.json
	cp src/opentype/shapers/trieUse.json es/opentype/shapers/trieUse.json

trieIndic.json: shapers src/opentype/shapers/trieIndic.json
	cp src/opentype/shapers/trieIndic.json lib/opentype/shapers/trieIndic.json
	cp src/opentype/shapers/trieIndic.json es/opentype/shapers/trieIndic.json

copy-extra-json-assets: shapers trie.json trieUse.json trieIndic.json
	cp src/opentype/shapers/indic.json lib/opentype/shapers/indic.json
	cp src/opentype/shapers/indic.json es/opentype/shapers/indic.json

	cp src/opentype/shapers/use.json lib/opentype/shapers/use.json
	cp src/opentype/shapers/use.json es/opentype/shapers/use.json

lib: $(SOURCES) trie.json trieUse.json trieIndic.json
	babel --no-babelrc  \
	      --presets=env \
				--plugins=transform-decorators-legacy,transform-class-properties,transform-runtime \
				src --out-dir lib
	babel src --out-dir es

# trie.json: src/opentype/shapers/trie.json
# 	cp src/opentype/shapers/trie.json trie.json
#
# trieUse.json: src/opentype/shapers/trieUse.json
# 	cp src/opentype/shapers/trieUse.json trieUse.json
#
# trieIndic.json: src/opentype/shapers/trieIndic.json
# 	cp src/opentype/shapers/trieIndic.json trieIndic.json

umd: $(SOURCES) trie.json trieUse.json trieIndic.json copy-extra-json-assets lib
	rollup --config --file umd.js

index.js: $(SOURCES) trie.json trieUse.json trieIndic.json
	rollup --config --sourcemap --input src/index.js --file index.js

base.js: $(SOURCES) trie.json trieUse.json trieIndic.json
	rollup --config --sourcemap --input src/base.js --file base.js

clean:
	rm -rf                                \
    lib/                                \
		es/                                 \
    index.js                            \
    base.js                             \
		trie.json                           \
		trieIndic.json                      \
		trieUse.json                        \
		src/opentype/shapers/trie.json      \
		src/opentype/shapers/trieUse.json   \
		src/opentype/shapers/use.json       \
		src/opentype/shapers/trieIndic.json \
		src/opentype/shapers/indic.json
