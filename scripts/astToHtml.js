const fs = require("fs");
const uglify = require("uglify-js");
const minify = require("html-minifier").minify;

function main(input) {
  const body = JSON.parse(fs.readFileSync(input));
  const frontMatter = body.frontMatter;

  const startScript = uglify.minify(`
    (function() {
      var app = Elm.Main.fullscreen(${JSON.stringify(body)});
      app.ports.setTitle.subscribe(function(title) { document.title = title });
    })();
  `).code;

  const html = minify(
    `
    <!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <!-- TODO: make these stylesheets load async -->
        <link rel="stylesheet" href="/css/reset.css">
        <link href="https://fonts.googleapis.com/css?family=Josefin+Sans|Vollkorn:400,400i,600" rel="stylesheet">
        <title>${frontMatter.title}</title>
      </head>
      <body>
        <script src="/index.js"></script>
        <script>${startScript}</script>
      </body>
    </html>
    `,
    {
      collapseWhitespace: true,
      collapseInlineTagWhitespace: true,
      html5: true,
      removeAttributeQuotes: true,
      removeEmptyAttributes: true,
      removeEmptyElements: true,
      removeScriptTypeAttributes: true,
      removeStyleLinkTypeAttributes: true,
      useShortDoctype: true,
      removeComments: true
    }
  );

  console.log(html);
}

main(process.argv[2]);
