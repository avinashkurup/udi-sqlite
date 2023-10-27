# udi-sqlite

Custom distribution of SQLite with enhancements tailored for `udi-service`.

## 🚀 Features

- - Statically linked with select loadable dynamic extensions.

## 🛠️ Installation Steps

1. Clone the repository
2. Dependencies for building cwalk (required for building sqlite-path extension).
        sudo apt-get install build-essential cmake
3. Install [Rust programming language](https://www.rust-lang.org/tools/install)
4. Source the cargo binaries path as instructed.
5. Install [Deno](https://docs.deno.com/runtime/manual/getting_started/installation)
6. Install [Go programming language](https://go.dev/doc/install)
7. Run `$ cd udi-sqlite` and run `$ ./make.ts`

## To test the udi-sqlite executable.

Run the command `make run-extension-test`

## Extensions included in udi-sqlite.

1. [sqlite-ulid](https://github.com/asg017/sqlite-ulid)
2. [sqlite-regex](https://github.com/asg017/sqlite-regex)
3. [sqlite-path](https://github.com/asg017/sqlite-path)
4. [sqlite-html](https://github.com/asg017/sqlite-html)
5. [sqlean-fileio](https://github.com/nalgeon/sqlean/blob/main/docs/fileio.md)
6. [sqlean-crypto](https://github.com/nalgeon/sqlean/blob/main/docs/crypto.md)

[sqlite-http](https://github.com/asg017/sqlite-http) working on a fix for this [issue](https://github.com/asg017/sqlite-http/issues/32).
