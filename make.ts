#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-run --allow-sys

import $ from "https://deno.land/x/dax@0.30.1/mod.ts";

const srcURL = `https://www.sqlite.org/2023/sqlite-amalgamation-3430200.zip`;
const srcFile = $.path.basename(srcURL);
// Note: Set to the same filename in Makefile variable EXTENSION_JSON_FILENAME
const repo_sub_extensions_filename = `repo_sub_extensions.json`

// Note: Initialize this object with the test directories/files in the cloned repo.
// Remove python tests, because the tests will run against the sqlite3 python package,
// not udi-sqlite executable.
const repo_sub_extensions: {
  [key: string]: string[] | { extensions: string[], sql_test_directory?: string, sql_test_file?: string } 
} = {
  "https://github.com/nalgeon/sqlean": {extensions: ["fileio", "crypto"], sql_test_directory: "sqlean/test"}, // No test_directory specified; assume a default
  "https://github.com/asg017/sqlite-ulid": {
    extensions: ["ulid"],
    sql_test_file: "sqlite-ulid/test.sql"
  },
  "https://github.com/asg017/sqlite-regex": {extensions: ["regex"], }, // No test_directory specified
  "https://github.com/asg017/sqlite-path": {extensions: ["path"], },   // No test_directory specified
  "https://github.com/asg017/sqlite-html": {extensions: ["html"], },
};

// Convert the object to a JSON string
const jsonString = JSON.stringify(repo_sub_extensions, null, 2); // 2 spaces for indentation

// Write the JSON string to a file
await Deno.writeTextFile(repo_sub_extensions_filename, jsonString);

// Adjust the file permissions to read-only
await Deno.chmod(repo_sub_extensions_filename, 0o444); // 0o444 represents read-only permissions

// Traverse the object
for (const [repo, extensions] of Object.entries(repo_sub_extensions)) {
  const repoName = repo.split('/').pop();

  console.log(`Downloading Repo: ${repo}`);

  switch (repoName) {
    case 'sqlean':
      if (!$.fs.existsSync("sqlean")) {
        await $`git clone https://github.com/nalgeon/sqlean`;
        await $`cd sqlean && git checkout tags/0.21.8 && git checkout -b release_0_21_8 tags/0.21.8`;
      }
      break;

    case 'sqlite-ulid':
      if (!$.fs.existsSync("sqlite-ulid")) {
        await $`git clone https://github.com/asg017/sqlite-ulid`;
      }
      await $`cd sqlite-ulid && make static-release`;
      break;

    case 'sqlite-regex':
      if (!$.fs.existsSync("sqlite-regex")) {
        await $`git clone https://github.com/asg017/sqlite-regex`;
      }
      await $`cd sqlite-regex && make static-release`;
      break;

    case 'sqlite-path':
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

      // Figure out why?
      await $`make fileio_static_lib`
      break;

    case 'sqlite-html':
      if (!$.fs.existsSync("sqlite-html")) {
        await $`git clone https://github.com/asg017/sqlite-html`;
      }
      await $`make prepare && make static_lib`
      break;

    // ... Add more cases if necessary

    default:
      console.log(`No logic defined for repo: ${repoName}`);
      break;
  }
  if (!Array.isArray(extensions) && extensions.sql_test_directory) {
    console.log(`Using test directory: ${extensions.sql_test_directory}`);
  }
}

await $`cd udi-tap && make`

const destExe = `udi-sqlite`;
await $`make ${destExe}`;
//await Deno.chmod(destExe, 0o666);
await $`chmod +x ${destExe}`    // Dont make this Linux specific.

await $`make run-extension-test`
await $`make run-udi-tap`

// The type of `urls` is now a readonly tuple: readonly ["https://example.com", "https://github.com/asg017/sqlite-ulid", "https://deno.land"]


// if (!$.fs.existsSync(srcFile)) {
//   await $`curl -L --output ${srcFile} ${srcURL}`;
//   await $`unzip -j -o ${srcFile}`;
// }


// // make sure Rust and other deps are installed
// // sudo apt-get update
// // sudo apt-get install libclang-dev
// // sudo apt-get install build-essential cmake

// if (!$.fs.existsSync("sqlite-ulid")) {
//   await $`git clone https://github.com/asg017/sqlite-ulid`;
// }
// await $`cd sqlite-ulid && make static-release`;

// if (!$.fs.existsSync("sqlite-regex")) {
//   await $`git clone https://github.com/asg017/sqlite-regex`;
// }
// await $`cd sqlite-regex && make static-release`;

// // Note: Fixing a release as we're patching the sqlean fileio default initialization function name in shell.c
// if (!$.fs.existsSync("sqlean")) {
//   await $`git clone https://github.com/nalgeon/sqlean`;
//   await $`cd sqlean && git checkout tags/0.21.8 && git checkout -b release_0_21_8 tags/0.21.8`
// }

// // Note: manually downloaded the cwalk zip and unzip in sqlite-path dir.
// // ideally this should work from the cwalk submodule. raised this issue.
// // https://github.com/asg017/sqlite-path/issues/9
// if (!$.fs.existsSync("sqlite-path")) {
//   await $`git clone https://github.com/asg017/sqlite-path`;
// }
// if (!$.fs.existsSync("sqlite-path/cwalk/cmake")) {
//   await $`make download_cwalk`
// }
// await $`cd sqlite-path && make dist`
// await $`make sqlite_path`
// await $`make sqlite-path/dist/libsqlite_path0.a`

// await $`make fileio_static_lib`

// if (!$.fs.existsSync("sqlite-html")) {
//   await $`git clone https://github.com/asg017/sqlite-html`;
// }
// await $`make prepare && make static_lib`

// await $`cd udi-tap && make`

// const destExe = `udi-sqlite`;
// await $`make ${destExe}`;
// await Deno.chmod(destExe, 0o666);
