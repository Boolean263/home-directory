#!/usr/bin/env python

import site
import sys
import sysconfig
import os
import os.path
import importlib.util

import argparse

parser = argparse.ArgumentParser(
    description="Print useful information about the current Python interpreter.")
parser.add_argument('-m', '--module', type=str, action='append', help='Python modules to locate')
args = parser.parse_args()

sc = sysconfig.get_config_vars()

if sys.prefix == sys.base_prefix:
    dif = "these are the same, so this IS NOT a virtual environment."
else:
    dif = "these are different, so this IS a virtual environment."

try:
    # Added in 3.10
    scheme = sysconfig.get_default_scheme()
except AttributeError:
    # Existed in earlier versions but was considered private
    scheme = sysconfig._get_default_scheme()

print(f"""
Python executable: {sys.executable}
Version {sc['py_version']} for {sysconfig.get_platform()}
Interpreter location  (sys.prefix): {sys.prefix}
Library location (sys.base_prefix): {sys.base_prefix}
... {dif}
Installation scheme: {scheme}
User site packages enabled (site.ENABLE_USER_SITE): {site.ENABLE_USER_SITE}
""".strip())

print(f"User base path (site.USER_BASE): {site.USER_BASE}", end='')
if os.environ.get('PYTHONUSERBASE'):
    print(" (from $PYTHONUSERBASE)", end='')
else:
    print(" (default location)", end='')
if os.path.exists(site.USER_BASE):
    print(" (exists)")
else:
    print(" (missing)")

print(f"User site path (site.USER_SITE): {site.USER_SITE}", end='')
if os.path.exists(site.USER_SITE):
    print(" (exists)")
else:
    print(" (missing)")

if False:
    print("Site prefixes (site.PREFIXES):")
    for p in site.PREFIXES:
        print(f"    {p}")
    print()

print("Module search path (sys.path):")
for p in sys.path:
    print(f"    {p}")
print()

if False:
    print("Site package directories (site.getsitepackages()):")
    for p in site.getsitepackages():
        print(f"    {p}")
    print()

if args.module:
    print("Module locations:")
    for m in args.module:
        spec = importlib.util.find_spec(m)
        print(f"    {m}: {spec.origin if spec else 'Not found'}")
