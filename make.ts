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
// sudo apt-get install build-essential cmake

if (!$.fs.existsSync("sqlite-ulid")) {
  await $`git clone https://github.com/asg017/sqlite-ulid`;
}
await $`cd sqlite-ulid && make static-release`;

if (!$.fs.existsSync("sqlite-regex")) {
  await $`git clone https://github.com/asg017/sqlite-regex`;
}
await $`cd sqlite-regex && make static-release`;

if (!$.fs.existsSync("sqlean")) {
  await $`git clone https://github.com/nalgeon/sqlean`;
}

if (!$.fs.existsSync("sqlite-html")) {
  await $`git clone https://github.com/asg017/sqlite-html`;
}
await $`cd sqlite-html && make `

// Note: manually downloaded the cwalk zip and unzip in sqlite-path dir.
// ideally this should work from the cwalk submodule. raised this issue.
// https://github.com/asg017/sqlite-path/issues/9
if (!$.fs.existsSync("sqlite-path")) {
  await $`git clone https://github.com/asg017/sqlite-path`;
}
if (!$.fs.existsSync("sqlite-path/cwalk/cmake")) {
  await $`make download_cwalk`
}
await $`cd sqlite-path && make dist`
await $`make sqlite_path`
await $`make sqlite-path/dist/libsqlite_path0.a`

await $`make fileio_static_lib`

const destExe = `udi-sqlite`;
await $`make ${destExe}`;
await Deno.chmod(destExe, 0o666);
