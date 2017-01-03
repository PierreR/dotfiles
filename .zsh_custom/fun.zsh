sshi () {
	  ssh -A -i ~/.ssh/alhazen_rsa alhazen@$1
}

presources () {
    puppetresources -p . -o "$1" --hiera ./tests/hiera.yaml --pdbfile tests/facts.yaml "${@:2}"
}

nixsearch () {
    nix-env -qaPf '<nixpkgs>' -A $1
}
