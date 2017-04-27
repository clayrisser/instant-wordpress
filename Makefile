CWD := $(shell readlink -en $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))
IMAGE := "jamrizzi/wordpress-env:latest"
DOCKERFILE := $(CWD)/Dockerfile

.PHONY: all
all: fetch_dependancies sweep build

.PHONY: build
build:
	docker build -t $(IMAGE) -f $(DOCKERFILE) $(CWD)
	$(info built $(IMAGE))

.PHONY: pull
pull:
	docker pull $(IMAGE)
	$(info pulled $(IMAGE))

.PHONY: push
push:
	docker push $(IMAGE)
	$(info pushed $(IMAGE))

.PHONY: run
run:
	docker run --name some-instant-wordpress --rm --link some-mariadb:mysql -p 8080:80 $(IMAGE)

.PHONY: database
database:
	docker run --name some-mariadb --rm -e MYSQL_ROOT_PASSWORD=hellodocker mariadb:latest

.PHONY: ssh
ssh:
	docker run -it --entrypoint /bin/bash $(IMAGE)

.PHONY: clean
clean: sweep bleach
	$(info cleaned)
.PHONY: sweep
sweep:
	$(info swept)
.PHONY: bleach
bleach:
	$(info bleached)

.PHONY: fetch_dependancies
fetch_dependancies: docker
	$(info fetched dependancies)
.PHONY: docker
docker:
ifeq ($(shell whereis docker), $(shell echo docker:))
	curl -L https://get.docker.com/ | bash
endif
	$(info fetched docker)
