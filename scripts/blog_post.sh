#!/bin/bash
# $1 filename

if [ $# -ne 1 ]; then
	echo "Incorrect number of arguments"
	exit 1
fi

# check all files exist

# filenames
name="$(echo $1 | perl -pe 's|.*/([^/]*)/index.md$|\1|')"
dir="$(realpath "$(dirname "$1")/../..")"
f_bliz="$dir/bliz/blog/$name/index.bliz"
f_eml="$dir/eml/$name.eml"

if ! test -f $1; then
	echo "$1 does not exist!"
	exit 1
elif ! test -f $f_bliz; then
	echo "$f_bliz does not exist!"
	exit 1
elif ! test -f $f_eml; then
	echo "$f_eml does not exist!"
	exit 1
fi

cd $dir
make all
cd - >/dev/null

echo "Built and deployed for gemini and http"

## test!!!

recipients="$(ssh pip srcf-mailman-list tc565-blog | sed -z 's/\n$//;s/\n/, /g')"

<$f_eml msmtp -a blog -- tim@clifford.lol

recipients="tc565@cam.ac.uk"

echo "Sent test email. Press enter to send to: "
echo "$recipients"
echo "or ctrl-c to cancel"

read foo

#sed '/^To:.*/aBcc: '"$recipients"'/' $f_eml | msmtp -t -a blog
