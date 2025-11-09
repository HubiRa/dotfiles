# # Disable the default greeting
# set -g fish_greeting

# Path
set -gx PATH $HOME/.local/bin $PATH

# Editor
set -gx EDITOR nvim

# Aliases
alias ll='ls -lh --color=auto'
alias la='ls -A --color=auto'
alias l='ls --color=auto'
alias gs='git status'
alias gc='git commit'
alias gl='git pull'
alias gp='git push'

# Abbreviations
abbr --add gco 'git checkout'
abbr --add v nvim
abbr --add y yazi

# Load fisher if available
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    source $XDG_CONFIG_HOME/fish/functions/fisher.fish
end

# Useful bindings
bind \cr 'commandline -r (history --prefix (commandline --current-token) | head -n1)'

# Autojump (z command)
if type -q zoxide
    zoxide init fish | source
end

# # Optional: Tide prompt
# if type -q tide
#     tide configure
# end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval /Users/hubi/opt/miniconda3/bin/conda "shell.fish" hook $argv | source
# <<< conda initialize <<<
#

# carapace
set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
carapace _carapace | source
