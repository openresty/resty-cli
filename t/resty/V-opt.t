# vi:ft= et ts=4 sw=4

use lib 't/lib';
use Test::Resty;

plan tests => blocks() * 3;

run_tests();

__DATA__

=== TEST 1: -V
--- opts: -V
--- out
--- err_like eval
qr/^resty \d+.\d{2}
nginx version: /s
--- ret: 0

