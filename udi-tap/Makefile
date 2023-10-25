# TODO: set udi_tap.o to automatic variable in rule.
sqlitetap: udi_tap.o
	#ld -shared -o udi_tap.ext udi_tap.o
	ar rcs libsqlite_uditap0.a udi_tap.o

udi_tap.o: udi_tap.c
	gcc -DSQLITE_CORE -c -I.. -fPIC udi_tap.c

test: sqlitetap
	../udi-sqlite < test.sql > test.output
	diff test.output test.expected
