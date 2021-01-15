all:

.PHONY:

docker_image: Dockerfile
	docker build -t ansible-action:latest --network host .