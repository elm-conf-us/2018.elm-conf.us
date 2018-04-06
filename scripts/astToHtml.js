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
        <!-- icons -->
        <link rel="icon" type="image/png" href="/images/icon-browser.png" sizes="16x16">
        <link rel="icon" type="image/png" href="/images/icon-taskbar.png" sizes="32x32">
        <link rel="icon" type="image/png" href="/images/icon-desktop.png" sizes="96x96">

        <!-- mobile -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <!-- page metadata -->
        <title>${frontMatter.title}</title>

        <link rel="stylesheet" href="/css/reset.css">
        <link href="https://fonts.googleapis.com/css?family=Josefin+Sans|Vollkorn:400,400i,600" rel="stylesheet">
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
