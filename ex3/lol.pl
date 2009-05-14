#!/usr/bin/perl
use warnings;
use strict;
use lib 'ex3';
use MySchwartz;
use LOLifier;

my $client = MySchwartz->new;
$client->can_do('LOLifier');
$client->work;
