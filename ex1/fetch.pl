#!/usr/bin/perl
use warnings;
use strict;

use Net::Twitter;
use MIME::Base64;
use Data::Dumper;

my $twit = Net::Twitter->new(
    username => 'jstash',
    password => decode_base64('dHcxdHBhc3M='),
);

my $statuses = $twit->friends_timeline({limit => 20});
warn Dumper $statuses;
warn Dumper $twit->rate_limit_status();
