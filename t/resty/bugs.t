# vi:ft= et ts=4 sw=4

use lib 't/lib';
use Test::Resty;

plan tests => blocks() * 2;

run_tests();

__DATA__

=== TEST 1: decode_base64url bug - GitHub issue openresty/lua-resty-core#232
--- src
local u64d = require "ngx.base64".decode_base64url

for i = 1, 1000 do
    local x = u64d(("x"):rep(i))
end
print("ok")
--- out
ok



=== TEST 2: use /dev/null as a lua input file
--- opts: -e 'print(arg[1], ", ", arg[2])' /dev/null hello world

--- out
hello, world
