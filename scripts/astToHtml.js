const fs = require("fs");
const uglify = require("uglify-js");

function main(input) {
  const body = JSON.parse(fs.readFileSync(input));
  const frontMatter = body.frontMatter;

  const startScript = uglify.minify(`
    (function() {
      var app = Elm.Main.fullscreen(${JSON.stringify(body)});
      app.ports.setTitle.subscribe(function(title) { document.title = title });
    })();
  `).code;

  console.log(
    "<html><head>" +
      '<link rel="stylesheet" href="/css/reset.css">' +
      '<link href="https://fonts.googleapis.com/css?family=Josefin+Sans|Vollkorn" rel="stylesheet">' +
      ("<title>" + frontMatter.title + "</title>") +
      '</head><body><script src="/index.js"></script><script>' +
      startScript +
      "</script></body></html>"
  );
}

main(process.argv[2]);
