# {{{1 Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}1

compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
export HISTFILE="$XDG_STATE_HOME/zsh/history"

# I got this idea from https://github.com/tomsquest/dotfiles
source $ZDOTDIR/oh-my-zsh.zsh
source $ZDOTDIR/config.zsh
#source $ZDOTDIR/completion.zsh
source $ZDOTDIR/aliases.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
