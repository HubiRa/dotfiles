# Disable the default greeting
set -g fish_greeting

# Path
fish_add_path --global $HOME/.local/bin
fish_add_path --global $HOME/.cargo/bin

function __dotfiles_resolve_config_path
    set -l target $argv[1]

    if type -q path
        set -l resolved (path resolve $target 2>/dev/null)
        if test -n "$resolved"
            echo $resolved
            return
        end
    else if command -q realpath
        set -l resolved (realpath $target 2>/dev/null)
        if test -n "$resolved"
            echo $resolved
            return
        end
    end

    if command -q readlink
        set -l depth 0
        while test $depth -lt 40
            set depth (math $depth + 1)
            set -l link_target (readlink $target 2>/dev/null)
            if test -z "$link_target"
                break
            end

            if string match -q '/*' -- $link_target
                set target $link_target
            else
                set target (dirname $target)/$link_target
            end
        end
    end

    set -l target_dir (dirname $target)
    set -l target_name (basename $target)
    set -l physical_dir (cd $target_dir 2>/dev/null; and pwd -P)

    if test -n "$physical_dir"
        echo $physical_dir/$target_name
    else
        echo $target
    end
end

set -l config_file (__dotfiles_resolve_config_path (status --current-filename))
functions -e __dotfiles_resolve_config_path

set -l dotfiles_dir (dirname (dirname (dirname (dirname $config_file))))
set -l commands_dir $dotfiles_dir/commands
if test -d $commands_dir
    fish_add_path --global $commands_dir
end

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

if not status is-interactive
    return
end

# Aliases
if type -q eza
    alias ll='eza -lh --icons --git'
    alias la='eza -la --icons --git'
    alias l='eza --icons'
else if command ls --color=auto /dev/null >/dev/null 2>&1
    alias ll='ls -lh --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls --color=auto'
else
    alias ll='ls -lhG'
    alias la='ls -AG'
    alias l='ls -G'
end
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
    set -l fisher_path $XDG_CONFIG_HOME/fish/functions/fisher.fish
    test -f $fisher_path; and source $fisher_path
end

# Useful bindings
fish_vi_key_bindings
bind \cr 'commandline -r (history --prefix (commandline --current-token) | head -n1)'

# Prompt, history, completions, and autojump
if type -q starship
    starship init fish | source
end

if type -q atuin
    atuin init fish | source
end

if type -q zoxide
    zoxide init fish | source
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval /Users/hubi/opt/miniconda3/bin/conda "shell.fish" hook $argv | source
# <<< conda initialize <<<
#

# Carapace
set -gx CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
if type -q carapace
    carapace _carapace fish | source
end
