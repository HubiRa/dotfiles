alias ll = ls -l
alias v = nvim
alias y = yazi
alias lt = eza --tree --level=2 --long --icons --git

$env.config.edit_mode = 'vi'
$env.PATH = ($env.PATH | prepend $"($env.HOME)/.cargo/bin")

let starship_autoload_dir = ($nu.data-dir | path join "vendor" "autoload")
mkdir $starship_autoload_dir
if (which starship | is-not-empty) {
  starship init nu | save -f ($starship_autoload_dir | path join "starship.nu")
}

