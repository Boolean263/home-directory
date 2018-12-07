#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# If you're using python2
from __future__ import nested_scopes, generators, division, absolute_import, \
    with_statement, print_function, unicode_literals

import sys
import argparse

##
## Functions
##

${0:# (functions go here)}

##
## Main Program
##
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="${1:summarize your script}")
    parser.add_argument("-v", "--verbose",
            action="count", default=0,
            help="Increase verbosity")

    args = parser.parse_args()


# Editor modelines - http://www.wireshark.org/tools/modelines.html
#
# Local variables:
# c-basic-offset: 4
# tab-width: 4
# indent-tabs-mode: nil
# coding: utf-8
# End:
#
# vi:set shiftwidth=4 tabstop=4 expandtab fileencoding=utf-8:
# :indentSize=4:tabSize=4:noTabs=true:coding=utf-8:
