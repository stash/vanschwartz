package MySchwartz;
use Moose;
use DBD::Pg;
use TheSchwartz::Moosified;

extends 'TheSchwartz::Moosified';

my $dsn = "dbi:Pg:database=vanpm";

our $DBH = DBI->connect($dsn, $ENV{USER}, "",  {
    AutoCommit => 1,
    pg_enable_utf8 => 1,
    PrintError => 0,
    RaiseError => 0,
});

has '+databases' => (
    default => sub { [ $DBH ] },
);

no Moose;
1;
