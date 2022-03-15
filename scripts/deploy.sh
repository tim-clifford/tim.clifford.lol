#!/bin/dash

cd $(dirname $0)/..

rsync -a --delete out/http/ pip:public_html
rsync -a --delete out/bliz/ pip:bliz/serve

cd - >/dev/null
