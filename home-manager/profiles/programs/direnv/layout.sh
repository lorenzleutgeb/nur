: ${XDG_DATA_HOME:=$HOME/.local/share}
declare -A direnv_layout_dirs
direnv_layout_dir() {
    echo "${direnv_layout_dirs[$PWD]:=$(
        echo -n "$XDG_DATA_HOME"/direnv/layout/
        echo -n "$PWD" | shasum | cut -d ' ' -f 1
    )}"
}
