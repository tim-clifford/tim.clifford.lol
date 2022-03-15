#!/bin/dash

activate_single_template() { # $1: template, $2: content
	# this function exists so I can preserve indentation for neatness reasons.
	# it expects to see a line with only ${CONTENT}, which it will replace
	indentation="$(<$1 sed -n 's|\([[:space:]]*\)\${CONTENT}$|\1|p')"
	indented="$(echo -n "$2" | sed -z "s|\n|\n$indentation|g")"
	CONTENT="$indented" <$1 envsubst
}

activate_double_template() { # $1: template, stdin -> stdout
	activate_single_template http/templates/outer.html \
		"$(activate_single_template $1 \
			"$(cat /dev/stdin)" \
		)"
}
