const unified = require("unified");
const vfile = require("to-vfile");
const yaml = require("js-yaml");

// remove position unsafely (mutation)
function removePropertiesUnsafe(props) {
  function removeRecursively(node) {
    props.forEach(prop => delete node[prop]);

    if (node.children) {
      node.children.forEach(removeRecursively);
    }

    return node;
  }

  return function(tree) {
    return removeRecursively(tree);
  };
}

// remove newline nodes unsafely (mutation)
function removeNewlineNodesUnsafe() {
  function removeRecursively(node) {
    if (node.children) {
      node.children = node.children
        .filter(node => node.value !== "\n")
        .map(removeRecursively);
    }
    return node;
  }

  return removeRecursively;
}

const parseWithFrontmatter = unified()
  .use(require("remark-parse"))
  .use(require("remark-frontmatter"), ["yaml"])
  .use(function() {
    // TODO: is there a less hacky way to do this? :\
    var frontmatter = {};

    this.Compiler = function(tree, file) {
      return JSON.stringify({
        frontMatter: frontmatter,
        content: tree
      });
    };

    return function(tree) {
      frontmatter = yaml.safeLoad(tree.children[0].value);
    };
  })
  .use(require("remark-rehype"))
  .use(removePropertiesUnsafe, ["position"])
  .use(removeNewlineNodesUnsafe)
  .process(vfile.readSync(process.argv[2]), function(err, file) {
    console.log(String(file));
  });
