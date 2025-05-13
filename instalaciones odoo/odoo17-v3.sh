#!/bin/bash

#UBUNTU22.04
U_USER="${SUDO_USER:-$USER}"
export U_USER
PWS_ODOO="odoo"
sudo usermod -aG sudo $U_USER

#primero actualizo la distribucion de linux:
sudo apt update && sudo apt upgrade -y

#Generar el usuario:
sudo  useradd -m -d /home/odoo -s /bin/bash odoo
echo "odoo:$PWS_ODOO" | sudo chpasswd
sudo usermod -aG sudo odoo
mkdir -p /var/lib/odoo #por si luego queremos hacer alguna movida aqui)
cd /home/odoo
sudo apt install postgresql postgresql-client -y
sudo -u postgres createuser -d -R -S odoo
sudo -u postgres psql -c "ALTER USER odoo WITH PASSWORD '$PWS_ODOO';"
sudo -u postgres psql -c "ALTER USER odoo CREATEDB;"
#sudo systemctl stop postgresql
#Cambiar puerto de PostgreSQL 14 a 5432
#sed -i 's/^#\?port = .*/port = 5432/' /etc/postgresql/14/main/postgresql.conf

# Esperar un momento y verificar si está escuchando en el nuevo puerto
#sleep 2
#lsof -i :5432
#createdb odoo
#sudo -u postgres createdb -O odoo odoo

#sudo systemctl enable postgresql
#sudo systemctl start postgresql
#sudo pg_ctlcluster 14 main start

#instalo las dependencias de python 
sudo apt install python3 python3-pip python3-dev python3-venv libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev gcc zip nodejs npm libpq-dev libxml2-dev libxmlsec1-dev libxmlsec1-openssl libmysqlclient-dev build-essential python3-dev libffi-dev libev-dev -y

#instalo WKHTML
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb
sudo apt install -f -y
sudo dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb

#permisos para opt
cd /opt
sudo chown -R odoo:$U_USER /opt

#clonacion de odoo17
git clone -b 17.0 --depth 1 --no-single-branch --recurse-submodules --shallow-submodules https://github.com/odoo/odoo.git odoo17

#generaré un envrioment en luego debemos instalar otra version de odoo
mkdir venvs
python3 -m venv /opt/venvs/odoo17
source /opt/venvs/odoo17/bin/activate
pip3 install --upgrade pip
pip3 install setuptools wheel phonenumbers
pip install --upgrade pip setuptools wheel

IMPORTANTE
# Ruta al archivo requirements.txt
REQUIREMENTS_FILE="/opt/odoo17/requirements.txt"
(MODIFICAR MANUAL O POR SCRIPT)
# Modificar gevent y greenlet en el archivo requirements.txt
sed -i 's/^gevent.*/gevent==24.11.1/' "$REQUIREMENTS_FILE"
sed -i 's/^greenlet.*/greenlet==3.1.1/' "$REQUIREMENTS_FILE"

pip3 install -r odoo17/requirements.txt

cd odoo17/addons
sudo bash /opt/odoo17/setup/debinstall.sh
#find . -type f -name "requirements.txt" -exec pip3 install -r {} \;

mkdir -p /opt/log
sudo mkdir -p /run/odoo
sudo chown -R odoo:$U_USER /run/odoo
sudo touch /run/odoo/odoo.pid
sudo chmod 755 -R /run/odoo
sudo chmod 644 -R /run/odoo/odoo.pid

pg_lsclusters
PG_PORT=$(grep -i "port" /etc/postgresql/14/main/postgresql.conf | awk '{print $3}' | sed 's/[^0-9]*//g')
export PG_PORT
#creo el servicio en el sistema
echo "[Unit]
Description=Odoo 17
After=network.target
# -c /etc/odoo17.conf
[Service]
User=odoo
Group=$U_USER
ExecStart=/opt/venvs/odoo17/bin/python3 /opt/odoo17/odoo-bin -c /etc/odoo17.conf
WorkingDirectory=/opt/odoo17/odoo
StandardOutput=journal
StandardError=inherit
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/odoo.service > /dev/null

