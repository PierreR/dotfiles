sshi () {
	  ssh -A -i ~/.ssh/alhazen_rsa alhazen@$1
}

presources () {
    puppetresources -p . -o "$1" --hiera ./tests/hiera.yaml --pdbfile tests/facts.yaml "${@:2}"
}

nlink () {
    readlink -f $(which "$1")
}

nqattr () {
    nix-env -qaPf '<nixpkgs>' -A $1
}

nq () {
    local CACHE="$HOME/.cache/nq-cache"
    if ! ( [ -e $CACHE ] && [ $(stat -c %Y $CACHE) -gt $(( $(date +%s) - 3600 )) ] ); then
        echo "update cache" && nix-env -qa --json > "$CACHE"
    fi
    jq -r 'to_entries | .[] | .key + "|" + .value.meta.description' < "$CACHE" |
        {
            if [ $# -gt 0 ]; then
                # double grep because coloring breaks column's char count
                # $* so that we include spaces (could do .* instead?)
                grep -i "$*" | column -t -s "|" | grep --color=always -i "$*"
            else
                column -t -s "|"
            fi
        }
}
