#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Getopt::Long qw(:config
    no_ignore_case no_auto_abbrev pass_through bundling);
BEGIN { $Pod::Usage::Formatter = 'Pod::Text::Termcap' if -t STDOUT; }
use Pod::Usage;

###
### Functions
###

###
### Main Program
###

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