echo "[options]
data_dir = /var/run/odoo
log_handler = :WARNING
log_level = warn
pidfile = /var/run/odoo/odoo.pid
limit_time_cpu = 600
limit_time_real = 1200
max_cron_threads = 0
server_wide_modules=web
addons_path = /opt/odoo17/addons
logfile = /opt/log/odoo17.log
; This is the password that allows database operations:
admin_passwd = admin
db_host = localhost
db_port = $PG_PORT
db_user = odoo
db_password = odoo
;addons_path = /usr/lib/python3/dist-packages/odoo/addons
default_productivity_apps = True
xmlrpc_port =  8069" | sudo tee /etc/odoo17.conf

touch /opt/log/odoo17.log
sudo chown -R odoo:$U_USER /opt/log
sudo chmod 755 /opt/log
sudo mkdir -p /run/odoo/sessions
sudo chown -R odoo:$U_USER /run/odoo
sudo chmod -R 755 /run/odoo
sudo chown odoo:odoo /etc/odoo17.conf
#_______________________________

#iniciar servicio (muere con el terminal)
#python3 /opt/odoo17/odoo/odoo-bin > /home/odoo/odoo.log 2>&1 &
#inicar servicio (persiste)
#nohup python3 /opt/odoo17/odoo/odoo-bin > /home/odoo/odoo.log 2>&1 &
#para matarlo
#pkill -f odoo-bin

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable odoo
sudo systemctl start odoo
#sudo systemctl stop odoo
echo "Iniciando PostgreSQL"
#sudo -u postgres /usr/lib/postgresql/14/bin/postgres -D /etc/postgresql/14/main &
echo "instalacion completada y iniciando servicios...."

#cd /opt/odoo17
#python3 odoo-bin -c /etc/odoo17.conf -i base
sudo -u postgres psql -c "ALTER USER odoo WITH PASSWORD '$PWS_ODOO';"
#sudo -u odoo /opt/venvs/odoo17/bin/python3 /opt/odoo17/odoo-bin -c /etc/odoo17.conf -i base
#sudo -u odoo /opt/venvs/odoo17/bin/python3 /opt/odoo17/odoo-bin -c /etc/odoo17.conf -d odoo -i base --stop-after-init
sudo chown -R odoo:$U_USER /opt
sudo chmod 775 /opt
sudo systemctl restart odoo

#"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" http://localhost:8069
#"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" "http://localhost:8069/web/database/manager?name=odoo&login=$U_USER&password=odoo&language=es_ES"


sudo apt remove libnode-dev -y
sudo apt-get remove --purge libnode72 -y

# Instalar Node.js y npm desde repositorio oficial actualizado
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Verificar versión instalada
node -v   # Debe ser >= 18.x
npm -v    # Debe ir acorde (>= 8.x)

# Preparar entorno de Puppeteer
cd /opt/odoo17
npm init -y
sudo apt-get install -y libx11-dev libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 libxi6 libxtst6 libnss3 libasound2 libatk-bridge2.0-0 libgtk-3-0
sudo apt install -y libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 libdbus-1-3 libgdk-pixbuf2.0-0 libnspr4 libnss3 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2
sudo apt install -y libnss3 libgdk-pixbuf2.0-0 libxss1 libasound2 libatk-bridge2.0-0 libgtk-3-0 libgbm1
npm install puppeteer-core
#sudo apt autoremove -y

#"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" http://localhost:8069//web/database/manager?
#"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" "http://localhost:8069/web/database/manager?name=odoo&login=$U_USER&password=odoo&language=es_ES"
cat <<EOF | tee /opt/odoo17/auto_setup.js > /dev/null
setTimeout(() => {
  document.querySelector('input[name="master_pwd"]').value = "admin";  // Contraseña maestra
  document.querySelector('#dbname').value = "odoo";  // Nombre de la base de datos
  document.querySelector('#login').value = "$U_USER@example.com";  // Email
  document.querySelector('input[name="password"]').value = "odoo";  // Contraseña del usuario
  document.querySelector('input[name="phone"]').value = "666666666";  // Teléfono
  document.querySelector('select[name="lang"]').value = "es_ES";  // Idioma (Spanish / Español)
  document.querySelector('select[name="country_code"]').value = "es";  // País (Spain)
  document.querySelector('#load_demo_checkbox').checked = false;  // Botón de carga de demo desactivado
  document.querySelector('input[type="submit"]').click();  // Hacer clic en el botón de continuar
}, 1000);
EOF

