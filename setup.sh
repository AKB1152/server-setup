#!/bin/bash

main () {
  sudo apt install -y openjdk-17-* gcc g++ hexedit docker.io apache2 apache2-*;
  sudo systemctl enable --now docker; 
  docker --version | echo; 
  docker run hello-world;
  sudo chown -R akb1152 /var/www;
}

main $@;
