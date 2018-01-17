# vi:ft= et ts=4 sw=4

use lib 't/lib';
use Test::Resty;

plan tests => blocks() * 3;

run_tests();

__DATA__

=== TEST 1: Forward SIGINT to child process
--- opts: -e 'print(1)'
--- mock_nginx
#!/usr/bin/env perl
use strict;
use warnings;

$SIG{INT}   = sub { print "GOT SIGINT"; exit 0 };
$SIG{HUP}   = sub { print "GOT SIGHUP"; exit 0 };
$SIG{WINCH} = sub { print "GOT SIGWINCH"; exit 0 };
$SIG{QUIT} = sub { print "GOT SIGQUIT"; exit 0 };

my $ppid;
$ppid = getppid();
for (1..3) {
    kill INT => $ppid;
    sleep(1);
}

--- out chomp
GOT SIGQUIT
--- err
--- ret: 130



=== TEST 2: Forward SIGHUP to child process
--- opts: -e 'print(1)'
--- mock_nginx
#!/usr/bin/env perl
use strict;
use warnings;

$SIG{INT}   = sub { print "GOT SIGINT"; exit 0 };
$SIG{HUP}   = sub { print "GOT SIGHUP"; exit 0 };
$SIG{WINCH} = sub { print "GOT SIGWINCH"; exit 0 };

my $ppid;
$ppid = getppid();
for (1..3) {
    kill HUP => $ppid;
    sleep(1);
}

--- out_like chop
SIGHUP

--- err



=== TEST 3: Forward SIGTERM to child process
--- opts: -e 'print(1)'
--- mock_nginx
#!/usr/bin/env perl
use strict;
use warnings;

$SIG{TERM}  = sub { print "GOT SIGTERM"; exit 0 };
$SIG{QUIT}  = sub { print "GOT SIGQUIT"; exit 0 };
$SIG{USR1}  = sub { print "GOT SIGUSR1"; exit 0 };

my $ppid;
$ppid = getppid();
for (1..3) {
    kill TERM => $ppid;
    sleep(1);
}

--- out_like chop
SIGTERM

--- err
--- ret: 143



=== TEST 4: Forward SIGQUIT to child process
--- opts: -e 'print(1)'
--- mock_nginx
#!/usr/bin/env perl
use strict;
use warnings;

$SIG{QUIT}  = sub { print "GOT SIGQUIT"; exit 0 };
$SIG{USR1}  = sub { print "GOT SIGUSR1"; exit 0 };
$SIG{USR2}  = sub { print "GOT SIGUSR2"; exit 0 };

my $ppid;
$ppid = getppid();
for (1..3) {
    kill QUIT => $ppid;
    sleep(1);
}

--- out_like chop
SIGQUIT

--- err



=== TEST 5: Forward SIGUSR1 to child process
--- opts: -e 'print(1)'
--- mock_nginx
#!/usr/bin/env perl
use strict;
use warnings;

$SIG{QUIT}  = sub { print "GOT SIGQUIT"; exit 0 };
$SIG{USR1}  = sub { print "GOT SIGUSR1"; exit 0 };
$SIG{USR2}  = sub { print "GOT SIGUSR2"; exit 0 };

my $ppid;
$ppid = getppid();
for (1..3) {
    kill USR1 => $ppid;
    sleep(1);
}

--- out_like chop
SIGUSR1

--- err



=== TEST 6: Forward SIGUSR2 to child process
--- opts: -e 'print(1)'
--- mock_nginx
#!/usr/bin/env perl
use strict;
use warnings;

$SIG{USR1}  = sub { print "GOT SIGUSR1"; exit 0 };
$SIG{USR2}  = sub { print "GOT SIGUSR2"; exit 0 };
$SIG{WINCH} = sub { print "GOT SIGWINCH"; exit 0 };

my $ppid;
$ppid = getppid();
for (1..3) {
    kill USR2 => $ppid;
    sleep(1);
}

--- out_like chop
SIGUSR2

--- err



=== TEST 7: Forward SIGUSR2 to child process
--- opts: -e 'print(1)'
--- mock_nginx
#!/usr/bin/env perl
use strict;
use warnings;

$SIG{INT}   = sub { print "GOT SIGINT"; exit 0 };
$SIG{HUP}   = sub { print "GOT SIGHUP"; exit 0 };
$SIG{WINCH} = sub { print "GOT SIGWINCH"; exit 0 };

my $ppid;
$ppid = getppid();
for (1..3) {
    kill WINCH => $ppid;
    sleep(1);
}

--- out_like chop
SIGWINCH

--- err



=== TEST 8: Forward SIGHUP to child process
--- opts: -e 'print(1)'
--- mock_nginx
#!/usr/bin/env perl
use strict;
use warnings;

$SIG{INT}   = sub { print "GOT SIGINT"; exit 0 };
$SIG{HUP}   = sub { print "GOT SIGHUP"; exit 0 };
$SIG{WINCH} = sub { print "GOT SIGWINCH"; exit 0 };
$SIG{PIPE} = sub { print "GOT SIGPIPE"; exit 0 };
$SIG{QUIT} = sub { print "GOT SIGQUIT"; exit 0 };

my $ppid;
$ppid = getppid();
for (1..3) {
    kill PIPE => $ppid;
    sleep(1);
}

--- out chop
GOT SIGQUIT
--- ret: 141
--- err



=== TEST 9: Rapidly send SIGWINCH while child is exiting
--- opts: -e 'print(1)'
--- mock_nginx
#!/usr/bin/env perl
use strict;
use warnings;

my $resty_pid = getppid();
my $pid = fork();

if ($pid == 0) {
    for (1..10) {
        kill WINCH => $resty_pid or die "failed to send SIGWINCH";
        sleep(0.001);
    }

    exit(0);
}

for (1..5) {
    sleep(0.001);
}

print("done");
exit(0);

--- out chop
done
--- ret: 0
--- err
