Any *.ctags files in this directory are used by universal-ctags.
It does not read the ~/.ctags file.

universal-ctags:
* supports comments starting with '#'
* limits language names to the characters [A-Za-z0-9#+]
* reserves the kind letter "F" and name "file"
* supports more languages

exuberant-ctags:
* can only have alphabetical characters in the name part of tag tagfield

The regen.sh script in this directory reads the files here, strips out
comments and refactors/removes uctags-specific tags, and puts the result
in ~/.ctags for when I only have exuberant-ctags available.

Naming conventions:
• *.ectags - files that are only needed by exuberant-ctags, perhaps because
  universal-ctags has built-in support for the type.
• *.universal.ctags - files that are only supported by universal-ctags.
• *.ctags - files that can work with either (after being massaged by
  regen.sh).
