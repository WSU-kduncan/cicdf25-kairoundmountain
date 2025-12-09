#!/bin/sh

docker rm -f project3
docker rmi -f kairoundmountain/project3:latest
docker pull kairoundmountain/project3:latest
docker run --name project3 -d -p 80:80 --restart always kairoundmountain/project3:latest
