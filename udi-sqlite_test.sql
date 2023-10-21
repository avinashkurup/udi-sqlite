-- ulid tests
SELECT
    ulid_bytes();

.mode box
SELECT
    ulid(),
    NULL AS '           ulid_bytes()            ',
    ulid_with_prefix("invoice_");

SELECT
    ulid_datetime('01GMP2G8ZG6PMKWYVKS62TTA41');

CREATE TABLE events(
    id text PRIMARY KEY,
    data json
);

INSERT INTO events
SELECT
    ulid_with_prefix('event') AS id,
    '{}';

-- crypto tests
SELECT
    '1_01',
    md5(NULL) IS NULL;

SELECT
    '1_02',
    hex(md5('')) = upper('d41d8cd98f00b204e9800998ecf8427e');

SELECT
    '1_03',
    hex(md5('abc')) = upper('900150983cd24fb0d6963f7d28e17f72');

SELECT
    '2_01',
    sha1(NULL) IS NULL;

SELECT
    '2_02',
    hex(sha1('')) = upper('da39a3ee5e6b4b0d3255bfef95601890afd80709');

SELECT
    '2_03',
    hex(sha1('abc')) = upper('a9993e364706816aba3e25717850c26c9cd0d89d');

SELECT
    '3_01',
    sha256(NULL) IS NULL;

SELECT
    '3_02',
    hex(sha256('')) = upper('e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855');

SELECT
    '3_03',
    hex(sha256('abc')) = upper('ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad');

SELECT
    '4_01',
    sha384(NULL) IS NULL;

SELECT
    '4_02',
    hex(sha384('')) = upper('38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b');

SELECT
    '4_03',
    hex(sha384('abc')) = upper('cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7');

SELECT
    '5_01',
    sha512(NULL) IS NULL;

SELECT
    '5_02',
    hex(sha512('')) = upper('cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e');

SELECT
    '5_03',
    hex(sha512('abc')) = upper('ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f');

SELECT
    '6_01',
    encode(NULL, 'base64') IS NULL;

SELECT
    '6_02',
    encode('', 'base64') = '';

SELECT
    '6_03',
    encode('hello', 'base64') = 'aGVsbG8=';

SELECT
    '6_04',
    encode(sha256('hello'), 'base64') = 'LPJNul+wow4m6DsqxbninhsWHlwfp0JecwQzYpOLmCQ=';

SELECT
    '6_05',
    encode('a', 'base64') = 'YQ==';

SELECT
    '6_06',
    encode('ab', 'base64') = 'YWI=';

SELECT
    '6_07',
    encode('abc', 'base64') = 'YWJj';

SELECT
    '6_07',
    encode('abcd', 'base64') = 'YWJjZA==';

SELECT
    '6_09',
    encode('abcde', 'base64') = 'YWJjZGU=';

SELECT
    '6_10',
    encode('abcdef', 'base64') = 'YWJjZGVm';

SELECT
    '6_11',
    encode('эй, мир!', 'base64') = '0Y3QuSwg0LzQuNGAIQ==';

SELECT
    '6_12',
    encode('(ಠ_ಠ)', 'base64') = 'KOCyoF/gsqAp';

SELECT
    '6_13',
    encode('The quick brown 🦊 jumps over 13 lazy 🐶.', 'base64') = 'VGhlIHF1aWNrIGJyb3duIPCfpooganVtcHMgb3ZlciAxMyBsYXp5IPCfkLYu';

SELECT
    '7_01',
    decode(NULL, 'base64') IS NULL;

SELECT
    '7_02',
    decode('', 'base64') = cast('' AS blob);

SELECT
    '7_03',
    decode('aGVsbG8=', 'base64') = cast('hello' AS blob);

SELECT
    '7_04',
    decode('LPJNul+wow4m6DsqxbninhsWHlwfp0JecwQzYpOLmCQ=', 'base64') = sha256('hello');

SELECT
    '7_05',
    decode('YQ==', 'base64') = cast('a' AS blob);

SELECT
    '7_06',
    decode('YWI=', 'base64') = cast('ab' AS blob);

