#!/usr/bin/perl
use warnings;
use strict;
use lib 'ex4';

use MySchwartz;

my $client = MySchwartz->new;

for (1..4) {
    my $jobh = $client->insert(Fetcher => {});
    print "Added job ".$jobh->jobid."\n";
    sleep 3;
}
