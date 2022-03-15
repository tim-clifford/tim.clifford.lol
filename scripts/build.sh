#!/bin/dash

cd $(dirname $0)/..

. ./scripts/convert.sh
. ./scripts/html.sh

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

cd - >/dev/null
