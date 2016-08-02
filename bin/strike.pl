#!/usr/bin/env perl

use 5.016;
use strict;
use warnings;

binmode( STDIN, ':raw:utf8' );
binmode( STDOUT, ':raw:utf8' );
binmode( STDERR, ':raw:utf8' );

use Getopt::Long qw(:config bundling permute no_ignore_case);

my $stk = "";

my %charmap = (
    "strikeout|s" => "\x{0336}",        # COMBINING LONG STROKE OVERLAY
    "overline|o" => "\x{0305}",         # COMBINING OVERLINE
    "double-overline|O" => "\x{033F}",  # COMBINING DOUBLE OVERLINE
    "underline|u" => "\x{0332}",        # COMBINING LOW LINE
    "double-underline|U" => "\x{0333}", # COMBINING DOUBLE LOW LINE
    "solidus|slash|S" => "\x{0338}",    # COMBINING LONG SOLIDUS OVERLAY
    "circle|c" => "\x{20DD}",           # COMBINING ENCLOSING CIRCLE
    "square|q" => "\x{20DE}",           # COMBINING ENCLOSING SQUARE
    "diamond|d" => "\x{20DF}",          # COMBINING ENCLOSING DIAMOND
    "screen" => "\x{20E2}",             # COMBINING ENCLOSING SCREEN
    "keycap|k" => "\x{20E3}",           # COMBINING ENCLOSING KEYCAP
    "triangle|t" => "\x{20E4}", # COMBINING ENCLOSING UPWARD POINTING TRIANGLE
    "dotted-underline|D" => "\x{0324}", # COMBINING DIARESIS BELOW
);

my @optsArgs = ();

for( keys %charmap ) {
    push @optsArgs, $_, \&addChar;
}

GetOptions( @optsArgs,
    "hex=s" => \&getHex,
    "help|h" => \&usage );

$stk ||= "\x{0336}";   # default: overstrike

while(<>) {
    chomp;
    print strike($stk, $_)."\n";
}

sub strike {
    my ($j, $str) = @_;
    return join($j, split(//,$str)).$j;
}

sub getHex {
    my ($optname, $optval) = @_;
    $optval =~ /^([0-9A-Fa-f]{1,4})$/ or die "invalid hex string";
    $stk .= chr(hex($1));
}

sub usage {
    print STDERR <<EOT;
Reads text from stdin, and overlays one or more Unicode combining characters
over each character before printing them to stdout.

Options can be combined.  Whole words are specified with double dashes;
single-character options with single dashes (and they can also be combined).
If no options are specified, assumes --strikeout.

Options available:
EOT
    my $sample = "like this";
    my $colLen = 0;
    for( keys %charmap ) {
        $colLen = length($_) if length($_) > $colLen;
    }
    $colLen += 5;
    for( keys %charmap ) {
        my $p = $_;
        $p =~ s/\|/,/g;
        print STDERR "    ".$p
            .(" " x ($colLen-length($p)))
            .strike($charmap{$_}, $sample)."\n";
    }

    my $hexMsg = "hex=XXXX";
    print STDERR "    ".$hexMsg
        .(" " x ($colLen-length($hexMsg)))
        ."inserts unicode character at codepoint\n"
        .(" " x ($colLen+5))
        ."U+XXXX (hex) after each character\n";
    exit;
}

sub addChar {
    my ($optname, $optval) = @_;
    for( keys %charmap ) {
        my $opt = $_;
        $opt =~ s/\|.*$//;
        $stk .= $charmap{$_} if $opt eq $optname;
    }
}

