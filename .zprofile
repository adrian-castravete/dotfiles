export HOMEBREW_NO_ANALYTICS=1

export PATH="$HOME/.cargo/bin:$PATH"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

[ -s "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"
