#!/usr/bin/env python3

import argparse
import logging
import os
import sys

# This script uses logging for its informational output.
# For any sort of informational message that isn't part of this script's
# intended function, you can use `log.debug()`/`.info()`/`.warning()`/
# `.error()`/`.critical()` to get the message out. The default output level
# is set to warning in the main function, adjusted as high as critical or as
# low as debug by user options.
log = logging.getLogger(__name__)
log.addHandler(logging.NullHandler())

#
# Functions
#


def create_console_logger(verbose: int):
    """
    Create a console logger and set its verbosity from
    command-line arguments.
    """
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(logging.Formatter("%(levelname)s: %(message)s"))
    log.addHandler(console_handler)
    if args.verbose < 1:
        console_handler.setLevel(logging.ERROR)
    elif args.verbose == 1:
        console_handler.setLevel(logging.WARN)
    elif args.verbose == 2:
        console_handler.setLevel(logging.INFO)
    else:
        console_handler.setLevel(logging.DEBUG)
    # sub-loggers are limited to what the master logger will log
    if log.level == 0:
        log.setLevel(min((x.level for x in log.handlers)))


${0:# (additional functions go here)}


#
# Main Program
#
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="${1:summarize your script}")
    parser.add_argument(
        "-v", "--verbose", action="count", default=1, help="Increase verbosity"
    )
    parser.add_argument(
        "-q", "--quiet", action="count", default=0, help="Decrease verbosity"
    )

    args = parser.parse_args()
    create_console_logger(args.verbose - args.quiet)

    # Continue with your main script activity here
