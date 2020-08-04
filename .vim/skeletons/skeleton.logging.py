#!/usr/bin/env python3

import argparse
import logging
import sys

# This script uses logging for its informational output.
# For any sort of informational message that isn't part of this script's
# intended function, you can use `logger.debug()`/`.info()`/`.warning()`/
# `.error()`/`.critical()` to get the message out. The default output level
# is set to warning in the main function, adjusted as high as critical or as
# low as debug by user options.
logger = logging.getLogger(__name__)
logger.addHandler(logging.NullHandler())

#
# Functions
#


def between(input, lower=0, upper=100):
    "Return the input, or the lower or upper bound if the input is beyond those."
    return max(lower, min(input, upper))


${0:# (additional functions go here)}

#
# Main Program
#
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="${1:summarize your script}")
    parser.add_argument(
        "-v", "--verbose", action="count", default=0, help="Increase verbosity"
    )
    parser.add_argument(
        "-q", "--quiet", action="count", default=0, help="Decrease verbosity"
    )

    args = parser.parse_args()

    # Set up console logging
    loghandler = logging.StreamHandler(stream=sys.stderr)
    loghandler.setFormatter(logging.Formatter(style="{", fmt="{levelname}: {message}"))
    logger.addHandler(loghandler)
    verbosity = between(
        logging.WARNING + (10 * (args.quiet - args.verbose)),
        logging.DEBUG,
        logging.CRITICAL,
    )
    logger.setLevel(verbosity)

    # Continue with your main script activity here


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
