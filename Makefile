name = nginx-router
image = scwood/nginx-router
portOptions = 80:80
volume = $(CURDIR)/default.conf
location = /etc/nginx/conf.d/default.conf

stop:
	docker stop $(name) || true
remove: stop
	docker rm $(name) || true
run: remove
	docker run -d --name $(name) -p $(portOptions) -v $(volume):$(location) $(image)
enter:
	docker exec -it $(name) /bin/bash
build:
	docker build -t $(name) .
tag:
	docker tag nginx-router scwood/nginx-router:latest
push: build tag
	docker push $(image)
reload:
	docker exec -it $(name) nginx -s reload