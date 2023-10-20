#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-run --allow-sys

import $ from "https://deno.land/x/dax@0.30.1/mod.ts";

const srcURL = `https://www.sqlite.org/2023/sqlite-amalgamation-3430200.zip`;
const srcFile = $.path.basename(srcURL);

if (!$.fs.existsSync(srcFile)) {
  await $`curl -L --output ${srcFile} ${srcURL}`;
  await $`unzip -j ${srcFile}`;
}

// make sure Rust and other deps are installed
// sudo apt-get update
// sudo apt-get install libclang-dev

if (!$.fs.existsSync("sqlite-ulid")) {
  await $`git clone https://github.com/asg017/sqlite-ulid`;
}
await $`cd sqlite-ulid && make static-release`;

if (!$.fs.existsSync("sqlean")) {
  await $`git clone https://github.com/nalgeon/sqlean`;
}

const destExe = `udi-sqlite`;
await $`make ${destExe}`;
await Deno.chmod(destExe, 0o666);
