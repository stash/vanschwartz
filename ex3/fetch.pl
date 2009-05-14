#!/usr/bin/perl
use warnings;
use strict;
use lib 'ex3';

use MySchwartz;
use Fetcher;

my $client = MySchwartz->new;
$client->can_do('Fetcher');
print "Fetcher begining work\n";
$client->work();
