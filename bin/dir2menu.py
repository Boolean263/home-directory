#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
import re
import argparse
import xml.etree.cElementTree as ET

import xdg.DesktopEntry

# Code inspired by openbox-xdg-menu (openbox)
theme = None
try:
    import gi
    gi.require_version('Gtk', '3.0')
    from gi.repository import Gtk
    theme = Gtk.IconTheme.get_default()
except ImportError:
    pass

def icon_attr(entry):
    "Get the full path to an icon based on a label or desktop entry."
    try:
        name = entry.getIcon()
    except AttributeError:
        name = entry

    if os.path.exists(name):
        return name

    if not theme:
        return ''

    # Work around broken .desktop files
    # (unless the icon is a full path it should not have an extension)
    name = re.sub('\..{3,4}$', '', name)

    # imlib2 can't load svg files
    iconinfo = theme.lookup_icon(name, 22, Gtk.IconLookupFlags.NO_SVG)
    if iconinfo:
        iconfile = iconinfo.get_filename()
        if hasattr(iconinfo, 'free'):
            iconinfo.free()
        if iconfile:
            return iconfile
    return ''


##
## Main Program
##
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Generate an OpenBox pipe menu from .desktop files in a directory")
    parser.add_argument("-v", "--verbose",
            action="count", default=0,
            help="Increase verbosity")
    parser.add_argument("directory",
            type=os.path.abspath,
            metavar="DIR",
            help="Directory to use")

    args = parser.parse_args()

    udir = args.directory
    if not os.path.isdir(udir):
        parser.error("Argument must be a directory")

    subdirs = []
    entries = {}
    for filename in os.listdir(udir):
        filename = os.path.join(udir, filename)
        if os.path.isdir(filename):
            subdirs.append(filename)
            continue

        try:
            rv = xdg.DesktopEntry.DesktopEntry(filename)
        except xdg.Exceptions.ParsingError:
            continue
        if not rv.getHidden():
            entries[rv.getName()] = rv

    outdoc = ET.Element("openbox_pipe_menu")
    for v in sorted(subdirs):
        menu = ET.SubElement(outdoc, "menu", id=v, label=os.path.basename(v),
                execute=sys.argv[0]+" "+v, icon=icon_attr("folder"))
    for k, v in sorted(entries.items()):
        el = ET.SubElement(outdoc, "item", label=k, icon=icon_attr(v))
        act = ET.SubElement(el, "action", name="Execute")
        exe = ET.SubElement(act, "execute")
        exe.text = v.getExec()

    tree = ET.ElementTree(outdoc)
    tree.write(sys.stdout.buffer, encoding="UTF-8")


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
