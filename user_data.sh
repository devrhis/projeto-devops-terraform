#!/bin/bash

# Atualizar os pacotes do sistema
apt-get update -y
apt-get upgrade -y

# Instalar o Nginx
apt-get install nginx -y

# Iniciar o Nginx
systemctl start nginx

# Habilitar o Nginx para iniciar automaticamente no boot
systemctl enable nginx
