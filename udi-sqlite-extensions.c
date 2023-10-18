#include "sqlite3ext.h"
SQLITE_EXTENSION_INIT1

#include "sqlite-ulid/dist/release/sqlite-ulid.h"

int udi_sqlite_init_extensions(sqlite3 *db, char **pzErrMsg,
                               const sqlite3_api_routines *pApi)
{
  (void)pzErrMsg;
  SQLITE_EXTENSION_INIT2(pApi);

  // Initialize all static-linked extension here (e.g., ULID)
  // int rc = sqlite3_ulid_init(db, pzErrMsg, pApi);
  // if (rc != SQLITE_OK) {
  //   return rc;
  // }
  // don't return result until sqlite3_ulid_init is made FFI-safe
  // sqlite3_ulid_init(db, pzErrMsg, pApi);

  // If you have more extensions, initialize them here in a similar manner

  // Used from sqlite-ulid/examples/c/demo.c
  int rc = SQLITE_OK;
  // sqlite3 *db;
  sqlite3_stmt *stmt;
  char *error_message;

  rc = sqlite3_auto_extension((void (*)())sqlite3_ulid_init);
  if (rc != SQLITE_OK)
  {
    fprintf(stderr, "❌ demo.c could not load sqlite3_ulid_init: %s\n", sqlite3_errmsg(db));
    sqlite3_close(db);
    return 1;
  }
  return SQLITE_OK;
}
