#!/bin/dash

cd $(dirname $0)/..

blog_sort_color() {

	# get posts sorted by date
	sorted_posts="$(find blog/ -type f -name '*.md' | while read post; do
		date="$(md_get_metadata "$post" createdAt)"
		echo "$date	$post"
	done | sort)"

	# get color cycle
	color_cycle="$(yq -r .color_cycle <config.yaml)"
	color_current="$color_cycle"

	# match colors to posts
	sorted_colored_posts=""

	# assign colors to posts in order
	until [ -z "$sorted_posts" ]; do
		if [ -z "$color_current" ]; then
			color_current="$color_cycle"
		fi
		sorted_colored_posts="\
$(echo "$color_current" | cut -d' ' -f 1)	$(echo "$sorted_posts" | head -n1)
$sorted_colored_posts"
		sorted_posts="$(echo "$sorted_posts" | tail -n +2)"
		color_current="$(echo "$color_current" | cut -d' ' -f 2-)"
	done

	echo "$sorted_colored_posts"
}

cd - >/dev/null

