#!/bin/dash

cd $(dirname $0)/..

. ./scripts/build.sh

build_blog_alts
build_http
build_bliz

cd - >/dev/null
