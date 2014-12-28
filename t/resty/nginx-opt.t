# vi:ft= et ts=4 sw=4

use lib 't/lib';
use Test::Resty;

plan tests => blocks() * 3;

run_tests();

__DATA__

=== TEST 1: bad --nginx value
--- opts: --nginx=/tmp/no/such/file
--- src
print("arg 0: ", arg[0])
print("arg 1: ", arg[1])
print("arg 2: ", arg[2])
print("arg 3: ", arg[3])

--- out
--- err_like chop
Can't exec "/tmp/no/such/file": No such file or directory
--- ret: 2

