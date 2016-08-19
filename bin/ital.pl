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
    italic => [ 0x1D434..0x1D467 ],
    bold_italic => [ 0x1D468..0x1D49B ],
    ss_italic => [ 0x1D608..0x1D63B ],
    ss_bold_italic => [ 0x1D63C..0x1D66F ],
    script => [ 0x1D49C, 0x212C, 0x1D49E, 0x1D49F, 0x2130, 0x2131, 0x1D4A2, 0x210B, 0x2110, 0x1D4A5, 0x1D4A6, 0x2112, 0x2133, 0x1D4A9..0x1D4Ac, 0x211B, 0x1D4AE..0x1D4B5,
        0x1D4B6..0x1D4B9, 0x212F, 0x1D4BB, 0x210A, 0x1D4BD..0x1D4C3, 0x2134, 0x1D4C5..0x1D4CF ],
    bold_script => [ 0x1D4D0..0x1D503 ],
    double => [ 0x1D538, 0x1D539, 0x2102, 0x1D53B..0x1D53E, 0x210D, 0x1D540..0x1D544, 0x2115, 0x1D546, 0x2119, 0x211A, 0x211D, 0x1D54A..0x1D550, 0x2124,
    0x1D552..0x1D56B ],
    fraktur => [ 0x1D504, 0x1D505, 0x212D, 0x1D507..0x1D50A, 0x210C, 0x2111, 0x1D50D..0x1D514, 0x211C, 0x1D516..0x1D51C, 0x2128,
    0x1D51E..0x1D537 ],
    bold_fraktur => [ 0x1D56C..0x1D59F ],
    monospace => [ 0x1D670..0x1D6A3 ],
    region => [ 0x1F1E6..0x1F1FF, 0x1F1E6..0x1F1FF ],
);

my ($italic, $bold, $sans_serif, $script, $double, $fraktur, $mono, $region);

GetOptions(
    'italic|i'      => \$italic,
    'bold|b'        => \$bold,
    'sans-serif|s'  => \$sans_serif,
    'script|S'      => \$script,
    'double|d'      => \$double,
    'fraktur|f'     => \$fraktur,
    'monospace|m'   => \$mono,
    'region|r'      => \$region,
    'help|h|?'      => \&usage) or usage();

my $xform =
    $bold && $fraktur ? 'bold_fraktur'
    : $fraktur ? 'fraktur'
    : $double ? 'double'
    : $region ? 'region'
    : $mono ? 'monospace'
    : $bold && $script ? 'bold_script'
    : $script ? 'script'
    : $sans_serif && $bold ? 'ss_bold_italic'
    : $sans_serif ? 'ss_italic'
    : $bold ? 'bold_italic'
    : 'italic';

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
Formats text in italic, optionally with other effects as well, using Unicode.
Usage:
    $0 [options] "whatever"
or
    echo "whatever" | $0 [options]

Options:
    -i, --italic        Make text italic (default)
    -b, --bold          Make text bold
    -s, --sans-serif    Make text sans-serif
    -S, --script        Script text (no italic)
    -f, --fraktur       Fraktur (no italic)
    -d, --double        Double-strike text (no other formatting)
    -m, --monospace     Monospaced text (no other formatting)
    -m, --region        Regional indicator letters (no other formatting)
    -?, -h, --help      This help message

EOT
    exit 1;
}
