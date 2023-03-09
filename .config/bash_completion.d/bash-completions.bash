#!/bin/bash

# Bash completions for bash itself. Mainly an excuse for me to
# noodle around and learn bash completion.

_bash_test_completion()
{
    # Many tests start with a dash. Get those first.
    local test_lines
    readarray -t test_lines <<'EOT'
-a file     [exists]
-b file     [is block special]
-c file     [is char special]
-d file     [is directory]
-e file     [exists]
-f file     [is regular file]
-g file     [is setgid]
-h file     [is symlink]
-k file     [has sticky bit]
-p file     [is named pipe]
-r file     [is readable]
-s file     [has size >0]
-t fd       [is terminal]
-u file     [is setuid]
-x file     [is executable]
-G file     [owned by EGID]
-L file     [is symlink]
-N file     [modified since read]
-O file     [owned by EUID]
-S file     [is socket]
-o opt      [option enabled]
-v var      [var has value]
-R var      [var is name ref]
-z string   [length = 0]
-n string   [length > 0]
EOT
    local test_words=($(echo -- "${test_lines[*]}" | grep -Eo -- '-[A-Za-z]'))
    if [ "${#COMP_WORDS[@]}" = "2" ] ; then
            case "${COMP_WORDS[1]}" in
                '')
                    # They typed 'test' or '[' then pressed Tab.
                    # Add other tests to the output we give back
                    readarray -O ${#test_lines[@]} -t test_lines <<'EOT'
file1 -ef file2     [same inode]
file1 -nt file2     [file1 newer]
file1 -ot file2     [file1 older]
string1 = string2   [strings equal]
string1 != string2  [strings different]
string1 < string2   [string1 earlier]
string1 > string2   [string1 later]
num1 -eq num2       [num1 = num2]
num1 -ne num2       [num1 ≠ num2]
num1 -lt num2       [num1 < num2]
num1 -le num2       [num1 ≤ num2]
num1 -gt num2       [num1 > num2]
num1 -ge num2       [num1 ≥ num2]
EOT
                    COMPREPLY=("${test_lines[@]}")
                    ;;
                -*)
                    # They've typed (part of?) a test, see if there's
                    # only one possibility
                    local suggestions=($(compgen -W "${test_words[*]}" -- "${COMP_WORDS[1]}"))
                    if [ "${#suggestions[@]}" = "1" ] ; then
                        # Just the one hit, give it to them
                        COMPREPLY=("${suggestions[0]}")
                    else
                        # Multiple hits, show the descriptions with the options
                        COMPREPLY=("${test_lines[@]}")
                    fi
                    ;;
                *)
                    # Not a test we know how to handle. Punt it back to bash's usual way
                    COMPREPLY=($(compgen -A file -A directory -A variable -- "${COMP_WORDS[1]}"))
                    ;;
            esac
    fi
}

complete -F _bash_test_completion '[' test
