SELECT
    plan(2);

-- Example: Test if the regex function matches a pattern.
-- Note: This assumes that you have a regex function available in SQLite, either natively or through another extension.
SELECT
    ok(regex_find('[0-9]{3}-[0-9]{3}-[0-9]{4}', 'phone: 111-222-3333'),
        "checks if the pattern matches the phone number");

SELECT
    ok(regexset_is_match(regexset("bar", "foo", "barfoo"), 'foobar'),
        "checks match");

