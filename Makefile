ELM=$(shell find src -name '*.elm')
ELM_FLAGS=
ENVIRONMENT=production

MARKDOWN=$(wildcard content/*.md content/**/*.md)
MARKDOWN_AST=$(patsubst %/index/index.json,%/index.json,$(MARKDOWN:content/%.md=public/%/index.json))
MARKDOWN_HTML=$(MARKDOWN_AST:public/%.json=public/%.html)

CSS_SRC=$(wildcard static/*.css static/**/*.css)
CSS=$(CSS_SRC:static/%.css=public/%.css)

public: $(MARKDOWN_AST) $(MARKDOWN_HTML) $(CSS) public/index.js

public/index.json: content/index.md scripts/mdToAst.js node_modules
	@mkdir -p $(@D)
	node scripts/mdToAst.js $< > $@

public/%/index.json: content/%.md scripts/mdToAst.js node_modules
	@mkdir -p $(@D)
	node scripts/mdToAst.js $< > $@

public/%.html: public/%.json scripts/astToHtml.js node_modules
	node scripts/astToHtml.js $< > $@

public/%.css: static/%.css node_modules
	@mkdir -p $(@D)
	./node_modules/.bin/node-sass --output-style compressed $< > $@

public/index.js: node_modules elm-stuff $(ELM) generated/Route.elm
	@mkdir -p $(@D)
	./node_modules/.bin/elm-make ${ELM_FLAGS} --warn --output=$@ src/Main.elm
ifeq (${ENVIRONMENT},production)
	./node_modules/.bin/babel --plugins elm-pre-minify $@ | ./node_modules/.bin/uglifyjs --compress --mangle > $@.min
	mv $@.min $@
else
endif

# code generation

generated/Route.elm: $(MARKDOWN) scripts/routing.py
	@mkdir -p $(@D)
	@python ./scripts/routing.py lookup \
		--module-name=Route \
		--sources='${MARKDOWN}' \
		--jsons='${MARKDOWN_AST}' \
		--htmls='${MARKDOWN_HTML}' \
		--output-if-changed=$@

# plumbing

clean:
	rm -rf node_modules elm-stuff public generated

node_modules: package.json
	npm install
	touch -m $@

elm-stuff: elm-package.json node_modules
	./node_modules/.bin/elm-package install --yes
	touch -m $@
