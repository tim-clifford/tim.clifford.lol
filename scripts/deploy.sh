#!/bin/dash

cd $(dirname $0)/..

rsync -a --delete out/http/ pip:public_html
rsync -a --delete out/bliz/ pip:bliz/serve
rsync -a --delete --exclude=hits.db bliz_config/ pip:bliz/personal

cd - >/dev/null
