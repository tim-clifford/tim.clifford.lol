#!/bin/dash

cd $(dirname $0)/..

md_strip_yaml() { # stdin -> stdout
	sed '/^---/,/^---/d; /^<!-- vim\?: .*/d'
}

md_get_metadata() { # $1: file, $2: param
	yaml="$(<$1 sed -n '/^---/,/^---/p' | grep -Ev '^---')"
	echo "$yaml" | yq -rc '.'"$2"
}

cd - >/dev/null
