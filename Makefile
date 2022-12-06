.PHONY: clean down up perms rmq-perms

RABBITMQ_DOCKER_TAG ?= 3-management

vesc-1054:
	# Note: pattern has $$ because GNU makefiles require that $ be escaped
	$(CURDIR)/bin/rabbitmqadmin --host=localhost --port=15672 declare policy name=vesc-1054-0-null pattern='^vesc-1054-0$$' definition='{"federation-upstream":"undefined"}' priority=10 apply-to=queues
	$(CURDIR)/bin/rabbitmqadmin --host=localhost --port=15673 declare policy name=vesc-1054-0-null pattern='^vesc-1054-0$$' definition='{"federation-upstream":"undefined"}' priority=10 apply-to=queues
	echo '[INFO] sleeping 5 seconds to ensure policies are applied'
	sleep 5
	$(CURDIR)/bin/rabbitmqadmin --host=localhost --port=15672 delete queue name=vesc-1054-0
	$(CURDIR)/bin/rabbitmqadmin --host=localhost --port=15673 delete queue name=vesc-1054-0
	$(CURDIR)/bin/rabbitmqadmin --host=localhost --port=15672 delete policy name=vesc-1054-0-null
	$(CURDIR)/bin/rabbitmqadmin --host=localhost --port=15673 delete policy name=vesc-1054-0-null

clean: perms
	git clean -xffd

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