SELECT
    '7_07',
    decode('YWJj', 'base64') = cast('abc' AS blob);

SELECT
    '7_08',
    decode('YWJjZA==', 'base64') = cast('abcd' AS blob);

SELECT
    '7_09',
    decode('YWJjZGU=', 'base64') = cast('abcde' AS blob);

SELECT
    '7_10',
    decode('YWJjZGVm', 'base64') = cast('abcdef' AS blob);

SELECT
    '7_11',
    decode('0Y3QuSwg0LzQuNGAIQ==', 'base64') = cast('эй, мир!' AS blob);

SELECT
    '7_12',
    decode('KOCyoF/gsqAp', 'base64') = cast('(ಠ_ಠ)' AS blob);

SELECT
    '7_13',
    decode('VGhlIHF1aWNrIGJyb3duIPCfpooganVtcHMgb3ZlciAxMyBsYXp5IPCfkLYu', 'base64') = cast('The quick brown 🦊 jumps over 13 lazy 🐶.' AS blob);

SELECT
    '8_01',
    encode(NULL, 'base32') IS NULL;

SELECT
    '8_02',
    encode('', 'base32') = '';

SELECT
    '8_03',
    encode('hello', 'base32') = 'NBSWY3DP';

SELECT
    '8_05',
    encode('a', 'base32') = 'ME======';

SELECT
    '8_06',
    encode('ab', 'base32') = 'MFRA====';

SELECT
    '8_07',
    encode('abc', 'base32') = 'MFRGG===';

SELECT
    '8_08',
    encode('abcd', 'base32') = 'MFRGGZA=';

SELECT
    '8_09',
    encode('abcde', 'base32') = 'MFRGGZDF';

SELECT
    '8_10',
    encode('abcdef', 'base32') = 'MFRGGZDFMY======';

SELECT
    '8_11',
    encode('эй, мир!', 'base32') = '2GG5BOJMEDILZUFY2GACC===';

SELECT
    '8_12',
    encode('(ಠ_ಠ)', 'base32') = 'FDQLFIC74CZKAKI=';

SELECT
    '8_13',
    encode('The quick brown 🦊 jumps over 13 lazy 🐶.', 'base32') = 'KRUGKIDROVUWG2ZAMJZG653OEDYJ7JUKEBVHK3LQOMQG65TFOIQDCMZANRQXU6JA6CPZBNRO';

SELECT
    '9_01',
    decode(NULL, 'base32') IS NULL;

SELECT
    '9_02',
    decode('', 'base32') = cast('' AS blob);

SELECT
    '9_03',
    decode('NBSWY3DP', 'base32') = cast('hello' AS blob);

SELECT
    '9_05',
    decode('ME======', 'base32') = cast('a' AS blob);

SELECT
    '9_06',
    decode('MFRA====', 'base32') = cast('ab' AS blob);

SELECT
    '9_07',
    decode('MFRGG===', 'base32') = cast('abc' AS blob);

SELECT
    '9_08',
    decode('MFRGGZA=', 'base32') = cast('abcd' AS blob);

SELECT
    '9_09',
    decode('MFRGGZDF', 'base32') = cast('abcde' AS blob);

SELECT
    '9_10',
    decode('MFRGGZDFMY======', 'base32') = cast('abcdef' AS blob);

SELECT
    '9_11',
    decode('2GG5BOJMEDILZUFY2GACC===', 'base32') = cast('эй, мир!' AS blob);

SELECT
    '9_12',
    decode('FDQLFIC74CZKAKI=', 'base32') = cast('(ಠ_ಠ)' AS blob);

SELECT
    '9_13',
    decode('KRUGKIDROVUWG2ZAMJZG653OEDYJ7JUKEBVHK3LQOMQG65TFOIQDCMZANRQXU6JA6CPZBNRO', 'base32') = cast('The quick brown 🦊 jumps over 13 lazy 🐶.' AS blob);

SELECT
    '10_01',
    encode(NULL, 'hex') IS NULL;

SELECT
    '10_02',
    encode('', 'hex') = '';

SELECT
    '10_03',
    encode('hello', 'hex') = '68656c6c6f';

