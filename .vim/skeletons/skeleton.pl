#!/usr/bin/env perl

use 5.016;
use strict;
use warnings;
use warnings qw(FATAL utf8);  # unicode-based boilerplate comes from
use open IO => ':raw:locale'; # https://stackoverflow.com/questions/6162484
use charnames qw(:full :short);
use feature 'unicode_strings';
use feature 'fc'; # fold case
use utf8;
use autodie qw(:all);

use Getopt::Long qw(:config
    no_ignore_case no_auto_abbrev pass_through bundling);
BEGIN { $Pod::Usage::Formatter = 'Pod::Text::Termcap' if -t STDOUT; }
use Pod::Usage;
use Encode qw(encode decode locale);
use Encode::Locale;
use Unicode::Normalize qw(NFD NFC);

END { close STDOUT }

###
### Functions
###

###
### Main Program
###

# Decode @ARGV if needed (again from the SO question above)
@ARGV = map { decode(locale => $_, Encode::FB_CROAK) } @ARGV;

# Get the options we recognize, leaving others in @ARGV
GetOptions(
    "help|h|?"          => sub { pod2usage(-verbose => 1) },
    "man"               => sub { pod2usage(-verbose => 2) },
) or pod2usage("Use '--help' or '--man' for more information.");

${0}

__END__

=encoding UTF-8

=head1 NAME

${1:`!v expand("%:t")`} - Describe or summarize your script here

=head1 SYNOPSIS

=over 12

=item B<${1:`!v expand("%:t")`}>

I<options>
I<file [file ...]>

=back

=head1 OPTIONS

=over 20

=item B<-h>, B<-?>, B<--help>

Prints a brief help message.

=item B<--man>

Shows the complete man page for this script.

=back

=head1 DESCRIPTION

Give a more detailed description of your script here.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

David Perry, <d.perry@utoronto.ca>

=begin comment

Editor modelines - http://www.wireshark.org/tools/modelines.html

Local variables:
c-basic-offset: 4
tab-width: 4
indent-tabs-mode: nil
coding: utf-8
End:

vi:set shiftwidth=4 tabstop=4 expandtab fileencoding=utf-8:
:indentSize=4:tabSize=4:noTabs=true:coding=utf-8:
