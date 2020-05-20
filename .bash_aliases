# I call this from my .bashrc and .kshrc files.

echo "it works" | grep -q --colour works 2>/dev/null && \
    alias grep="$(which grep) --colour"

alias nssh="ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null"
alias nscp="scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null"

alias rdesk="rdesktop -0 -a 16 -z -x m"

alias ghist="history | grep"
alias gitka="gitk --all"
alias gits='git s'

if ls --color=auto > /dev/null 2>&1 ; then
    alias ls="ls --color=auto"
    alias lls="ls --color=never"
    alias ll="ls --color=auto -la"
fi
alias gpg="gpg2"

alias ll="ls -la"

alias ..="cd .."
alias ~="cd ~"
alias -- -="cd -"
