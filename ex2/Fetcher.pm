package Fetcher;
use Moose;
use MySchwartz;
use Net::Twitter;
use JSON::XS;
use List::Util qw(max);

extends 'TheSchwartz::Moosified::Worker';

sub work {
    my $class = shift;
    my $job = shift;
    my ($data,$last_id) = get_friends($job->arg);

    my $for_processing = TheSchwartz::Moosified::Job->new(
        funcname => 'LOLifier',
        arg => { data => $data },
    );
    $job->replace_with($for_processing); # calls ->completed
}

sub get_friends {
    my $arg = shift;

    my $creds = decode_json(do { local (@ARGV,$/) = '.creds'; <> });
    my $twit = Net::Twitter->new(%$creds);

    my $statuses = $twit->friends_timeline($arg);
    print "Got ".@$statuses." statuses\n";

    my @data = map {
        +{ id=>$_->{id}, text=>$_->{text}, who=>$_->{user}{screen_name} } 
    } @$statuses;

    my $last_id = max map { $_->{id} } @$statuses;

    return (\@data, $last_id);
}

no Moose;
1;
