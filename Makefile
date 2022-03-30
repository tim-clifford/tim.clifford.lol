all:
	make clean && make build && make deploy
blog_alts:
	./scripts/build.sh --blog
blog_post:
	./scripts/blog_post.sh $(POST)
gemini:
	rm out/bliz/* -rf
	./scripts/build.sh --bliz && \
	rsync -a --delete out/bliz/ pip:bliz/serve && \
	rsync -a --delete --exclude=hits.db bliz_config/ pip:bliz/personal
https:
	rm out/http/* -rf
	./scripts/build.sh --http && \
	rsync -a --delete out/http/ pip:public_html
build:
	./scripts/build.sh --all
deploy:
	./scripts/deploy.sh
clean:
	rm -rf out/http/*
	rm -rf out/bliz/*
extra-clean:
	rm -rf bliz/blog/* eml/*
