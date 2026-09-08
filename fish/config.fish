set fish_greeting ""

set -gx TERM xterm-256color

#Homebrew
eval (/opt/homebrew/bin/brew shellenv)
fish_add_path -a /usr/local/bin

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
command -qv nvim && alias vim nvim

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

#Combine EZA and FZF
#Use lf to view and select files
function lf
    eza -l -g --icons | fzf --preview '
        if test -d {}
            eza --icons --color=always {}
        else
            eza -l --icons --color=always {}
        end
    '
end

#Use browse to browse and enter directories
function browse
    set -l selected_dir (ll | fzf --preview 'eza -l --icons {}' | awk '{print $NF}')
    if test -n "$selected_dir"
        if test -d "$selected_dir"
            cd "$selected_dir"
        end
    end
end

#Use ef to browse for files and open or enter directories with the editor.
function ef
    set -l selected_file (eza -la --icons | fzf --preview 'bat --style=numbers --color=always {} 2>/dev/null || eza -l --icons {}' --preview-window=right:60%)
    if test -n "$selected_file"
        set -l filename (echo "$selected_file" | awk '{print $NF}')
        if test -d "$filename"
            cd "$filename"
        else if test -f "$filename"
            $EDITOR "$filename"
        end
    end
end

# Set Yazi to y
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    command rm -f -- "$tmp"
end

# Zed 快捷打开函数
function ze --description "Open current directory or specified file in Zed"
    if test (count $argv) -eq 0
        zed .
    else
        zed $argv
    end
end

# Set language to English
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
fnm env --use-on-cd --shell fish --log-level quiet | source
zoxide init fish | source
starship init fish | source
