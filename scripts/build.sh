#!/bin/dash

cd $(dirname $0)/..

. ./scripts/convert.sh
. ./scripts/html.sh
. ./scripts/template.sh

html_escape() {
	# stack overflow told me this is "elegant", hahahaa
	sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g'
}

build_rss() {
	posts="$(find blog/ -type f -name 'index.md' | while read post
		do
			echo "$(md_get_metadata "$post" createdAt)	$post"
		done | sort | cut -f2)"

	export DATE="$(date --rfc-email)"
	export CONTENT="$(echo "$posts" | while read post
		do
			export TITLE="$(md_get_metadata "$post" title)"
			export URL="https://tim.clifford.lol/$(echo "$post" | sed -E 's/\.md$/.html/;s/index.html$//')"
			export DESCRIPTION="$(md_strip_yaml <$post | pandoc -f markdown -t html \
				| perl -pe "$(cat << 'EOF'
BEGIN{undef $/;}

sub get_title {
	$title = $_[0];
	return $title if $title =~ s/.*?title="(.*?)".*/$1/smg;
}

sub get_link {
	$link = $_[0];
	return $link if $link =~ s/.*?src="(.*?)".*/$1/smg;
}

sub get_a {
	$iframe = $_[0];
	return '<a href="' . get_link($iframe) . '">' . get_title($iframe) . "</a>\n";
}

s/(<iframe.*?(\/>|<\/iframe>))/get_a($1)/smge;
EOF
			)" | html_escape)"
			export DATE="$(date --rfc-email --date="$(md_get_metadata "$post" createdAt)")"
			envsubst <http/templates/rss-item.xml
		done
	)"
	envsubst <http/templates/rss-outer.xml > out/http/blog/rss.xml
}

build_blog_alts() {
	find blog/ -type f -name index.md | while read post; do
		# xargs doesn't work for some reason
		convert_blog_to_bliz_txt_eml $post
	done
}

build_http() {
	mkdir -p out/http

	find http/md/ -type f | while read file; do
		html_build_md_page "$file"
	done

	html_build_blog_index
	build_rss

	blog_sort_color | while read line; do
		echo "$line" | html_build_blog_post
	done


	cp -r static/* out/http/
	cp -r http/static/* out/http/

	# dotfiles too
	cp -r static/.[!.]* out/http/
	cp -r http/static/.[!.]* out/http/
}

build_bliz() {
	mkdir -p out/bliz

	cp -r bliz/* out/bliz/
	cp -r static/* out/bliz/

	cp -r bliz/.[!.]* out/bliz/
	cp -r static/.[!.]* out/bliz/
}

if [ $# -eq 0 ] || [ "$1" = "--all" ]; then
	build_blog_alts
	build_http
	build_bliz
elif [ "$1" = "--blog" ]; then
	build_blog_alts
elif [ "$1" = "--bliz" ]; then
	build_bliz
elif [ "$1" = "--http" ]; then
	build_http
fi

cd - >/dev/null
