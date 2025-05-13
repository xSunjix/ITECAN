#install odoo13 simple

#!/bin/bash
sudo add-apt-repository "deb http://mirrors.kernel.org/ubuntu/ xenial main"
sudo apt update && sudo apt upgrade
sudo apt-get install git python3 python3-pip build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less libpng12-0 libjpeg-dev gdebi libpq-dev -y
sudo -H pip3 install -r https://github.com/odoo/odoo/raw/13.0/requirements.txt
cd /opt
sudo git clone --recurse-submodules --shallow-submodules --branch 13.0 https://github.com/odoo/odoo.git odoo13
sudo apt install postgresql postgresql-client
sudo -u postgres createuser -d -R -S $USER
createdb $USER
PG_PORT=$(grep -i "port" /etc/postgresql/14/main/postgresql.conf | awk '{print $3}' | sed 's/[^0-9]*//g')

echo "[options]
data_dir = /var/run/odoo
log_handler = :WARNING
log_level = warn
pidfile = /var/run/odoo/odoo.pid
limit_time_cpu = 600
limit_time_real = 1200
max_cron_threads = 0
server_wide_modules=web
addons_path = /opt/odoo13/addons
logfile = /opt/log/odoo13.log
; This is the password that allows database operations:
admin_passwd = admin
db_host = localhost
db_port = $PG_PORT
db_user = $WHOAMI
db_password = $WHOAMI
;addons_path = /usr/lib/python3/dist-packages/odoo/addons
default_productivity_apps = True
xmlrpc_port =  8069" | sudo tee /etc/odoo13.conf

sudo -u postgres psql -c "ALTER USER $whoami WITH PASSWORD '$whoami';"
sudo mkdir -p /run/odoo
sudo chown -R $(whoami):$(whoami) /run/odoo
sudo mkdir -p /var/log/odoo /run/odoo
sudo chown -R $(whoami):$(whoami) /var/log/odoo /run/odoo

#solo la primera vez
python3 odoo-bin --addons-path=addons -d $USER -c /etc/odoo13.conf -i base
#normalmente
#python3 odoo-bin --addons-path=addons -c /etc/odoo13.conf

