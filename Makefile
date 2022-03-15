all:
	make clean && make build && make deploy
gemini:
	sh -c '. ./scripts/build.sh; build_bliz' && rsync -a --delete out/bliz/ pip:bliz/serve
build:
	./scripts/build-all.sh
deploy:
	./scripts/deploy.sh
clean:
	rm -rf out/http/*
extra-clean:
	rm -rf bliz/blog/* eml/*
