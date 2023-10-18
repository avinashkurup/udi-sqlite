#include <stdio.h>
#include "sqlite3ext.h"
SQLITE_EXTENSION_INIT1

#include "sqlite-ulid/dist/release/sqlite-ulid.h"

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
    fprintf(stderr, "❌ demo.c could not load sqlite3_ulid_init: %s\n", sqlite3_errmsg(db));
    sqlite3_close(db);
    return 1;
  }
  return SQLITE_OK;
}
