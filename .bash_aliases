# Aliases for the Bourne-Again SHell
# chadpbrown@gmail.com

alias l='ls -lF'
alias ll='ls -alF'
alias cd='pushd'
alias bd='popd'
alias clean='rm -i ./.*~ ./*~'
alias dq='df -k ~'
alias where='which'

alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias df-clone='git clone --separate-git-dir=$HOME/.dotfiles https://github.com/c256/.dotfiles.git $HOME'
