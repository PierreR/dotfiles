function sshi () {
	ssh -A -i ~/.ssh/alhazen_rsa alhazen@$1
}

function presources () {
    puppetresources -p . -o "$1" --hiera ./tests/hiera.yaml --pdbfile tests/facts.yaml "${@:2}"
}

function nixsearch () {
    nix-env -qaPf '<nixpkgs>' -A $1
}

alias heyaml='./bin/eyaml.sh $@'

export PS1='\w\[\033[01;38m\]$(__git_ps1)\[\033[00m\] → '
