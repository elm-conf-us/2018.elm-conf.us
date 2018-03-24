var vfile = require("to-vfile");
var report = require("vfile-reporter");
var unified = require("unified");
var markdown = require("remark-parse");
var remark2rehype = require("remark-rehype");
var doc = require("rehype-document");
var format = require("rehype-format");
var stringify = require("rehype-stringify");
var u = require("unist-builder");
var yaml = require("js-yaml");

unified()
  .use(markdown)
  .use(require("remark-frontmatter"), ["yaml"])
  // .use(function() {
  //   return function(tree, file) {
  //     console.log(tree);
  //   };
  // })
  .use(remark2rehype, {
    allowDangerousHTML: true,
    handlers: {
      yaml: function(_config, yamlNode, _html) {
        return u("element", {
          tagName: "div",
          properties: {
            id: "meta",
            "data-meta": JSON.stringify(yaml.safeLoad(yamlNode.value))
          }
        });
      }
    }
  })
  .use(doc, { title: "🙌" })
  .use(format)
  .use(stringify)
  .process(vfile.readSync("content/index.md"), function(err, file) {
    console.error(report(err || file));
    console.log(String(file));
  });
