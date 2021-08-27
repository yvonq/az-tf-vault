#!/bin/bash

set -e
#
sudo apt install openjdk-8-jdk -y
sudo wget -qO - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list
sudo apt-get update && apt-get install jenkins -y
sudo service jenkins restart
