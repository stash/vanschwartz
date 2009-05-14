#!/usr/bin/perl
use warnings;
use strict;
use lib 'ex2';

use MySchwartz;

my $client = MySchwartz->new;
my $jobh = $client->insert(Fetcher => {});
print "Added job ".$jobh->jobid."\n";
