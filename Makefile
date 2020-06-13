RELEASE_TAG := v$(shell git rev-parse --abbrev-ref HEAD)-$(shell date +%Y%m%d-%H%M%S-%3N)

build:
	docker build -t galexrt/staytus:latest .

release:
	git tag $(RELEASE_TAG)
	git push origin $(RELEASE_TAG)
