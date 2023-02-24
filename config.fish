set -x PATH /usr/local/bin /opt/homebrew/bin ~/.asdf/shims $PATH
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/darrellbanks/opt/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

