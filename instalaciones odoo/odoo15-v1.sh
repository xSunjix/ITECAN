#!/bin/bash

# Variables
U_USER="${SUDO_USER:-$USER}"
PWS_ODOO="odoo"
ODOO_VERSION="15.0"
ODOO_HOME="/opt/odoo15"
PSQL_VERSION=$(psql --version 2>/dev/null | awk '{print $3}' | cut -d '.' -f 1)
PG_PORT=$(grep -i "port" /etc/postgresql/$PSQL_VERSION/main/postgresql.conf | awk '{print $3}' | sed 's/[^0-9]*//g')

# Actualización de la distribución
sudo apt update && sudo apt upgrade -y

# Instalación de dependencias necesarias
sudo apt install python3 python3-pip python3-dev python3-venv libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev gcc zip nodejs npm libpq-dev libxml2-dev libxmlsec1-dev libxmlsec1-openssl libmysqlclient-dev build-essential python3-dev libffi-dev libev-dev -y

# Instalación de WKHTMLTOPDF
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb
sudo apt install -f -y

# Configuración de permisos
cd /opt
sudo chown -R odoo:$U_USER /opt

# Clonación del repositorio de Odoo 15
git clone -b 15.0 --depth 1 --no-single-branch --recurse-submodules --shallow-submodules https://github.com/odoo/odoo.git odoo15

# Creación de un entorno virtual para Odoo 15
mkdir -p /opt/venvs
python3 -m venv /opt/venvs/odoo15
source /opt/venvs/odoo15/bin/activate
pip3 install --upgrade pip
pip3 install setuptools wheel phonenumbers
pip install --upgrade pip setuptools wheel

# Ruta al archivo requirements.txt
REQUIREMENTS_FILE="/opt/odoo15/requirements.txt"
(MODIFICAR MANUAL O POR SCRIPT)
# Modificar gevent y greenlet en el archivo requirements.txt
sed -i 's/^gevent.*/gevent==24.11.1/' "$REQUIREMENTS_FILE"
sed -i 's/^greenlet.*/greenlet==3.1.1/' "$REQUIREMENTS_FILE"

# Instalación de las dependencias de Odoo desde requirements.txt
pip3 install -r /opt/odoo15/requirements.txt

# Creación de directorios para logs y ejecución de Odoo
mkdir -p /opt/log
sudo chown odoo:$U_USER -R /opt/log
sudo chmod 775:$U_USER -R /opt/log
sudo mkdir -p /run/odoo
sudo chown -R odoo:$U_USER /run/odoo
sudo touch /run/odoo/odoo.pid
sudo chmod 775 -R /run/odoo
sudo chmod 775 -R /run/odoo/odoo.pid

# Crear archivo de configuración para Odoo 15
echo "[options]
data_dir = /run/odoo
log_handler = :WARNING
log_level = warn
pidfile = /var/run/odoo/odoo.pid
limit_time_cpu = 600
limit_time_real = 1200
max_cron_threads = 0
server_wide_modules=web
addons_path = /opt/odoo15/addons
logfile = /opt/log/odoo15.log
admin_passwd = admin
db_host = localhost
db_port = $PG_PORT
db_user = odoo
db_password = $PWS_ODOO
default_productivity_apps = True
xmlrpc_port = 8070" | sudo tee /etc/odoo15.conf > /dev/null

# Crear archivo de servicio para Odoo 15
echo "[Unit]
Description=Odoo 15
After=network.target

[Service]
User=odoo
Group=$U_USER
ExecStart=/opt/venvs/odoo15/bin/python3 /opt/odoo15/odoo-bin -c /etc/odoo15.conf
WorkingDirectory=/opt/odoo15
StandardOutput=journal
StandardError=inherit
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/odoo15.service > /dev/null

# Ajuste de permisos
sudo chown -R odoo:$U_USER /opt/odoo15
sudo chmod 775 /opt/odoo15
sudo chown -R odoo:$U_USER /opt/log
sudo chmod 775 /opt/log
sudo chown -R odoo:$U_USER /run/odoo
sudo chmod -R 775 /run/odoo
sudo chown odoo:odoo /etc/odoo15.conf

# Recargar systemd y habilitar el servicio Odoo
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable odoo15
sudo systemctl start odoo15

# Solución error de permisos 13/05/2025 odoo15_v2_ubuntu22.04.sh
sudo chown -R odoo:$U_USER /opt
sudo chmod 775 /opt

sudo mkdir -p /run/odoo
sudo chown -R odoo:$U_USER /run/odoo
sudo chmod 775 /run/odoo

sudo mkdir -p /run/odoo/filestore
sudo chown -R odoo:$U_USER /run/odoo/filestore
sudo chmod 775 /run/odoo/filestore

sudo mkdir -p /run/odoo/sessions
sudo chown -R odoo:$U_USER /run/odoo/sessions
sudo chmod 775 /run/odoo/sessions

sudo touch -p /run/odoo/odoo.pid
sudo chown -R odoo:$U_USER /run/odoo/odoo.pid
sudo chmod 775 /run/odoo/odoo.pid

sudo mkdir -p /run/odoo/addons
sudo chown -R odoo:$U_USER /run/odoo/addons
sudo chmod 775 /run/odoo/addons

sudo mkdir -p /opt/log
sudo chown -R odoo:$U_USER /opt/log
sudo chmod 775 /opt/log

sudo touch -p /run/odoo/odoo15.log
sudo chown -R odoo:$U_USER /opt/log/odoo15.log
sudo chmod 775 /run/odoo/odoo15.log

sudo systemctl restart odoo15
sudo systemctl restart postgresql

# FIN
sudo tee /opt/bienvenida_odoo15.txt > /dev/null <<EOF




















# ==========================================
# ----CONFIGURACIÓN FINAL Y BIENVENIDA------
# ==========================================

Bienvenido a Odoo 15 $U_USER :D

PUERTO DE TU ODOO15: http://localhost:8070
PUERTO DE TU BBDD: $PG_PORT
Los archivos importantes de configuración son:

- Configuración principal: /etc/odoo15.conf
- Sistema de servicio:   /etc/systemd/system/odoo15.service
- Logs de Odoo:          /opt/log/odoo15.log
- Permisos:              odoo:$U_USER

Para iniciar, detener o ver el estado del servicio Odoo puedes usar:

  sudo systemctl start odoo15
  sudo systemctl stop odoo15
  sudo systemctl status odoo15

Ufw:

  De momento este script no toca firewall o reglas
  por lo que si tines algún problema de conexion de
  odoo15 y tu base de datos será mejor revisar por
  esos tiros con tus propias reglas. chaito

¡Gracias por usar este instalador :3 !
-- cualquier informe de error o si necesitas ayuda a vicente.torres@itecan.es
EOF
cat /opt/bienvenida_odoo15.txt
