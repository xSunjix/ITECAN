$logFile = "E:\Backups\logs.txt"

$fecha = Get-Date -Format "dd/MM/yyyy"
$hora = Get-Date -Format "HH:mm:ss"
$mensaje = "Se ha ejecutado el script el [$fecha $hora]"
Add-Content -Path $logFile -Value $mensaje

$fechaLimite = (Get-Date).AddDays(-6)

# Aledcon
echo "Aledcon"

# Definir carpeta destino
$destino = "E:\Backups\aledcon\"
$logFile = "E:\Backups\logs.txt"

# Descargar archivos usando pscp
pscp.exe -pw 'JyPXQ3YYXgwd$' ubuntu@193.70.84.195:/home/ubuntu/erp* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Aledcon"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force

# Alpe
echo "Alpe"

# Definir carpeta destino
$destino = "E:\Backups\crmalpe\"
$logFile = "E:\Backups\logs.txt"


# Descargar archivos usando pscp
pscp.exe -pw 'aqwrT3H6WGJm$' ubuntu@151.80.155.222:/home/ubuntu/crm* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Guardar mensaje en log
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Alpe"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (más de 30 días)
$fechaLimite = (Get-Date).AddDays(-30)
Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force

# Angustina
echo "Angustina"

# Definir carpeta destino
$destino = "E:\Backups\erp_carpinteriaangustina_com\"
$logFile = "E:\Backups\logs.txt"

# Descargar archivos usando pscp
pscp.exe -pw 'ZZP7RpzGdawE$' ubuntu@5.196.26.144:/home/ubuntu/erp* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Angustina"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
$fechaLimite = (Get-Date).AddDays(-30)
Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force

# Apria
echo "Apria"

# Definir carpeta destino
$destino = "E:\Backups\apria\"
$logFile = "E:\Backups\logs.txt"

# Descargar archivos usando pscp
pscp.exe -pw 'PfjDSAjqDXeh$' ubuntu@5.196.26.103:/home/ubuntu/erp* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Apria"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force

# Arsan
echo "Arsan"

# Definir carpeta destino
$destino = "E:\Backups\arsan\"
$logFile = "E:\Backups\logs.txt"

# Descargar archivos usando pscp
pscp.exe -pw '$FDCPGaehBD4A$' ubuntu@164.132.57.31:/home/ubuntu/erp* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Arsan"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force


# BILSTEIN
echo "Bilstein"

# Definir carpeta destino
$destino = "E:\Backups\bilstein\"
$logFile = "E:\Backups\logs.txt"

# Descargar archivos usando pscp
pscp.exe -pw 'Jk9vZnfu32c7' ubuntu@51.75.28.78:/home/ubuntu/erp* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Blistein"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)  # Puedes ajustar el número de días según necesites
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force

# Ecojebar
echo "Ecojebar"

# Definir carpeta destino
$destino = "E:\Backups\ecojebar\"
$logFile = "E:\Backups\logs.txt"

# Descargar archivos usando pscp
pscp.exe -pw 'yeSjpFg4ADjU$' ubuntu@5.196.26.225:/home/ubuntu/erp* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Ecojebar"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)  # Puedes ajustar el número de días según necesites
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force

# Electren
echo "Electren"

# Definir carpeta destino
$destino = "E:\Backups\electren\"
$logFile = "E:\Backups\logs.txt"

# Descargar archivos usando pscp
pscp.exe -pw '8tjBm32bzGRX$' ubuntu@57.128.170.51:/home/ubuntu/erp* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Electren"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)  # Puedes ajustar el número de días según necesites
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force

# Electricidad Gutierrez
echo "Electricidad Gutierrez"

# Definir carpeta destino
$destino = "E:\Backups\electricidadgutierrez\"
$logFile = "E:\Backups\logs.txt"

# Descargar archivos usando pscp
pscp.exe -pw 'h2ZePmtcdsn5$' ubuntu@51.255.50.48:/home/ubuntu/erp* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Electricidad Gutierrez"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)  # Puedes ajustar el número de días según necesites
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force

### FACTURACION KIT DIGITAL COMPARTIDO ###

# Cecilia
echo "Cecilia"

# Definir carpeta destino
$destino = "E:\Backups\cecilia\"
$logFile = "E:\Backups\logs.txt"

# Descargar archivos usando pscp
pscp.exe -pw 'xRHy9JEF4PNP$' ubuntu@51.77.211.162:/opt/backups/cecilia/erp* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Cecilia"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)  # Puedes ajustar el número de días según necesites
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force

