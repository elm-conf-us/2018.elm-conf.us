MARKDOWN=$(wildcard content/*.md)
MARKDOWN_AST=$(MARKDOWN:content/%.md=public/%.json)

public: $(MARKDOWN_AST)

public/%.json: content/%.md scripts/mdToAst.js node_modules
	mkdir -p $(@D)
	node scripts/mdToAst.js $< > $@

# plumbing

clean:
	rm -rf node_modules elm-stuff public

node_modules: package.json
	npm install
	touch -m $@

elm-stuff: elm-package.json node_modules
	./node_modules/.bin/elm-package install --yes
