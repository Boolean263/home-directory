#!/usr/bin/env perl

use 5.016;
use strict;
use warnings;
use utf8;
use feature 'unicode_strings';

use Getopt::Long;
use Encode qw(encode decode);

binmode( STDIN, ':encoding(UTF-8)' );
binmode( STDOUT, ':encoding(UTF-8)' );
binmode( STDERR, ':encoding(UTF-8)' );

GetOptions('help|h|?'      => \&usage) or usage();

while(<>)
{
    s/(.)/fullwidth($1)/eg;
    print;
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

sub fullwidth
{
    my $c = ord(shift);
    if($c == 0x20)
    {
        $c = 0x3000;
    }
    elsif($c >= 0x21 && $c <= 0x7E)
    {
        $c += 0xFEE0;
    }
    return chr($c);
}
