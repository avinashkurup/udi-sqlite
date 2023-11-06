SELECT
    plan(1);

-- Example: Test if the regex function matches a pattern.
-- Note: This assumes that you have a regex function available in SQLite, either natively or through another extension.
SELECT
    (ok(
            SELECT
                html_version()),
            "checks if http_get_body function exists");

