#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
CODENAME="$(lsb_release -c | awk '{print $2}')"

# Instalacion de requisitos a nivel de sistema
apt update && apt upgrade -y

# Instalar ultima version PSQL
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update -y
apt install postgresql postgresql-client pg-activity -y

    # Modificar usuario Odoo en PSQL
sudo -u postgres psql -c "CREATE ROLE odoo WITH LOGIN CREATEDB PASSWORD 'itecan'"

# Archivo de configuracion de PSQL
VERPSQL=$(psql --version 2>/dev/null | awk '{print $3}')
VPS=$(whiptail --title "VPS" --menu "Indica el tipo de VPS" 15 60 4 \
            "2vCPU 4GB RAM" "" \
            "4vCPU 8GB RAM" "" 3>&1 1>&2 2>&3)
            if [ -z "$VPS" ]; then
                whiptail --title "Error" --msgbox "No has elegido tipo VPS, se deja PSQL por defecto." 8 80
            else
                cp /etc/postgresql/$VERPSQL/main/postgresql.conf /etc/postgresql/$VERPSQL/main/postgresql.conf.bak

                if [ "$VPS" = "2vCPU 4GB RAM" ]; then
                    cp ./confs/postgresql/postgresql_2vCPU4RAM.conf /etc/postgresql/$VERPSQL/main/postgresql.conf
                    
                elif [ "$VPS" = "4vCPU 8GB RAM" ]; then
                    cp ./confs/postgresql/postgresql_4vCPU8RAM.conf /etc/postgresql/$VERPSQL/main/postgresql.conf
                fi

                chown postgres:postgres /etc/postgresql/$VERPSQL/main/postgresql.conf
                service postgresql restart
            fi

# Instalar requisitos de sistema en base a sistema

if [ $CODENAME = "focal" ]; then
        bash scripts/requirements/focal.sh
    elif [ $CODENAME = "jammy" ]; then
        bash scripts/requirements/jammy.sh
    elif [ $CODENAME = "noble" ]; then
        bash scripts/requirements/noble.sh
fi

    # Generar usuario Odoo, entorno de filestore y venvs
sudo useradd odoo
mkdir -p /var/lib/odoo
chown -R odoo:root /var/lib/odoo

mkdir -p /opt/venvs
chown -R odoo:root /opt
sudo -u odoo python3 -m venv /opt/venvs/erp
sudo -u odoo python3 -m venv /opt/venvs/erptest

# Instalacion CertBot y NGINX
apt install nginx snap -y
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
service nginx restart

sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Sitio web de mantenimiento
git clone --depth 1 https://gitlab.itecan.es/odoo/webMantenimiento.git /opt/webMantenimiento

# Clonacion de repositorio y seleccion de Version Odoo

REPO=$(whiptail --title "Indica la URL del repositorio" --inputbox "La URL acabada en .git" 10 60 3>&1 1>&2 2>&3)

if [ -z "$REPO" ]; then
    whiptail --title "Aviso" --msgbox "No se ha indicado repositorio, se continúa sin realizar clonación" 8 80
else
    # Definir las opciones de versión según el codename
    case "$CODENAME" in
        focal)
            OPTIONS="12 13 14 15 16"
            ;;
        jammy)
            OPTIONS="14 15 16 17 18"
            ;;
        noble)
            OPTIONS="17 18"
            ;;
        *)
            whiptail --title "Error" --msgbox "No se reconoce el codename '$CODENAME'. No se pueden determinar las versiones compatibles." 8 80
            exit 1
            ;;
    esac

    # Convertir las opciones en un formato compatible con whiptail (sin comillas vacías)
    MENU_OPTIONS=""
    for VERSION in $OPTIONS; do
        MENU_OPTIONS+="$VERSION \"\" "
    done

    # Selección de la versión de Odoo
    VERSION=""
    while [ -z "$VERSION" ]; do
        VERSION=$(whiptail --title "Versión de Odoo" --menu "Indica la versión de Odoo correspondiente" 15 60 6 \
        $MENU_OPTIONS 3>&1 1>&2 2>&3)
        if [ -z "$VERSION" ]; then
            whiptail --title "Error" --msgbox "Debes seleccionar una versión." 8 80
        fi
    done

    # Clonación de los repositorios
    sudo -u odoo git clone -b main --depth 1 --recurse-submodules --shallow-submodules "$REPO" "/opt/odoo${VERSION}"
    sudo -u odoo git clone -b stg --depth 1 --recurse-submodules --shallow-submodules "$REPO" "/opt/odoo${VERSION}_test"
fi

# Generacion de servicios

    # Servicio ERP
echo "[Unit]
Description=Odoo Open Source ERP and CRM
After=network.target
[Service]
Type=simple
User=odoo
Group=root
ExecStart=/opt/venvs/erp/bin/python3 /opt/odoo${VERSION}/odoo/odoo-bin -c /opt/odoo${VERSION}/conf/odoo.conf
KillMode=mixed
[Install]
WantedBy=multi-user.target
" >> /etc/systemd/system/erp.service

    # Servicio ERPTEST
echo "[Unit]
Description=Odoo Open Source ERP and CRM
After=network.target
[Service]
Type=simple
User=odoo
Group=root
ExecStart=/opt/venvs/erptest/bin/python3 /opt/odoo${VERSION}_test/odoo/odoo-bin -c /opt/odoo${VERSION}_test/conf/stg.conf
KillMode=mixed
[Install]
WantedBy=multi-user.target
" >> /etc/systemd/system/erptest.service

if [[ "$VERSION" =~ ^(12|13|14|15)$ ]]; then
    bash scripts/certbot/certbot.sh
else
    bash scripts/certbot/certbotv16.sh
fi

# Scripts de backups, logrotation y notifications
git clone -b main --recurse-submodules --shallow-submodules https://gitlab.itecan.es/scripts/scripts.git /opt/scripts
if [ ! -d "/opt/odoo${VERSION}/" ]; then
    whiptail --title "Aviso" --msgbox "No hay carpetas de Odoo PROD.\nNo se configura el script de backups." 8 80
else
    bash scripts/configurators/configDump.sh $VERSION
    bash scripts/configurators/configRotation.sh $VERSION
fi

mv confs/cron/root /var/spool/cron/crontabs
service cron restart

# Securizacion
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw enable
apt install fail2ban -y

# Instalacion de venvs
sudo -u odoo bash scripts/venvs/venvs.sh $VERSION

bash scripts/configurators/configUpgrade.sh

whiptail --title "Notificacion" --msgbox \
"Instalacion finalizada.\n\
En caso de fallo con los requirements deberas regenerar los venvs.\n\
Recuerda habilitar los servicios e iniciarlos." 10 80

echo "Script eliminado"

rm -rf "$SCRIPT_DIR"
