#!/usr/bin/env perl

use strict;
use warnings;

use utf8;
use version 0.77;

sub usage
{
    print STDERR <<EOF;
Usage: $0 ver1 -op ver2
EOF
    exit 8
}

## Main

my %ops = (
    "-lt" => sub { return $_[0] <  $_[1] },
    "-le" => sub { return $_[0] <= $_[1] },
    "-eq" => sub { return $_[0] == $_[1] },
    "-ne" => sub { return $_[0] != $_[1] },
    "-ge" => sub { return $_[0] >= $_[1] },
    "-gt" => sub { return $_[0] >  $_[1] },
);
$ops{"<"}              = $ops{"-lt"};
$ops{"≤"} = $ops{"<="} = $ops{"-le"};
$ops{"="} = $ops{"=="} = $ops{"-eq"};
$ops{"≠"} = $ops{"!="} = $ops{"-ne"};
$ops{"≥"} = $ops{">="} = $ops{"-ge"};
$ops{">"}              = $ops{"-gt"};

usage() if @ARGV != 3;
my ($a, $op, $b) = @ARGV;
$a = version->parse($a);
$b = version->parse($b);

my $ofunc = $ops{$op} or die "Unrecognized operation '$op'\n";
exit( $ofunc->($a, $b) ? 0 : 1 );
