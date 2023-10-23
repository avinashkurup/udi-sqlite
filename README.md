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
6. Run `$ cd udi-sqlite` and run `$ ./make.ts`

## To test the udi-sqlite executable.

Run the command `cat udi-sqlite_test.sql | ./udi-sqlite`
the value printed from the command `echo $?` should be 0 (success).


## TODO.
1. Fix issue with unzip of cwalk stable zip file in the sqlite-path directory make.ts
2. CMake Warning: (Fixed)
        Ignoring extra path from command line:
        ".."
   CMake Error: The source directory "/home/avinash/workspaces/github.com/udi-service/udi-sqlite/cwalk-stable/cwalk" does not appear to contain CMakeLists.txt.
   Specify --help for usage, or press the help button on the CMake GUI.
3. Faced the error while cloning cwalk submodule sqlite-path. 
        Cloning into '/home/avinash/workspaces/github.com/udi-service/udi-sqlite/sqlite-path/cwalk'...
        git@github.com: Permission denied (publickey).
        fatal: Could not read from remote repository.

        Please make sure you have the correct access rights
        and the repository exists.
        fatal: clone of 'git@github.com:likle/cwalk.git' into submodule path '/udi-service/udi-sqlite/sqlite-path/cwalk' failed
        Failed to clone 'cwalk'. Retry scheduled
4. Work around for the above error by downloading the .zip into sql-path and building cwalk.
5. Faced compiler errors while building sqlite_path static library, fixed them by adding 
     include sqlite-path/Makefile in the top level Make in order to access 
6. Fix the warnings on compiling the sqlite_path static library.
7. Added a github issue for compiler errors while building the core_init.c file, https://github.com/asg017/sqlite-path/issues/10.
        workaround by touching the c file by adding a header file to it. To fix this.
8. Warnings faced while building the Regex extension.
        warning: unused import: `ffi::c_void`
  --> src/captures.rs:10:11
   |
   | use std::{ffi::c_void, mem, os::raw::c_int};
   |           ^^^^^^^^^^^
   |
   = note: `#[warn(unused_imports)]` on by default

   warning: `sqlite-regex` (lib) generated 1 warning

#ISSUES FACED and fixes.

1. gcc -o ./udi-sqlite shell.c sqlite3.c udi-sqlite-extensions.c sqlite-ulid/dist/release/libsqlite_ulid0.a sqlean/dist/libsqlite_crypto0.a sqlite-path/dist/libsqlite_path0.a -DSQLITE_CORE -DSQLITE_SHELL_INIT_PROC=udi_sqlite_init_extensions -ldl -lpthread -lm
/usr/bin/ld: sqlite-path/dist/libsqlite_path0.a(sqlite-path.o):(.bss+0x0): multiple definition of `sqlite3_api'; sqlean/dist/libsqlite_crypto0.a(sqlite3-crypto.o):/home/avinash/Projects/CitrusWork/OpsFolio_udi_sqlite/udi-sqlite/sqlean/src/sqlite3-crypto.c:7: first defined here
collect2: error: ld returned 1 exit status
make: *** [Makefile:42: udi-sqlite] Error 1

   Triaged as: The re-definition of SQLITE_EXTENSION_INIT1 in both sqlean-crypto and sqlite-path is the issue.
   Fix: # Note: the -DSQLITE_CORE is necessary to avoid linker errors.
        Added the -DSQLITE_CORE in below target. This option defines static linking of modules. I am also specifying it while building the executable.
        but it is important to be specified while building each of the static libraries.

        %.o: %.c
           $(CC) -DSQLITE_CORE $(DEFINE_SQLITE_PATH) -I$(CWALK_INCLUDE_DIR) -c $< -o $@ $(SQLITE_PATH_CFLAGS)

2. The init function on access from udi-sqlite-extensions.c gives a SIGSEGV error. On using the static library from the target directory in the project issue was fixed.
3. 