SELECT
    '10_04',
    encode(sha256('hello'), 'hex') = '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824';

SELECT
    '10_05',
    encode('x', 'hex') = '78';

SELECT
    '10_06',
    encode('xyz', 'hex') = '78797a';

SELECT
    '10_07',
    encode('xyz{|}', 'hex') = '78797a7b7c7d';

SELECT
    '10_08',
    encode('эй, мир!', 'hex') = 'd18dd0b92c20d0bcd0b8d18021';

SELECT
    '10_09',
    encode('(ಠ_ಠ)', 'hex') = '28e0b2a05fe0b2a029';

SELECT
    '10_10',
    encode('The quick brown 🦊 jumps over 13 lazy 🐶.', 'hex') = '54686520717569636b2062726f776e20f09fa68a206a756d7073206f766572203133206c617a7920f09f90b62e';

SELECT
    '11_01',
    decode(NULL, 'hex') IS NULL;

SELECT
    '11_02',
    decode('', 'hex') = cast('' AS blob);

SELECT
    '11_03',
    decode('68656c6c6f', 'hex') = cast('hello' AS blob);

SELECT
    '11_04',
    decode('2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824', 'hex') = sha256('hello');

SELECT
    '11_05',
    decode('78', 'hex') = cast('x' AS blob);

SELECT
    '11_06',
    decode('78797a', 'hex') = cast('xyz' AS blob);

SELECT
    '11_07',
    decode('78797a7b7c7d', 'hex') = cast('xyz{|}' AS blob);

SELECT
    '11_08',
    decode('d18dd0b92c20d0bcd0b8d18021', 'hex') = cast('эй, мир!' AS blob);

SELECT
    '11_09',
    decode('28e0b2a05fe0b2a029', 'hex') = cast('(ಠ_ಠ)' AS blob);

SELECT
    '11_10',
    decode('54686520717569636b2062726f776e20f09fa68a206a756d7073206f766572203133206c617a7920f09f90b62e', 'hex') = cast('The quick brown 🦊 jumps over 13 lazy 🐶.' AS blob);

SELECT
    '11_11',
    decode('68656C6C6F', 'hex') = cast('hello' AS blob);

SELECT
    '11_12',
    decode('2CF24DBA5FB0A30E26E83B2AC5B9E29E1B161E5C1FA7425E73043362938B9824', 'hex') = sha256('hello');

SELECT
    '12_01',
    encode(NULL, 'url') IS NULL;

SELECT
    '12_02',
    encode('', 'url') = '';

SELECT
    '12_03',
    encode('hello', 'url') = 'hello';

SELECT
    '12_04',
    encode('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~', 'url') = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~';

SELECT
    '12_05',
    encode('!*\();:@&=+$,/?#[]', 'url') = '%21%2A%5C%28%29%3B%3A%40%26%3D%2B%24%2C%2F%3F%23%5B%5D';

SELECT
    '12_06',
    encode('https://www.google.lu/search?q=hello+world&ie=UTF-8', 'url') = 'https%3A%2F%2Fwww.google.lu%2Fsearch%3Fq%3Dhello%2Bworld%26ie%3DUTF-8';

SELECT
    '12_07',
    encode('one two three', 'url') = 'one%20two%20three';

SELECT
    '12_08',
    encode('эй, мир!', 'url') = '%D1%8D%D0%B9%2C%20%D0%BC%D0%B8%D1%80%21';

SELECT
    '12_09',
    encode('(ಠ_ಠ)', 'url') = '%28%E0%B2%A0_%E0%B2%A0%29';

SELECT
    '12_10',
    encode('The quick brown 🦊 jumps over 13 lazy 🐶.', 'url') = 'The%20quick%20brown%20%F0%9F%A6%8A%20jumps%20over%2013%20lazy%20%F0%9F%90%B6.';

SELECT
    '13_01',
    decode(NULL, 'url') IS NULL;

SELECT
    '13_02',
    decode('', 'url') = cast('' AS blob);

SELECT
    '13_03',
    decode('hello', 'url') = cast('hello' AS blob);

SELECT
    '13_04',
    decode('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~', 'url') = cast('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~' AS blob);

