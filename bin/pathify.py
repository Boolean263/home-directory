#!/usr/bin/env python3

import sys
import argparse
import os
import re

from collections import OrderedDict
from collections.abc import Mapping

#
# Globals
#

global separator
global verbose
verbose = 0

#
# Functions
#

def verbecho(level, msg):
    if verbose >= level:
        print(msg, file=sys.stderr)


def to_OD(aIn):
    """
    Convert a path string or a list into an ordered dict.
    """
    rv = OrderedDict()

    if type(aIn) is str:
        aIn = aIn.split(separator)

    for item in aIn:
        rv[item] = 1

    verbecho(2, "to_OD: {} => {}".format(aIn, rv))
    return rv


def outpath(pathvar, paths):
    """
    Print the new path variable in a manner suitable for parsing
    by the shell.
    """
    if isinstance(paths, Mapping):
        paths = paths.keys()
    outcmd = "eval export {0}={1}".format(pathvar, separator.join(paths)
                                     .replace(" ", "\\ "))
    verbecho(1, outcmd)
    print(outcmd)


#
# Main Program
#
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="TBD")
    parser.add_argument(
        "-v", "--verbose", action="count", default=0, help="Increase verbosity"
    )
    parser.add_argument(
        "-s",
        "--separator",
        metavar="SEP",
        type=str,
        default=":",
        help="Separator to use between search paths (currently ignored)",
    )
    parser.add_argument(
        "pathvar", metavar="PATHVAR", help="Path variable upon which to operate"
    )
    subparsers = parser.add_subparsers(
        title="Actions",
        dest="action",
        required=True,
    )
    subparsers.add_parser("clean", help="Remove duplicate path entries")
    subparsers.add_parser("show", help="Show the current paths as a list")

    p_add = subparsers.add_parser("add", help="Add entries to the path list")
    p_add.add_argument(
        "-e",
        dest="append",
        action="store_true",
        help="Add to end of pathvar (default: add to start)",
    )
    p_add.add_argument(
        "-f",
        dest="force",
        action="store_true",
        help="Force-add (remove if already existing)",
    )
    p_add.add_argument("paths", nargs="+", type=str, help="Paths to add")

    p_del = subparsers.add_parser("del", help="Remove entries from path list")
    p_del.add_argument("paths", nargs="+", type=str, help="Paths to delete")

    args = parser.parse_args()
    verbose = args.verbose
    separator = args.separator
    if os.getenv(args.pathvar) is None:
        parser.error(
            "{0} does not appear to be a valid path variable".format(args.pathvar)
        )

    paths = to_OD(os.getenv(args.pathvar))

    if args.action == "clean":
        outpath(args.pathvar, paths)

    elif args.action == "show":
        for item in os.getenv(args.pathvar).split(separator):
            print(item)

    elif args.action == "add":
        new_paths = list(to_OD(args.paths).keys())
        if args.force:
            for item in new_paths:
                paths.pop(item, None)
        else:
            new_paths = [x for x in new_paths if x not in paths]

        if args.append:
            for item in new_paths:
                paths[item] = 1
        else:
            for item in paths.keys():
                new_paths.append(item)
            paths = new_paths

        outpath(args.pathvar, paths)

    elif args.action == "del":
        for item in args.paths:
            paths.pop(item, None)

        outpath(args.pathvar, paths)

    else:
        parser.error("Unrecognized command '{0}'".format(args.action))


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
