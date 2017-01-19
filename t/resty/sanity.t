# vi:ft= et ts=4 sw=4

use lib 't/lib';
use Test::Resty;

plan tests => blocks() * 2;

run_tests();

__DATA__

=== TEST 1: exits with return value
--- src
print("hello world")
return 6
--- out
hello world
--- ret: 6



=== TEST 2: errors out when return value is not a number
--- src
return "hello"
--- err_like chop
bad return value of type string
--- ret: 1
