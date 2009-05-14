#!/usr/bin/perl
use warnings;
use strict;

use Net::Twitter;
use Data::Dumper;
use JSON::XS;

my $creds = decode_json(do { local (@ARGV,$/) = '.creds'; <> });

my $twit = Net::Twitter->new(%$creds);

my $statuses = $twit->friends_timeline();
warn Dumper $statuses;
warn Dumper $twit->rate_limit_status();
