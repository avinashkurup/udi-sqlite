SELECT
    plan(4);

SELECT
    ok(1,
        "this passes");

SELECT
    ok(0,
        "this fails");

CREATE TABLE puppies(
    name text,
    cuteness number
);

INSERT INTO puppies
    VALUES ('lassie', 5);

INSERT INTO puppies
    VALUES ('spot', 7);

SELECT
    ok(cuteness >= 5,
        name || ' is darn cute')
FROM
    puppies;

SELECT
    ok(1);

SELECT
    ok(0);

