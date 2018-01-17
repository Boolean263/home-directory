package ${1:`!v expand("%:t:r")`};

use strict;
use warnings;
use utf8;
use version 0.77;

our $VERSION = version->declare("v0.0.1"); # Also update pod docs below

=encoding UTF-8

=head1 NAME

${1:`!v expand("%:t:r")`} - ${2:describe this perl module}

=head1 VERSION

This man page describes version 0.0.1 of this library.

=head1 SYNOPSIS

todo

=head1 METHODS

...

=cut

${0}

return 1 if caller;

=head1 AUTHORS

David Perry, <d.perry@utoronto.ca>

=begin comment

Editor modelines  -  https://www.wireshark.org/tools/modelines.html
#
Local variables:
c-basic-offset: 4
tab-width: 4
indent-tabs-mode: nil
coding: utf-8
End:

vi: set shiftwidth=4 tabstop=4 expandtab fileencoding=utf-8:
:indentSize=4:tabSize=4:noTabs=true:coding=utf-8:
