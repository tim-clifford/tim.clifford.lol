all:
	make clean && make build && make deploy
blog_alts:
	./scripts/build.sh --blog
gemini:
	./scripts/build.sh --bliz && rsync -a --delete out/bliz/ pip:bliz/serve
build:
	./scripts/build.sh --all
deploy:
	./scripts/deploy.sh
clean:
	rm -rf out/http/*
	rm -rf out/bliz/*
extra-clean:
	rm -rf bliz/blog/* eml/*
