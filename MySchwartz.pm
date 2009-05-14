package MySchwartz;
use Moose;
use DBD::Pg;
use TheSchwartz::Moosified;

extends 'TheSchwartz::Moosified';
has '+databases' => ( default => \&connect );
has '+verbose' => ( default => sub { \&log_with_pid } );

our $dsn = "dbi:Pg:database=vanpm";
our $DBH;

sub connect {
    return [$DBH] if $DBH;
    my $dbh = DBI->connect($dsn, $ENV{USER}, "",  {
        AutoCommit => 1,
        pg_enable_utf8 => 1,
        PrintError => 0,
        RaiseError => 0,
    });
    print "Connected to DB ($$)\n" if $dbh;
    die "Can't connect to DB\n" unless $dbh;
    $DBH = $dbh;
    return [$DBH];
}

sub disconnect {
    return unless $DBH;
    $DBH->disconnect();
    undef $DBH;
}

sub log_with_pid {
    my $msg = shift;
    $msg =~ s/\s+$//;
    print STDERR "$$: $msg\n";
}

no Moose;
1;
