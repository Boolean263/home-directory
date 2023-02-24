# I call this from my .bashrc and .kshrc files.

echo "it works" | grep -q --colour works 2>/dev/null && \
    alias grep="$(which grep) --colour"

alias nssh="ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null"
alias nscp="scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null"

alias rdesk="rdesktop -0 -a 16 -z -x m"

alias ghist="history | grep -v ghist | grep"
alias gitka="gitk --all"
alias gits='git s'

if ls --color=auto > /dev/null 2>&1 ; then
    alias ls="ls --color=auto"
    alias lls="ls --color=never"
    alias ll="ls --color=auto -la --time-style=long-iso"
else
    alias ll="ls -la"
fi
alias gpg="gpg2"

alias ..="cd .."
alias ~="cd ~"
alias -- -="cd -"

alias cp="/bin/cp --preserve=all"

# Runs the previous command as root
alias please='sudo $(fc -ln -1)'

[ -f "~/.bash_aliases.local" ] && . "~/.bash_aliases.local" || :