# Jaqueline
echo "Jaqueline"

# Definir carpeta destino
$destino = "E:\Backups\jaqueline\"
$logFile = "E:\Backups\logs.txt"

# Descargar archivos usando pscp
pscp.exe -pw 'xRHy9JEF4PNP$' ubuntu@51.77.211.162:/opt/backups/jaqueline/erp* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Jaqueline"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)  # Puedes ajustar el número de días según necesites
# Eliminar archivos antiguos
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force


# JAngel
echo "JAngel"

# Definir carpeta destino
$destino = "E:\Backups\jangel\"
$logFile = "E:\Backups\logs.txt"

# Descargar archivos usando pscp
pscp.exe -pw 'xRHy9JEF4PNP$' ubuntu@51.77.211.162:/opt/backups/jangel/erp* $destino

# Obtener el archivo más reciente
$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
if ($archivoReciente) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de JAngel"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)  # Puedes ajustar el número de días según necesites

# Eliminar archivos antiguos
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force


# ramiro nuñez
echo "Ramiro Nunnez"

# Definir carpeta destino
$destino = "E:\Backups\ramiro_nunnez\"
$logFile = "E:\Backups\logs.txt"

pscp.exe -pw 'HcFAT2Akt3uQ' ubuntu@141.95.55.16:/opt/backups/ramiro_nunnez/ram* E:\Backups\ramiro_nunnez\ 

# Obtener archivos descargados (los más recientes)
$archivosDescargados = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 5

# Mostrar mensaje por cada archivo
foreach ($archivo in $archivosDescargados) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $hora = Get-Date -Format "HH:mm:ss"
    $mensaje = "[$fecha $hora] Se ha descargado la copia de seguridad de Ramiro Nunnez"
    Add-Content -Path $logFile -Value $mensaje
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# Ejemplo: $fechaLimite = (Get-Date).AddDays(-30)
# Asegúrate de definir $fechaLimite si quieres activar esta parte

# $fechaLimite = (Get-Date).AddDays(-30)
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite 

# Luis Cabielles
#echo "Luis Cabielles"

# Definir carpeta destino
#destino = "E:\Backups\luis_cabielles\"

# Descargar archivos usando pscp
#pscp.exe -pw 'HcFAT2Akt3uQ' ubuntu@141.95.55.16:/opt/backups/luis_cabielles/luis* $destino

# Obtener el archivo más reciente
#$archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Mostrar mensaje
#if ($archivoReciente) {
#    $fecha = Get-Date -Format "dd/MM/yyyy"
#$hora = Get-Date -Format "HH:mm:ss"
#Write-Host "Se ha descargado '$($archivoReciente.Name)' el $fecha a las $hora"
#}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)  # Puedes ajustar el número de días según necesites

# Eliminar archivos antiguos
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force


###########################################

# Luis Cabielles
echo "Luis Cabielles"

# Definir carpeta destino
$destino = "E:\Backups\luis_cabielles\"

# Intentar descargar archivos usando pscp
Try {
    pscp.exe -pw 'HcFAT2Akt3uQ' ubuntu@141.95.55.16:/opt/backups/luis_cabielles/luis* $destino
}
Catch {
    Write-Host "❌ Error al intentar descargar archivos de la ruta remota: $_. Asegúrate de que la ruta '/opt/backups/luis_cabielles/' exista en el servidor."
}

# Obtener el archivo más reciente
Try {
    $archivoReciente = Get-ChildItem -Path $destino | Sort-Object LastWriteTime -Descending | Select-Object -First 1

    # Mostrar mensaje
    if ($archivoReciente) {
        $fecha = Get-Date -Format "dd/MM/yyyy"
        $hora = Get-Date -Format "HH:mm:ss"
        Write-Host "Se ha descargado '$($archivoReciente.Name)' el $fecha a las $hora"
    }
}
Catch {
    Write-Host "❌ Ha ocurrido un error al obtener los archivos en la carpeta de destino: $_"
}

# Comprobar los archivos en la carpeta local y eliminar antiguos (si se define $fechaLimite)
# $fechaLimite = (Get-Date).AddDays(-30)  # Puedes ajustar el número de días según necesites

# Eliminar archivos antiguos
# Get-ChildItem -Path $destino | Where-Object { $_.LastWriteTime -lt $fechaLimite } | Remove-Item -Force

