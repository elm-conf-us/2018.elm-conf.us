const fs = require("fs");

function main(input) {
  const body = JSON.parse(fs.readFileSync(input));
  const frontMatter = body.frontMatter;

  console.log(
    "<html><head><title>" +
      frontMatter.title +
      '</title><script src="/index.js"></head><body>' +
      '<div id="data" data-page="' +
      JSON.stringify(body).replace(/"/g, "&quot;", -1) +
      '"></div></body></html>'
  );
}

main(process.argv[2]);
