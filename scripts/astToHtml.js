const fs = require("fs");

function main(input) {
  const body = JSON.parse(fs.readFileSync(input));
  const frontMatter = body.frontMatter;

  startScript = "Elm.Main.fullscreen(" + JSON.stringify(body) + ")";

  console.log(
    "<html><head><title>" +
      frontMatter.title +
      '</title></head><body><script src="/index.js"></script><script>' +
      startScript +
      "</script></body></html>"
  );
}

main(process.argv[2]);