# IBERBARTER
echo "IBERBARTER"
pscp.exe -pw 'UfeaFepEc6R6' ubuntu@141.94.115.251:/home/ubuntu/erp* E:\Backups\iberbarter\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\iberbarter\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# iTecan
echo "iTecan"
pscp.exe -pw 'Nx4F4vCD4VWR$' ubuntu@5.196.26.166:/home/ubuntu/erp* E:\Backups\itecan\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\itecan\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

#### MARCAJES ####

# aehc
echo "aehc"
pscp.exe -pw 'FZeByfUZwncH' ubuntu@162.19.66.196:/home/ubuntu/backups/aehc/aehc* E:\Backups\aehc\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\aehc\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# Hotel el Haya
echo "Haya"
pscp.exe -pw 'FZeByfUZwncH' ubuntu@162.19.66.196:/home/ubuntu/backups/haya/haya* E:\Backups\haya\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\haya\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# Laboratorio
echo "Laboratorio"
pscp.exe -pw 'FZeByfUZwncH' ubuntu@162.19.66.196:/home/ubuntu/backups/laboratorio/erp* E:\Backups\laboratorio\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\laboratorio\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# Lebecuesta
echo "Lebecuesta"
pscp.exe -pw 'FZeByfUZwncH' ubuntu@162.19.66.196:/home/ubuntu/backups/lebecuesta/lebecuesta* E:\Backups\lebecuesta\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\lebecuesta\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# Maes
echo "Maes"
pscp.exe -pw 'FZeByfUZwncH' ubuntu@162.19.66.196:/home/ubuntu/backups/maes/maes* E:\Backups\maes\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\maes\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# yowe
echo "yowe"
pscp.exe -pw 'FZeByfUZwncH' ubuntu@162.19.66.196:/home/ubuntu/backups/yowe/yowe* E:\Backups\yowe\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\yowe\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

####################

### MARCAJES V17 ###

# Innpulsa
echo "innpulsa"
pscp.exe -pw 'qEtG6eXrDHWa$' ubuntu@37.187.53.19:/opt/backups/innpulsa/erp* E:\Backups\innpulsa\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\innpulsa\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

###################

# Mueblam
echo "Mueblam"
pscp.exe -pw 'Kv8gjBazGWwT$' ubuntu@5.196.26.16:/home/ubuntu/erp* E:\Backups\mueblan\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\mueblan\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# MyCoworking
echo "MyCoworking"
pscp.exe -pw 'k2up2ZNfdEzS$' ubuntu@5.196.23.154:/home/ubuntu/erp* "E:\Backups\mycoworking\"

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\mycoworking\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# Naturae
echo "Naturae"
pscp.exe -pw '7G6b8qu7rjNK$' ubuntu@5.196.26.207:/home/ubuntu/erp* E:\Backups\naturae\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\naturae\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# Proel
echo "Proel"
pscp.exe -pw '2CjPCsyFKPzf$' ubuntu@92.222.22.48:/home/ubuntu/erp* E:\Backups\proel\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\proel\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# Odisa
echo "Odisa"
pscp.exe -pw 'NDsf8k9XK2N6$' ubuntu@51.255.48.217:/home/ubuntu/erp* E:\Backups\odisa\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\odisa\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# Talleres Jose Angel
echo "Talleres Jose Angel"
pscp.exe -pw 'bfNxnAF8kDjp$' ubuntu@151.80.155.23:/home/ubuntu/erp* E:\Backups\talleresjoseangel\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\talleresjoseangel\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# Veasa
echo "Veasa"
pscp.exe -pw 'vkbFGXReGwWt$' ubuntu@51.255.51.93:/home/ubuntu/erp* E:\Backups\veasa\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\veasa\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# Ventanas Roma
echo "Ventanas Roma"
pscp.exe -pw 'K2AE8JkMEFMs$' ubuntu@51.255.49.251:/home/ubuntu/erp* E:\Backups\vroma\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\vroma\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

# Zurro E Hijos
echo "Zurro E Hijos"
pscp.exe -pw '9BKGeXsWNYXt$' ubuntu@151.80.59.141:/home/ubuntu/erp* E:\Backups\zurroehijos\ 

# Comprobar los archivos en la carpeta local

Get-ChildItem -Path E:\Backups\zurroehijos\ | ForEach-Object {
    if ($_.LastWriteTime -lt $fechaLimite) {
        Remove-Item $_.FullName -Force
    }
}

exit