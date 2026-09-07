if type -q eza
  alias ll "eza -l -g --icons"
  alias lla "ll -a"
  alias ll2 "ll --tree --level=2 -a"
  alias ll3 "ll --tree --level=3 -a"
  alias lls "ll -s size"
end

# Inkdrop
set -gx INKDROP_HOME ~/.inkdrop

# Fzf
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0
