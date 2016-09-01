#!/usr/bin/env perl

use 5.016;
use strict;
use warnings;

use Getopt::Long qw(:config bundling permute no_ignore_case);
use List::MoreUtils ();

binmode( STDIN, ':raw:utf8' );
binmode( STDOUT, ':raw:utf8' );
binmode( STDERR, ':raw:utf8' );

my @alphabet = ('A'..'Z', 'a'..'z');
my %transforms = (
    region => [ 0x1F1E6..0x1F1FF, 0x1F1E6..0x1F1FF ],
    circled => [ 0x24B6..0x24E9 ],
    neg_circled => [ 0x1F150..0x1F169, 0x1F150..0x1F169 ],
    squared => [ 0x1F130..0x1F149, 0x1F130..0x1F149 ],
    neg_squared => [ 0x1F170..0x1F189, 0x1F170..0x1F189 ],
    paren => [ 0x1F110..0x1F129, 0x249C..0x24B5 ],
);

my ($region, $circled, $squared, $paren, $negative);

GetOptions(
    'region|r'      => \$region,
    'circled|c'     => \$circled,
    'squared|s'     => \$squared,
    'negative|n'    => \$negative,
    'parenthesized|p' => \$paren,
    'help|h|?'      => \&usage) or usage();

my $xform =
    $negative && $circled ? 'neg_circled'
    : $negative && $squared ? 'neg_squared'
    : $circled ? 'circled'
    : $squared ? 'squared'
    : $paren ? 'paren'
    : $region ? 'region'
    : usage();

my %xform = List::MoreUtils::pairwise { $a => chr($b) } @alphabet, @{$transforms{$xform}};

if(@ARGV)
{
    my $str = join(' ', @ARGV);
    $str =~ s/([A-Za-z])/$xform{$1}/eg;
    print $str."\n";
}
else
{
    while(<>)
    {
        s/([A-Za-z])/$xform{$1}/eg;
        print;
    }
}
exit 0;

### Subroutines

sub usage
{
    print STDERR <<EOT;
Translates letters in arguments or stdin to symbol versions of various kinds.
Usage:
    $0 [options] "whatever"
or
    echo "whatever" | $0 [options]

Options:
    -r, --region        Regional indicator letters
    -c, --circled       Circled letters (see also -n)
    -s, --squared       Squared letters (see also -n)
    -p, --parenthesized Parenthesized letters
    -n, --negative      Negative style if available
    -?, -h, --help      This help message

EOT
    exit 1;
}
