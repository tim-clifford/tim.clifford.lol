#!/bin/dash

cd $(dirname $0)/..

. ./scripts/template.sh
. ./scripts/blog.sh

md_color_headings() { # $1: start color
	# h2 specifically
	color_cycle="$(yq -r .color_cycle <config.yaml | tr ' ' '\n' | tac)"
	start_color="$1"
	color_current="$(echo "$color_cycle" | grep -A9999 "$1")"

	while read line; do
		if echo "$line" | grep -Eq '^##[^#]'; then
			color_current="$(echo "$color_current" | tail -n +2)"
			if [ -z "$color_current" ]; then
				color_current="$color_cycle"
			fi
			color_single="$(echo "$color_current" | head -n1)"
			color_code="$(yq -r .colors.$color_single <config.yaml)"
			echo "<h2 style=\"color: $color_code\">"
			echo "$line" | sed 's|^##[[:space:]]*||'
			echo "</h2>"
		else
			echo "$line"
		fi
	done
}


html_build_md_page() { # $1: filename, writes to out/http/
	file="$1"
	escaped_name="$(dirname "$file" | perl -pe 's|.*?md/?|/|;s|[/-]|_|g;')"
	out_file="$(echo "$file" | sed 's|^http/md/|out/http/|; s|.md$|.html|')"
	mkdir -p "$(dirname $out_file)"

	export COLOR="$(<config.yaml yq -rc ".page_colors.$escaped_name")"
	export TITLE="$(md_get_metadata $file title)"

	<$file md_color_headings $COLOR | pandoc --from markdown --to html \
		| activate_double_template http/templates/default.html >$out_file
}

html_build_blog_items() {
	# put data into templates and output
	blog_sort_color | while read post; do
		test -z "$post" && continue
		color="$(echo "$post" | cut -f 1)"
		date="$(echo "$post" | cut -f 2)"
		file="$(echo "$post" | cut -f 3)"
		basename_noext="$(basename "$(dirname "$file")")"

		export TITLE="$(md_get_metadata $file title)"
		export DATE="$date"
		export EXCERPT="$(md_get_metadata $file excerpt)"
		export REF="/blog/$basename_noext/"
		export COLOR="$color"
		envsubst <http/templates/blog-item.html
	done
}

html_build_blog_index() {
	export COLOR="$(yq -r .page_colors._blog <config.yaml)"

	mkdir -p out/http/blog/
	html_build_blog_items \
		| activate_double_template http/templates/blog-index.html > out/http/blog/index.html
}

html_build_blog_post() { # reads tsv color, date, file
	read tsv
	test -z "$tsv" && return
	file="$(echo "$tsv" | cut -f 3)"
	basename_noext="$(basename "$(dirname "$file")")"

	export COLOR="$(echo "$tsv" | cut -f 1)"
	export DATE="$(echo "$tsv" | cut -f 2)"
	export TITLE="$(md_get_metadata $file title)"

	mkdir -p out/http/blog/$basename_noext
	out_file="out/http/blog/$basename_noext/index.html"

	<$file md_strip_yaml | md_color_headings $COLOR \
		| pandoc --from markdown --to html \
		| activate_double_template http/templates/blog-post.html >$out_file

	find "$(dirname "$file")" -mindepth 1 ! -name index.md \
		| xargs -I% cp -r % "$(dirname $out_file)"
}

cd - >/dev/null