# cat <<EOF | tee /opt/odoo17/runner.js > /dev/null
# const puppeteer = require('puppeteer-core');
# const fs = require('fs');

# (async () => {
#   const browser = await puppeteer.launch({
#     headless: false,
#     executablePath: '"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"'  // Ruta de Chrome en tu máquina Windows
#   });

#   const page = await browser.newPage();
#   await page.goto('http://localhost:8069/web/database/manager?name=odoo&login=admin@example.com&password=odoo&language=es_ES');

#   const script = fs.readFileSync('/opt/odoo17/auto_setup.js', 'utf8');
#   await page.evaluate(script);


#executablePath: '/mnt/c/Program Files/Google/Chrome/Application/chrome.exe'.replace(/ /g, '\\ '),


# })();
# EOF


________________________________________________

# cat << 'EOF' | sudo tee /opt/odoo17/runner.js > /dev/null
# const puppeteer = require('puppeteer-core');
# const fs = require('fs');

# const chromePaths = [
#   "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe",
#   "/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
# ];

# const chromePath = chromePaths.find(path => fs.existsSync(path));

# if (!chromePath) {
#   console.error(" Chrome no encontrado en rutas conocidas.");
#   process.exit(1);
# }

# console.log(" Chrome encontrado en:", chromePath);

# (async () => {
#   const browser = await puppeteer.launch({
#     headless: false,
#     executablePath: chromePath,
#     args: ['--no-sandbox', '--disable-setuid-sandbox']
#   });

#   const page = await browser.newPage();
#   await page.goto('http://localhost:8069/web/database/manager?name=odoo&login=admin@example.com&password=odoo&language=es_ES');

#   const script = fs.readFileSync('/opt/odoo17/auto_setup.js', 'utf8');
#   await page.evaluate(script);
# })();
# EOF

________________________________________________



cat <<EOF | tee /opt/odoo17/runner.js > /dev/null
const puppeteer = require('puppeteer-core');
const fs = require('fs');

(async () => {
  const browser = await puppeteer.launch({
    headless: false,
    executablePath: '/mnt/c/Program Files/Google/Chrome/Application/chrome.exe', // Ruta de Chrome
    args: ['--no-sandbox', '--disable-setuid-sandbox'] // Para WSL
  });

  const page = await browser.newPage();
  await page.goto('http://localhost:8069/web/database/manager?name=odoo&login=admin@example.com&password=odoo&language=es_ES');

  const script = fs.readFileSync('/opt/odoo17/auto_setup.js', 'utf8');
  await page.evaluate(script);
})();
EOF
sudo tee /opt/bienvenida.txt > /dev/null <<EOF




















# ==========================================
# ----CONFIGURACIÓN FINAL Y BIENVENIDA------
# ==========================================

Bienvenido a Odoo 17 en tu sistema. :D

PUERTO DE TU ODOO17: http://localhost:8069
PUERTO DE TU BBDD: $PG_PORT
Los archivos importantes de configuración son:

- Configuración principal: /etc/odoo17.conf
- Sistema de servicio:   /etc/systemd/system/odoo.service
- Logs de Odoo:          /opt/log/odoo17.log
- Permisos:              odoo:$U_USER

Para iniciar, detener o ver el estado del servicio Odoo puedes usar:

  sudo systemctl start odoo
  sudo systemctl stop odoo
  sudo systemctl status odoo

Ufw:

  De momento este script no toca firewall o reglas
  por lo que si tines algún problema de conexion de
  odoo17 y tu base de datos será mejor revisar por
  esos tiros con tus propias reglas. chaito

¡Gracias por usar este instalador :3 !
-- cualquier informe de error o si necesitas ayuda a vicente.torres@itecan.es
EOF
sudo chown -R odoo:$U_USER /opt
sudo chmod 775 /opt
sudo -u $U_USER node /opt/odoo17/runner.js
sudo -u $U_USER code /opt
cat /opt/bienvenida.txt
