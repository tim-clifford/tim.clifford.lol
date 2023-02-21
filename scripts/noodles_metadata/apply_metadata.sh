#!/bin/bash

defaults="$(cat metadata/default.metaflac)"

find ./metadata -type f -name '*.metaflac' | grep -v 'default.metaflac' | while read -r file; do
	target="$(echo "$file" | sed 's|\./metadata/||;s|\.metaflac$|.flac|')"
	metadata="$defaults"
	while read -r metaline; do
		tag="$(echo "$metaline" | cut -d'=' -f 1)"
		val="$(echo "$metaline" | cut -d'=' -f 2)"
		metadata="$(echo "$metadata" | sed "s|^$tag=.*|$tag=$val|")"
	done < "$file"
	metaflac --dont-use-padding --remove-all "$target"
	metaflac --dont-use-padding --import-picture-from='3|image/png|Cover art by Ori Vasilescu||metadata/cover.png' "$target"
	metaflac --dont-use-padding --import-tags-from=<(echo "$metadata") "$target"
done

