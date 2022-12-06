.PHONY: clean down up perms rmq-perms

RABBITMQ_DOCKER_TAG ?= 3-management

$(CURDIR)/testapp/target/playgroundrabbit-0.0.1-SNAPSHOT.jar:
	cd testapp && mvn compile && mvn package

testapp: $(CURDIR)/testapp/target/playgroundrabbit-0.0.1-SNAPSHOT.jar

clean: perms
	git clean -xffd
	cd testapp && git clean -xffd

down:
	docker compose down
	docker compose rm --force

up: rmq-perms
	docker compose build --build-arg RABBITMQ_DOCKER_TAG=$(RABBITMQ_DOCKER_TAG)
	docker compose up

perms:
	sudo chown -R "$(USER):$(USER)" data log

rmq-perms:
	sudo chown -R '999:999' data log
