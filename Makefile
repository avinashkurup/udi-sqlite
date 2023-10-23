# Variables
CC = gcc
AR = ar
SQLEAN_VERSION := '"$(or $(shell cd sqlean && git tag --points-at HEAD),main)"'
LINIX_FLAGS := -Wall -Wsign-compare -Wno-unknown-pragmas -fPIC -shared -include ./sqlean/src/regexp/constants.h -I./sqlean/src -DSQLEAN_VERSION=${SQLEAN_VERSION}
CFLAGS = $(LINIX_FLAGS)

# Define the crypto source directory and individual source file
CRYPTO_SRC_DIR = sqlean/src/crypto
CRYPTO_SQLITE3_CRYPTO_C = sqlean/src/sqlite3-crypto.c

# List out all the source files from CRYPTO_SRC_DIR and append the individual file CRYPTO_SQLITE3_CRYPTO_C
CRYPTO_SRC_FILES := $(wildcard $(CRYPTO_SRC_DIR)/*.c) $(CRYPTO_SQLITE3_CRYPTO_C)

# Convert these source files into their corresponding object file paths in the sqlean/dist directory
CRYPTO_OBJ_FILES := $(patsubst $(CRYPTO_SRC_DIR)/%.c, sqlean/dist/%.o, $(CRYPTO_SRC_FILES)) sqlean/dist/sqlite3-crypto.o

# Rule to compile .c to .o for crypto files
sqlean/dist/%.o: $(CRYPTO_SRC_DIR)/%.c | sqlean/dist
	@echo "Compiling $< to $@..."
	$(CC) -g $(CFLAGS) -c -o $@ $<

sqlean/dist/sqlite3-crypto.o: $(CRYPTO_SQLITE3_CRYPTO_C) | sqlean/dist
	@echo "Compiling $< to $@..."
	$(CC) -g $(CFLAGS) -c -o $@ $<

# Rule to create sqlean/dist directory
sqlean/dist:
	@mkdir -p sqlean/dist

# Default rule to compile all crypto object files
all: $(CRYPTO_OBJ_FILES)

CRYPTO_STATIC_LIB = sqlean/dist/libsqlite_crypto0.a

$(CRYPTO_STATIC_LIB): $(CRYPTO_OBJ_FILES)
	@echo "Compiling fileio functionality into a static library..."
	$(AR) rcs $(CRYPTO_STATIC_LIB) $(CRYPTO_OBJ_FILES)
	@echo "Static library creation completed."


udi-sqlite: $(CRYPTO_STATIC_LIB) udi-sqlite-extensions.c
	gcc -o ./udi-sqlite	\
		shell.c sqlite3.c udi-sqlite-extensions.c \
		sqlite-ulid/dist/release/libsqlite_ulid0.a \
		sqlean/dist/libsqlite_crypto0.a \
		sqlite-path/dist/libsqlite_path0.a \
		sqlean/dist/libsqlite_fileio0.a \
		sqlite-regex/target/release/libsqlite_regex.a \
		-DSQLITE_CORE -DSQLITE_SHELL_INIT_PROC=udi_sqlite_init_extensions \
		-ldl -lpthread -lm

CWALK_SRCS_URL = "https://github.com/likle/cwalk/archive/stable.zip"
SQLITE_PATH_SRC_DIR = sqlite-path
CWALK_CHECK_DIR = $(SQLITE_PATH_SRC_DIR)/cwalk
TMP_INFLATE_DIR = $(CWALK_CHECK_DIR)/tmp_dir

download_cwalk:
	# Note: This is a fix authorization issues for cwalk submodule in sqlite-path.
	# explained in README.md pt 3.
	echo "downloading cwalk to path $CWALK_CHECK_DIR/stable.zip"
	cd $(CWALK_CHECK_DIR) && \
		mkdir -p $(TMP_INFLATE_DIR)
		curl -L --output ./stable.zip $(CWALK_SRCS_URL) && \
		unzip ./stable.zip -d $(TMP_INFLATE_DIR) && \
		mv $(TMP_INFLATE_DIR)/cwalk-stable/* $(CWALK_CHECK_DIR) && \
		rm -rf $(TMP_INFLATE_DIR) && \
		rm ./stable.zip

cwalk:
	cd $(CWALK_CHECK_DIR)
	mkdir -p $(CWALK_CHECK_DIR)/cwalk/build && cd $(CWALK_CHECK_DIR)/cwalk/build && cmake ../../ && make && cmake ../../ -DENABLE_TESTS=1 && make && ./cwalktest

clean_cwalk:
	rm -rf $(CWALK_CHECK_DIR)/cwalk/*

sqlite_path:
	@echo "Compiling sqlite-path library."
	cd $(SQLITE_PATH_SRC_DIR) && make CWALK_VERSION=$(shell jq '.version' sqlite-path/cwalk/clib.json) loadable

# For accessing DEFINE_SQLITE_PATH in the sqlite-path Makefile.
include sqlite-path/Makefile

SQLITE_PATH_CFLAGS = -Wall -O2

# Source and Object Directories
SQLITE_PATH_SRC = sqlite-path/sqlite-path.c
CWALK_SRC = sqlite-path/cwalk/src/cwalk.c
CWALK_INCLUDE_DIR = sqlite-path/cwalk/include/

SQLITE_PATH_OBJ = $(SQLITE_PATH_SRC:.c=.o)
CWALK_OBJ = $(CWALK_SRC:.c=.o)

# Output Static Library Name
LIBRARY_NAME = sqlite-path/dist/libsqlite_path0.a

# Targets
all: $(LIBRARY_NAME)

$(LIBRARY_NAME): $(SQLITE_PATH_OBJ) $(CWALK_OBJ)
	$(AR) rcs $@ $^

# Note: the -DSQLITE_CORE is necessary to avoid linker errors.
%.o: %.c
	@echo "sqlite-path: Compiling $< to $@..."
	$(CC) -DSQLITE_CORE $(DEFINE_SQLITE_PATH) -I$(CWALK_INCLUDE_DIR) -c $< -o $@ $(SQLITE_PATH_CFLAGS)

# File IO targets.
SRC_DIR = sqlean/src/fileio
SRC_SQLITE3_FILEIO_C = sqlean/src/sqlite3-fileio.c

clean_sqlite_path_bins:
	rm -f $(SQLITE_PATH_OBJ) $(CWALK_OBJ) $(LIBRARY_NAME)

.PHONY: all clean

# Define the source directory for your C files
FILEIO_SRC_DIR = sqlean/src/fileio
SRC_SQLITE3_FILEIO_C = sqlean/src/sqlite3-fileio.c

# Source files and object files
SRC_FILES := $(wildcard $(FILEIO_SRC_DIR)/*.c) $(SRC_SQLITE3_FILEIO_C)
#OBJ_FILES_DIR := $(patsubst %.c, %.o, $(SRC_FILES))
OBJ_FILES_DIR := $(patsubst $(FILEIO_SRC_DIR)/%.c, $(FILEIO_SRC_DIR)/%.o, $(SRC_FILES))
OBJ_FILES := $(OBJ_FILES_DIR)

# Compiler and flags
CC = gcc
AR = ar
SQLEAN_VERSION := '"$(or $(shell cd sqlean && git tag --points-at HEAD),main)"'
LINIX_FLAGS := -Wall -Wsign-compare -Wno-unknown-pragmas -fPIC -shared -I./sqlean/src -DSQLEAN_VERSION=${SQLEAN_VERSION}
CFLAGS = $(LINIX_FLAGS)

# Target library
FILEIO_STATIC_LIB = sqlean/dist/libsqlite_fileio0.a

fileio_static_lib: $(OBJ_FILES)
	@echo "Compiling fileio functionality into a static library..."
	$(AR) rcs $(FILEIO_STATIC_LIB) $(OBJ_FILES)
	@echo "Static library creation completed."

$(FILEIO_SRC_DIR)/%.o: $(FILEIO_SRC_DIR)/%.c | prepare_fileio_dist
	@echo "Compiling $< to $@..."
	$(CC) -DSQLITE_CORE $(CFLAGS) -c -o $@ $^

prepare_fileio_dist:
	mkdir -p sqlean/dist

clean_fileio_libs:
	rm sqlean/dist/libsqlite_fileio0.a
	rm -rf $(FILEIO_SRC_DIR)/*.o
