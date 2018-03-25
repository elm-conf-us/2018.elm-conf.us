const fs = require("fs");

function main(input) {
  const frontMatter = JSON.parse(fs.readFileSync(input)).frontMatter;

  console.log(
    "<html><head><title>" +
      frontMatter.title +
      '</title><script src="/index.js"></head><body></body></html>'
  );
}

main(process.argv[2]);
