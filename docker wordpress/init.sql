-- Crear las bases de datos si no existen
CREATE DATABASE IF NOT EXISTS NEC;
CREATE DATABASE IF NOT EXISTS enterprise2;

-- Otorgar privilegios a 'vicente' en ambas bases de datos
GRANT ALL PRIVILEGES ON NEC.* TO 'vicente'@'%';
GRANT ALL PRIVILEGES ON enterprise2.* TO 'vicente'@'%';

-- Otorgar privilegios de root (con permisos de administración)
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Otorgar privilegios de 'vicente' en todas las bases de datos (esto le dará privilegios globales)
GRANT ALL PRIVILEGES ON *.* TO 'vicente'@'%' WITH GRANT OPTION;

-- Aplicar los privilegios
FLUSH PRIVILEGES;
