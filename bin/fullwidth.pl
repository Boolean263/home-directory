#!/usr/bin/env perl

use 5.016;
use strict;
use warnings;

use Getopt::Long;

binmode( STDIN, ':utf8' );
binmode( STDOUT, ':utf8' );
binmode( STDERR, ':utf8' );

GetOptions('help|h|?'      => \&usage) or usage();

while(<>)
{
    for my $c (unpack 'W*', $_)
    {
        if($c == 0x20)
        {
            $c = 0x3000;
        }
        elsif($c >= 0x21 && $c <= 0x7E)
        {
                $c += 0xFEE0;
        }
        print pack('W', $c);
    }
}
exit 0;

### Subroutines

sub usage
{
    print STDERR <<EOT;
Converts ASCII text to fullwidth Unicode characters.

Usage:
    echo "whatever" | $0

Options:
    -?, -h, --help      This help message

EOT
    exit 1;
}