SELECT
    '13_05',
    decode('%21%2A%5C%28%29%3B%3A%40%26%3D%2B%24%2C%2F%3F%23%5B%5D', 'url') = cast('!*\();:@&=+$,/?#[]' AS blob);

SELECT
    '13_06',
    decode('https%3A%2F%2Fwww.google.lu%2Fsearch%3Fq%3Dhello%2Bworld%26ie%3DUTF-8', 'url') = cast('https://www.google.lu/search?q=hello+world&ie=UTF-8' AS blob);

SELECT
    '13_07',
    decode('one%20two%20three', 'url') = cast('one two three' AS blob);

SELECT
    '13_08',
    decode('%D1%8D%D0%B9%2C%20%D0%BC%D0%B8%D1%80%21', 'url') = cast('эй, мир!' AS blob);

SELECT
    '13_09',
    decode('%28%E0%B2%A0_%E0%B2%A0%29', 'url') = cast('(ಠ_ಠ)' AS blob);

SELECT
    '13_10',
    decode('The%20quick%20brown%20%f0%9f%a6%8a%20jumps%20over%2013%20lazy%20%f0%9f%90%b6.', 'url') = cast('The quick brown 🦊 jumps over 13 lazy 🐶.' AS blob);

SELECT
    '13_11',
    decode('one+two+three', 'url') = cast('one two three' AS blob);

SELECT
    '14_01',
    encode(NULL, 'base85') IS NULL;

SELECT
    '14_02',
    encode('', 'base85') = '';

SELECT
    '14_03',
    encode('hell', 'base85') = 'BOu!r';

SELECT
    '14_04',
    encode('hello', 'base85') = 'BOu!rDZ';

SELECT
    '14_05',
    encode('hellow', 'base85') = 'BOu!rDg)';

SELECT
    '14_06',
    encode('hellowo', 'base85') = 'BOu!rDg-+';

SELECT
    '14_07',
    encode('эй, мир!', 'base85') = 'd>cM`/0N<Pd(%JR+T';

SELECT
    '14_08',
    encode('(ಠ_ಠ)', 'base85') = '.,_D(?f85_.0';

SELECT
    '14_09',
    encode('The quick brown 🦊 jumps over 13 lazy 🐶.', 'base85') = '<+ohcEHPu*CER),Dg-(An=QS8+DQ%9E-!.?G%G\:0f''qg@=!2An=PfN/c';

SELECT
    '15_01',
    decode(NULL, 'base85') IS NULL;

SELECT
    '15_02',
    decode('', 'base85') = cast('' AS blob);

SELECT
    '15_03',
    decode('BOu!r', 'base85') = cast('hell' AS blob);

SELECT
    '15_04',
    decode('BOu!rDZ', 'base85') = cast('hello' AS blob);

SELECT
    '15_05',
    decode('BOu!rDg)', 'base85') = cast('hellow' AS blob);

SELECT
    '15_06',
    decode('BOu!rDg-+', 'base85') = cast('hellowo' AS blob);

SELECT
    '15_07',
    decode('d>cM`/0N<Pd(%JR+T', 'base85') = cast('эй, мир!' AS blob);

SELECT
    '15_08',
    decode('.,_D(?f85_.0', 'base85') = cast('(ಠ_ಠ)' AS blob);

SELECT
    '15_09',
    decode('<+ohcEHPu*CER),Dg-(An=QS8+DQ%9E-!.?G%G\:0f''qg@=!2An=PfN/c', 'base85') = cast('The quick brown 🦊 jumps over 13 lazy 🐶.' AS blob);

-- sqlite-path
SELECT
    path_dirname('foo/bar.txt');

-- 'foo/'
SELECT
    path_basename('foo/bar.txt');

-- 'bar.txt'
SELECT
    path_extension('foo/bar.txt');

-- '.txt'
SELECT
    path_part_at('foo/bar/baz.txt', 0);

-- 'foo'
SELECT
    path_part_at('foo/bar/baz.txt', 1);

-- 'bar'
SELECT
    path_part_at('foo/bar/baz.txt', -1);

-- 'baz.txt'
