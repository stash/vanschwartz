package LOLifier;
use Moose;
use MySchwartz;
use Acme::LOLCAT;
use Fcntl;
use DB_File;

extends 'TheSchwartz::Moosified::Worker';

override 'retry_delay' => sub { 10 };
override 'max_retries' => sub { 99 };

sub work {
    my $class = shift;
    my $job = shift;
    
    my $filename = './lol.db';
    my %lols;
    my $db = tie(%lols, DB_File => 
            $filename, O_RDWR|O_CREAT, 0666, $DB_File::DB_BTREE)
        or die "Cannot open file ’$filename’: $!\n" ;

    for my $status (@{ $job->arg->{data} }) {
        next if exists $lols{$status->{id}};
        my $i_lold = translate($status->{text});
        my $text = "$status->{who}: $i_lold";
        print "$text\n";

        die "wot" if $i_lold =~ /kthxbye$/i;

        $lols{$status->{id}} = $i_lold;
    }

    undef $db;
    untie %lols;

    $job->completed();
}

no Moose;
1;
