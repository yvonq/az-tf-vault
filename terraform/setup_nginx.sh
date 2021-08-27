#!/bin/bash

set -e

sudo apt update
sudo apt install -y nginx
sudo echo Hello > /var/www/html/index.nginx-debian.html
