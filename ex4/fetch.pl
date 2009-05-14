#!/usr/bin/perl
use warnings;
use strict;
use lib 'ex4';

use MySchwartz;
use Fetcher;

use Parallel::ForkManager;

# preload:
use Net::Twitter;
use LWP::UserAgent;
use LWP::Protocol::http;
use JSON::XS;
use DBD::Pg;

my $exit_please = 0;
my $pm = Parallel::ForkManager->new(2);

$SIG{TERM} = $SIG{INT} = sub { kill HUP => -$$ };
$SIG{HUP} = sub { $exit_please = 1 };

while (!$exit_please) {
    my $pid = $pm->start and next; 

    $SIG{TERM} = $SIG{INT} = 'IGNORE';
    eval { run_child() };
    $pm->finish; # Terminates the child process
}
print "Waiting for the kids\n";
$pm->wait_all_children;
print "All done\n";

sub run_child {
    return if $exit_please;

    # run twice in each child before recycling
    my $n = 2;
    my $client = MySchwartz->new;
    $client->can_do('Fetcher');

    while (!$exit_please) {
        $client->work_once();
        last unless --$n;
        last if $exit_please;
        $client->debug("sleeping");
        sleep 5;
    }
    $client->debug("done");
}
