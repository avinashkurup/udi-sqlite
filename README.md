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
6. Install [jq](https://jqlang.github.io/jq/download/).
7. Run `$ cd udi-sqlite` and run `$ ./make.ts`

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

2. TODO: The issue of functions not found is fixed in the build process, The unit tests are failing as I doubt function names are changed are: I have to check this.

Here is a list of all the `fileio` extension functions called in the sqlean unit test provided SQL:

        1. fileio_ls
        2. fileio_mode
        3. fileio_mkdir
        4. fileio_read
        5. fileio_symlink
        6. fileio_write
        7. fileio_scan
        8. fileio_append

Here is the list of unsupported functions which gave the error 'no such function: fileio_xxxx' error:

        **Unsupported Functions:**
        1. fileio_mode
        2. fileio_mkdir
        3. fileio_read
        4. fileio_symlink
        5. fileio_write

3. udi-sqlite tests of the file-io extension fails with errors 'no such function: fileio_xxxx'
These are based on the recurring errors found in the provided SQL output. You might want to address these missing tables and functions or check the SQL and database configuration to resolve these issues.

      FIXED: by modifying the Makefile to build .o files in the corresponding source directories and and create the static library from the
      amalgamation of these files in the sqlean/src/dist directory. This issues was due to overwriting of created binaries as per the
      earlier approach of moving all files to a common directory. TODO. fix this in other sqlean .o make targets.



      Triaged as: The extension init function, viz. sqlite3_fileio_init is defined in 1. shell.c and 2. sqlean/src/sqlite3-fileio.c.
      udi-sqlite_init_extensions() passes control to the definition in shell.c and this results in the extension functions not registered in
      udi-sqlite.

      Potential fixes attempted:
      Remove or Rename the Duplicate:
            If you decide to keep the function in shell.c, then:
            Comment out or remove the sqlite3_fileio_init function from sqlean/src/sqlite3-fileio.c.
            If there are any calls or references to this function from other parts of sqlean/src/sqlite3-fileio.c, you'll need to update them to point to the correct implementation in shell.c.
            Alternatively, if you decide to keep the function in sqlean/src/sqlite3-fileio.c, then:
            Comment out or remove the sqlite3_fileio_init function from shell.c.
            Make sure to update any calls or references in shell.c to the correct implementation in sqlean/src/sqlite3-fileio.c.

            faced this error on build: 
            gcc -o ./udi-sqlite shell.c sqlite3.c udi-sqlite-extensions.c \
                    sqlite-ulid/dist/release/libsqlite_ulid0.a \
                    sqlean/dist/libsqlite_crypto0.a \
                    sqlite-path/dist/libsqlite_path0.a \
                    -DSQLITE_CORE -DSQLITE_SHELL_INIT_PROC=udi_sqlite_init_extensions \
                    -ldl -lpthread -lm
            /usr/bin/ld: /tmp/cciAP6Py.o: in function `udi_sqlite_init_extensions':
            udi-sqlite-extensions.c:(.text+0x130): undefined reference to `sqlite3_fileio_init'
            collect2: error: ld returned 1 exit status
            make: *** [Makefile:42: udi-sqlite] Error 1

      Recompile the Source Files: Sometimes, object files can be stale. Make sure you recompile the source files, especially if there were changes.   Same error as above.

      -DSQLITE_SHELL_FIDDLE in the gcc command to build udi-sqlite executable.
            gcc -o ./udi-sqlite shell.c sqlite3.c udi-sqlite-extensions.c \
                    sqlite-ulid/dist/release/libsqlite_ulid0.a \
                    sqlean/dist/libsqlite_crypto0.a \
                    sqlite-path/dist/libsqlite_path0.a \
                    -DSQLITE_SHELL_FIDDLE -DSQLITE_CORE -DSQLITE_SHELL_INIT_PROC=udi_sqlite_init_extensions \
                    -ldl -lpthread -lm
            shell.c: In function ‘do_meta_command’:
            shell.c:24123:27: warning: implicit declaration of function ‘strdup’ [-Wimplicit-function-declaration]
            24123 |         azName[nName*2] = strdup(zSchema);
            |                           ^~~~~~
            shell.c:24123:27: warning: incompatible implicit declaration of built-in function ‘strdup’ [-Wbuiltin-declaration-mismatch]
            shell.c: In function ‘fiddle_main’:
            shell.c:28120:21: warning: incompatible implicit declaration of built-in function ‘strdup’ [-Wbuiltin-declaration-mismatch]
            28120 |       data.zNonce = strdup(cmdline_option_value(argc, argv, ++i));
            |                     ^~~~~~
            shell.c:28428:20: warning: incompatible implicit declaration of built-in function ‘strdup’ [-Wbuiltin-declaration-mismatch]
            28428 |         zHistory = strdup(zHistory);
            |                    ^~~~~~
            /usr/bin/ld: /usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu/Scrt1.o: in function `_start':
            (.text+0x1b): undefined reference to `main'
            /usr/bin/ld: /tmp/cc6riHti.o: in function `udi_sqlite_init_extensions':
            udi-sqlite-extensions.c:(.text+0x130): undefined reference to `sqlite3_fileio_init'
            collect2: error: ld returned 1 exit status

      Condionally compile out the sqlite3_fileio_init in shell.c with the CUSTOM_SQLITE3_FILEIO_INIT definition (NOT DESIRABLE)
            faced this error on compilation.
            gcc -o ./udi-sqlite shell.c sqlite3.c udi-sqlite-extensions.c \
                    sqlite-ulid/dist/release/libsqlite_ulid0.a \
                    sqlean/dist/libsqlite_crypto0.a \
                    sqlite-path/dist/libsqlite_path0.a \
                    -DSQLITE_CORE -DSQLITE_SHELL_INIT_PROC=udi_sqlite_init_extensions \
                    -ldl -lpthread -lm
            shell.c: In function ‘open_db’:
            shell.c:21286:5: warning: implicit declaration of function ‘sqlite3_fileio_init’; did you mean ‘sqlite3_ieee_init’? [-Wimplicit-function-declaration]
            21286 |     sqlite3_fileio_init(p->db, 0, 0);
            |     ^~~~~~~~~~~~~~~~~~~
            |     sqlite3_ieee_init
            /usr/bin/ld: /tmp/ccTb1hQV.o: in function `open_db':
            shell.c:(.text+0x1e3fc): undefined reference to `sqlite3_fileio_init'
            /usr/bin/ld: /tmp/ccSksM6x.o: in function `udi_sqlite_init_extensions':
            udi-sqlite-extensions.c:(.text+0x130): undefined reference to `sqlite3_fileio_init'
            collect2: error: ld returned 1 exit status
            make: *** [Makefile:42: udi-sqlite] Error 1

      Place the sqlean/dist/libsqlite_fileio0.a before shell.c in the gcc compilation command, so that linker prefers the former definition of sqlite3_fileio_init().
            gcc -o ./udi-sqlite sqlean/dist/libsqlite_fileio0.a \
                    shell.c sqlite3.c udi-sqlite-extensions.c \
                    sqlite-ulid/dist/release/libsqlite_ulid0.a \
                    sqlean/dist/libsqlite_crypto0.a \
                    sqlite-path/dist/libsqlite_path0.a \
                    -DSQLITE_CORE -DSQLITE_SHELL_INIT_PROC=udi_sqlite_init_extensions \
                    -ldl -lpthread -lm
            shell.c: In function ‘open_db’:
            shell.c:21286:5: warning: implicit declaration of function ‘sqlite3_fileio_init’; did you mean ‘sqlite3_ieee_init’? [-Wimplicit-function-declaration]
            21286 |     sqlite3_fileio_init(p->db, 0, 0);
            |     ^~~~~~~~~~~~~~~~~~~
            |     sqlite3_ieee_init
            /usr/bin/ld: /tmp/ccTqeaYP.o: in function `open_db':
            shell.c:(.text+0x1e3fc): undefined reference to `sqlite3_fileio_init'
            /usr/bin/ld: /tmp/ccNUEJp8.o: in function `udi_sqlite_init_extensions':
            udi-sqlite-extensions.c:(.text+0x130): undefined reference to `sqlite3_fileio_init'
            collect2: error: ld returned 1 exit status
            make: *** [Makefile:42: udi-sqlite] Error 1

      The issue seems to be 2 object files (sqlite3-crypto.o, sqlite3-fileio.o) created for the sqlean extensions for crypto and fileio,
      but only one extension.o file generated for both object files. The 

      FIX Note: extension.o contains the definitions of the crypto extension, this should have fileio extension defs.
      $ nm sqlean/dist/libsqlite_fileio0.a 

      The extension functions contain the {crypto, fileio}_init() functions.

2. The regex extension init function on registration from udi-sqlite-extensions.c gives a SIGSEGV error. On using the static library from the target directory in the project the issue was fixed.
3. 
