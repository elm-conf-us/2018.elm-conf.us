MARKDOWN=$(wildcard content/*.md)
MARKDOWN_AST=$(MARKDOWN:content/%.md=public/%.json)

public: $(MARKDOWN_AST)

public/%.json: content/%.md scripts/mdToAst.js node_modules
	mkdir -p $(@D)
	node scripts/mdToAst.js $< > $@

node_modules: package.json
	npm install
	touch -m $@
