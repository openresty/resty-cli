# vi:ft= et ts=4 sw=4

use lib 't/lib';
use Test::Resty;

plan tests => (blocks() * 2);

run_tests();

__DATA__

=== TEST 1: check is_console
--- src
ngx.say(ngx.config.is_console)

--- out
true
