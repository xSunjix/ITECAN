#!/bin/bash


# Solicitamos dominio para produccion
PRODUCCION=$(whiptail --title "Dominio entorno de produccion" --inputbox "Inserta el dominio EJ: erp.odoo.itecan.es" 10 80  3>&1 1>&2 2>&3)

if [ -z "$PRODUCCION" ]
then
    whiptail --title "Aviso" --msgbox "No se ha indicado dominio de produccion." 8 80
else

# Creacion de sitio NGINX Produccion
echo "server {
  listen 80;
  server_name ${PRODUCCION};
}" >> /etc/nginx/sites-available/$PRODUCCION

nginx -t
ln -s /etc/nginx/sites-available/$PRODUCCION /etc/nginx/sites-enabled/
service nginx restart

certbot --nginx

echo  > /etc/nginx/sites-available/$PRODUCCION

echo "# Odoo servers
upstream odoo {
    server 127.0.0.1:8069;
}

upstream odoochat {
    server 127.0.0.1:8072;
}

# Expires map
map \$sent_http_content_type \$expires {
    default                    off;
    text/html                  epoch;
    text/css                   max;
    application/javascript     max;
    ~image/                    max;
}

server {
    server_name ${PRODUCCION};

    listen 443 ssl http2; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/${PRODUCCION}/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/${PRODUCCION}/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    proxy_read_timeout 7200s;
    proxy_connect_timeout 7200s;
    proxy_send_timeout 7200s;
    client_max_body_size 200m;
    expires \$expires;
    proxy_max_temp_file_size 5924m;

    # Proxy headers
proxy_set_header X-Forwarded-Host \$host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Client-IP \$remote_addr;
    proxy_set_header HTTP_X_FORWARDED_HOST \$remote_addr;

    # log files
    access_log /var/log/nginx/odoo.access.log;
    error_log /var/log/nginx/odoo.error.log;

     # Handle longpoll requests
    location /longpolling {
        proxy_pass http://odoochat;
    }

    # Handle / requests
    location / {
        proxy_redirect off;
        proxy_pass http://odoo;
        location ~* .(js|css|png|jpg|jpeg|gif|ico)$ {
            expires 2d;
            proxy_pass http://odoo;
            add_header Cache-Control \"public, no-transform\";
        }
    }

    # Cache static files
    location ~* /web/static/ {
        proxy_cache_valid 200 60m;
        proxy_buffering on;
        expires 864000;
        proxy_pass http://odoo;
    }

      # Error Mantenimiento Personalizado
        error_page 502 /mantenimientoOdoo.html;
        location = /mantenimientoOdoo.html {
            root /opt/webMantenimiento;
            internal;
        }
        location /assets {
        types {
        image/png;
        }
        default_type image/png;
        root /opt/webMantenimiento;
        }
        location /font {
        root /opt/webMantenimiento;
        }

    # Gzip
    gzip_types text/css text/less text/plain text/xml application/xml application/json application/javascript;
    gzip on;
}

server {
    if (\$host = ${PRODUCCION}) {
        return 301 https://\$host\$request_uri;
    } # managed by Certbot


    listen 80;
    server_name ${PRODUCCION};
    return 404; # managed by Certbot
}
" >> /etc/nginx/sites-available/${PRODUCCION}

# Solicitamos dominio para formacion
FORMACION=$(whiptail --title "Dominio entorno de formacion" --inputbox "Inserta el dominio EJ: erp.odoo.itecan.es" 10 80  3>&1 1>&2 2>&3)

if [ -z "$FORMACION" ]
then
    whiptail --title "Aviso" --msgbox "No se ha indicado dominio de formacion." 8 80
else

# Creacion de sitio NGINX Formacion
echo "server {
  listen 80;
  server_name ${FORMACION};
}" >> /etc/nginx/sites-available/$FORMACION

nginx -t
ln -s /etc/nginx/sites-available/$FORMACION /etc/nginx/sites-enabled/
service nginx restart

certbot --nginx

echo  > /etc/nginx/sites-available/$FORMACION

echo "# Odoo servers
upstream erptest {
    server 127.0.0.1:8068;
}

upstream erptestchat {
    server 127.0.0.1:8073;
}

# Expires map
map \$sent_http_content_type \$expires {
    default                    off;
    text/html                  epoch;
    text/css                   max;
    application/javascript     max;
    ~image/                    max;
}

server {
    server_name ${FORMACION};

    listen 443 ssl http2; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/${FORMACION}/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/${FORMACION}/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    proxy_read_timeout 7200s;
    proxy_connect_timeout 7200s;
    proxy_send_timeout 7200s;
    client_max_body_size 2000m;
    expires \$expires;
    proxy_max_temp_file_size 5924m;

    # Proxy headers
proxy_set_header X-Forwarded-Host \$host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Client-IP \$remote_addr;
    proxy_set_header HTTP_X_FORWARDED_HOST \$remote_addr;

    # log files
    access_log /var/log/nginx/erptest.access.log;
    error_log /var/log/nginx/erptest.error.log;

     # Handle longpoll requests
    location /longpolling {
        proxy_pass http://erptestchat;
    }

    # Handle / requests
    location / {
        proxy_redirect off;
        proxy_pass http://erptest;
        location ~* .(js|css|png|jpg|jpeg|gif|ico)$ {
            expires 2d;
            proxy_pass http://erptest;
            add_header Cache-Control \"public, no-transform\";
        }
    }

    # Cache static files
    location ~* /web/static/ {
        proxy_cache_valid 200 60m;
        proxy_buffering on;
        expires 864000;
        proxy_pass http://erptest;
    }

      # Error Mantenimiento Personalizado
        error_page 502 /mantenimientoOdoo.html;
        location = /mantenimientoOdoo.html {
            root /opt/webMantenimiento;
            internal;
        }
        location /assets {
        types {
        image/png;
        }
        default_type image/png;
        root /opt/webMantenimiento;
        }
        location /font {
        root /opt/webMantenimiento;
        }

    # Gzip
    gzip_types text/css text/less text/plain text/xml application/xml application/json application/javascript;
    gzip on;
}

server {
    if (\$host = ${FORMACION}) {
        return 301 https://\$host\$request_uri;
    } # managed by Certbot


    listen 80;
    server_name ${FORMACION};
    return 404; # managed by Certbot
}
" >> /etc/nginx/sites-available/${FORMACION}

fi

nginx -t
service nginx restart

fi
