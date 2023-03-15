#!/bin/dash

cd $(dirname $0)/..

. ./scripts/template.sh
. ./scripts/blog.sh

md_color_headings() { # $1: start color
	# h2 specifically
	color_cycle="$(yq -r .color_cycle <config.yaml | tr ' ' '\n' | tac)"
	start_color="$1"
	color_current="$(echo "$color_cycle" | grep -A9999 "$1")"

	while IFS= read -r line; do
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
	escaped_name="$(
		((echo "$file" | grep -Eq 'index.md$') \
			&& dirname "$file" \
			|| echo "$file" \
		) | perl -pe 's|.*?md/?|/|;s|[/.-]|_|g;')"
	echo "$escaped_name"

	out_file="$(echo "$file" | sed 's|^http/md/|out/http/|; s|.md$|.html|')"
	mkdir -p "$(dirname "$out_file")"

	export COLOR="$(<config.yaml yq -rc ".page_colors.$escaped_name")"
	export TITLE="$(md_get_metadata "$file" title)"

	banner="$(md_get_metadata "$file" banner)"

	if [ "$banner" != "null" ]; then
		src="$(echo "$banner" | cut -d':' -f1)"
		alt="$(echo "$banner" | cut -d':' -f2- | sed 's/^ *//')"
		export BANNER="<div class=\"banner\"><img src=\"$src\" alt=\"$alt\"/></div>"
	fi

	<$file md_color_headings $COLOR | pandoc --from markdown --to html \
		| activate_double_template http/templates/default.html >$out_file
}

html_build_blog_all() {
	# put data into templates and output
	blog_sort_color | html_build_blog_from
}

html_build_blog_from() { # stdin is blog_sort_color equivalent
	while read post; do
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

html_build_blog_indices() {
	categories="$(yq -rc '.[]' <blog/categories.yaml)"
	sorted_colored_blogs="$(blog_sort_color)"

	export COLOR="$(yq -r .page_colors._blog <config.yaml)"

	echo "$categories" | while read -r category; do
		name="$(echo "$category" | yq -r .name)"
		shortname="$(echo "$category" | yq -r .shortname)"
		mkdir -p out/http/blog/$shortname

		posts="$(echo "$category" | yq -rc '.posts[]')"
		echo "$posts" \
			| sed 's|^|blog/|;s|$|/index.md|' `# jank` \
			| blog_apply_color_to \
			| html_build_blog_from \
			| activate_double_template http/templates/blog-listing.html \
				> out/http/blog/$shortname/index.html
	done

	mkdir -p out/http/blog/all

	html_build_blog_all \
		| activate_double_template http/templates/blog-listing.html > out/http/blog/all/index.html

	<blog/index.md \
		  pandoc --from markdown --to html \
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
	export URL_PART="$basename_noext"

	mkdir -p out/http/blog/$basename_noext
	out_file="out/http/blog/$basename_noext/index.shtml"

	<$file md_strip_yaml | md_color_headings $COLOR \
		| pandoc --from markdown --to html \
		| activate_double_template http/templates/blog-post.shtml >$out_file

	find "$(dirname "$file")" -mindepth 1 ! -name index.md \
		| xargs -I% cp -r % "$(dirname $out_file)"
}

cd - >/dev/null
