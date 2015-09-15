#!/bin/bash

#variables
DOCKERBIN=/bin/docker
SERVICE=docker
IMAGE=kristiyanto/guidock
INSTALL=sudo yum -y

#check if docker has been installed
if [ ! -f  $DOCKERBIN ]
 then
  echo "$DOCKERBIN not installed"
  echo "attempting to install docker"
  sudo curl -sSL https://get.docker.com/ | sh
  if [ ! -f  $DOCKERBIN ]
   then
    echo "unable to install docker"
    exit 0
  fi
  echo "$DOCKERBIN successfully installed"
 else
  echo "$DOCKERBIN installed"
fi 

#check if the docker service has been started
if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    echo "$SERVICE service running"
else
    echo "$SERVICE service not running"
    echo "attempting to start $SERVICE"
    sudo service $SERVICE start
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then  
     echo "started $SERVICE";
    else
     echo "unable to $SERVICE"
     exit 0
    fi 
fi

#run the container
xhost +
sudo docker run -ti -e DISPLAY=$DISPLAY -v /var/db:/var/db:Z -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/developer/.Xauthority $IMAGE