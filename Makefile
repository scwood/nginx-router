location = /etc/nginx/conf.d/default.conf
name = nginx-router
hostPort = 80
containerPort = 80
volume = $(CURDIR)/default.conf

stop:
	docker stop $(name) || true
remove: stop
	docker rm $(name) || true
removeImage: remove
	docker rmi $(name) || true
run: ip = $(shell curl ifconfig.me)
run: remove
	docker run -d --name $(name) --add-host dockerhost:$(ip) \
		-p $(hostPort):$(containerPort) -v $(volume):$(location) $(name)
enter:
	docker exec -it $(name) /bin/bash
build: removeImage
	docker build -t $(name) .
reload:
	docker exec -it $(name) nginx -s reload
logs:
	docker logs $(name)
