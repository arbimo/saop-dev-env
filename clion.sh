#!/bin/bash

# Launches CLion inside a Docker container

IMAGE=${1:-saop-clion:latest}
CMD=${2}

DOCKER_GROUP_ID=$(cut -d: -f3 < <(getent group docker))
USER_ID=$(id -u $(whoami))
GROUP_ID=$(id -g $(whoami))

# Need to give the container access to your windowing system
xhost +

CMD="docker run --group-add ${DOCKER_GROUP_ID} \
                --env HOME=/home/saop \
                --env DISPLAY=unix${DISPLAY} \
                --cap-add=SYS_PTRACE \
                --privileged \
                --security-opt seccomp:unconfined \
                --security-opt apparmor:unconfined \
                --interactive \
                --name CLion \
                --net "host" \
                --rm \
                --tty \
                --user=${USER_ID}:${GROUP_ID} \
                --volume ${HOME}/work/firers:/home/saop \
                --volume /tmp/.X11-unix:/tmp/.X11-unix \
                --volume /var/run/docker.sock:/var/run/docker.sock \
                --workdir /home/saop \
                ${IMAGE} ${CMD}"

echo $CMD
$CMD
