alias ll = ls -l
alias v = nvim
alias y = yazi
alias lt = eza --tree --level=2 --long --icons --git

source ~/.zoxide.nu
$env.config.edit_mode = 'vi'
$env.PATH = ($env.PATH | prepend $"($env.HOME)/.cargo/bin")


# carapace
source $"($nu.cache-dir)/carapace.nu"

# starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")


