set fish_greeting ""

set -gx TERM xterm-256color

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
alias lg lazygit
alias ide "source /Users/seanchen/my_bash/ide.sh"
alias proxy "export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890"

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

set -U fish_user_paths /opt/homebrew/bin/ $fish_user_paths

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
    status --is-command-substitution; and return

    if test -f .nvmrc; and test -r .nvmrc
        nvm use
    else
    end
end
function nvm
    bass source /opt/homebrew/opt/nvm/nvm.sh';' nvm $argv
end

# Set nvm default node PATH on startup (so globally installed packages like pnpm persist across sessions)
set -l _nvm_node_dir "$HOME/.nvm/versions/node"
if test -d "$_nvm_node_dir"
    set -l _nvm_node_bin ""
    
    # Get the latest installed node version (sorted by version number)
    set -l _nvm_latest (command ls -1 "$_nvm_node_dir" | sort -V | tail -1)
    if test -n "$_nvm_latest"; and test -d "$_nvm_node_dir/$_nvm_latest/bin"
        set _nvm_node_bin "$_nvm_node_dir/$_nvm_latest/bin"
    end

    if test -n "$_nvm_node_bin"
        fish_add_path --prepend "$_nvm_node_bin"
    end
end

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
