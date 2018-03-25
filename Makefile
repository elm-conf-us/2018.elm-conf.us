ELM=$(wildcard src/*.elm src/**/*.elm)
MARKDOWN=$(wildcard content/*.md content/**/*.md)
MARKDOWN_AST=$(MARKDOWN:content/%.md=public/%.json)
MARKDOWN_HTML=$(MARKDOWN_AST:public/%.json=public/%.html)

public: $(MARKDOWN_AST) $(MARKDOWN_HTML) public/index.js

public/%.json: content/%.md scripts/mdToAst.js node_modules
	mkdir -p $(@D)
	node scripts/mdToAst.js $< > $@

public/%.html: public/%.json scripts/astToHtml.js node_modules
	node scripts/astToHtml.js $< > $@

public/index.js: node_modules elm-stuff $(ELM)
	mkdir -p $(@D)
	./node_modules/.bin/elm-make --output=$@ src/Main.elm
	./node_modules/.bin/uglifyjs --compress --output=$@.min $@
	mv $@.min $@

# plumbing

clean:
	rm -rf node_modules elm-stuff public

node_modules: package.json
	npm install
	touch -m $@

elm-stuff: elm-package.json node_modules
	./node_modules/.bin/elm-package install --yes
	touch -m $@
