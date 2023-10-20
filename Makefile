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

udi-sqlite: $(CRYPTO_STATIC_LIB)
	gcc -o ./udi-sqlite shell.c sqlite3.c udi-sqlite-extensions.c sqlite-ulid/dist/release/libsqlite_ulid0.a sqlean/dist/libsqlite_crypto0.a -DSQLITE_CORE -DSQLITE_SHELL_INIT_PROC=udi_sqlite_init_extensions -ldl -lpthread -lm
