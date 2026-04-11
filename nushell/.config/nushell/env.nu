$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

mkdir ~/.cache
mkdir ~/.local/share/atuin

if ('~/.zoxide.nu' | path exists) == false {
  '' | save -f ~/.zoxide.nu
}
if ('~/.cache/carapace.nu' | path exists) == false {
  '' | save -f ~/.cache/carapace.nu
}
if ('~/.local/share/atuin/init.nu' | path exists) == false {
  '' | save -f ~/.local/share/atuin/init.nu
}

if (which zoxide | is-not-empty) {
  zoxide init nushell | save -f ~/.zoxide.nu
}

if (which carapace | is-not-empty) {
  carapace _carapace nushell | save --force ~/.cache/carapace.nu
}

if (which atuin | is-not-empty) {
  atuin init nu | save -f ~/.local/share/atuin/init.nu
}

