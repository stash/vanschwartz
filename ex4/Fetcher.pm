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

    my @next;
    if ($data) {
        $job->client->debug( "Got ".@$data." statuses\n" );
        push @next, TheSchwartz::Moosified::Job->new(
            funcname => 'LOLifier',
            coalesce => "statuses-$last_id",
            arg => { data => $data },
        );
    }
    push @next, TheSchwartz::Moosified::Job->new(
        funcname => 'Fetcher',
        arg => { %{$job->arg}, since_id => $last_id },
        run_after => time+30,
    );

    # note: two jobs!
    $job->replace_with(@next);
}

sub get_friends {
    my $arg = shift;

    my $creds = decode_json(do { local (@ARGV,$/) = '.creds'; <> });
    my $twit = Net::Twitter->new(%$creds);

    my $statuses = $twit->friends_timeline($arg);
    if (!@$statuses) {
        return (undef, $arg->{since_id});
    }

    print "$_->{id}: $_->{user}{screen_name} $_->{text}\n" for @$statuses;
    my @data = map {
        +{ id=>$_->{id}, text=>$_->{text}, who=>$_->{user}{screen_name} } 
    } @$statuses;

    my $last_id = max map { $_->{id} } @$statuses;

    return (\@data, $last_id);
}

no Moose;
1;
