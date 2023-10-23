#include <stdio.h>
#include "sqlite3ext.h"
SQLITE_EXTENSION_INIT1

#include "sqlite-ulid/dist/release/sqlite-ulid.h"

int sqlite3_crypto_init(sqlite3 *, char **, const sqlite3_api_routines *);
int sqlite3_path_init(sqlite3 *, char **,
                      const sqlite3_api_routines *);
int sqlite3_regex_init(sqlite3 *, char **,
                       const sqlite3_api_routines *);

int udi_sqlite_init_extensions(sqlite3 *db, char **pzErrMsg,
                               const sqlite3_api_routines *pApi)
{
  (void)pzErrMsg;
  SQLITE_EXTENSION_INIT2(pApi);
  int rc = SQLITE_OK;
  sqlite3_stmt *stmt;
  char *error_message;

  rc = sqlite3_auto_extension((void (*)())sqlite3_ulid_init);
  if (rc != SQLITE_OK)
  {
    fprintf(stderr, "❌ udi-sqlite-extensions.c could not load sqlite3_ulid_init: %s\n", sqlite3_errmsg(db));
    sqlite3_close(db);
    return 1;
  }
  rc = sqlite3_auto_extension((void (*)())sqlite3_crypto_init);
  if (rc != SQLITE_OK)
  {
    fprintf(stderr, "❌ udi-sqlite-extensions.c could not load sqlite3_crypto_init: %s\n", sqlite3_errmsg(db));
    sqlite3_close(db);
    return 1;
  }
  rc = sqlite3_auto_extension((void (*)())sqlite3_path_init);
  if (rc != SQLITE_OK)
  {
    fprintf(stderr, "❌ udi-sqlite-extensions.c could not load sqlite3_crypto_init: %s\n", sqlite3_errmsg(db));
    sqlite3_close(db);
    return 1;
  }
  rc = sqlite3_auto_extension((void (*)())sqlite3_regex_init);
  if (rc != SQLITE_OK)
  {
    fprintf(stderr, "❌ udi-sqlite-extensions.c could not load sqlite3_crypto_init: %s\n", sqlite3_errmsg(db));
    sqlite3_close(db);
    return 1;
  }
  return SQLITE_OK;
}
