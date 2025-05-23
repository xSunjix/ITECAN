# Configuración inicial
$directorioRaiz = "E:\Backups"
$logFile = Join-Path $directorioRaiz "log_mantenimiento.txt"
$fecha = Get-Date -Format "dd/MM/yyyy"
$hora = Get-Date -Format "HH:mm:ss"
$fechaHoy = (Get-Date).Date

Add-Content -Path $logFile -Value "===== [$fecha $hora] Inicio de mantenimiento de copias ====="

# Contadores
$copiasDetectadasHoy = 0
$empresasIncompletas = @()

# Empresas que guardan backups en subcarpetas (sin mover zips)
$empresasEnSubcarpetas = @("Mueblam", "MyCoworking")

# Obtener todas las subcarpetas (empresas)
$subCarpetas = Get-ChildItem -Path $directorioRaiz -Directory
$totalEmpresas = $subCarpetas.Count

foreach ($carpeta in $subCarpetas) {
    $nombreEmpresa = $carpeta.Name
    Add-Content -Path $logFile -Value "Empresa: $nombreEmpresa"

    # Limpiar subcarpetas innecesarias (tipo 'ubuntu') y mover los .zip al directorio principal
    $subDirs = Get-ChildItem -Path $carpeta.FullName -Directory
    foreach ($subDir in $subDirs) {
        $zips = Get-ChildItem -Path $subDir.FullName | Where-Object { $_.Extension -match "\.zip$" }
        foreach ($zip in $zips) {
            $horaZip = $zip.LastWriteTime.ToString("HHmmss")
            $nombreBase = [System.IO.Path]::GetFileNameWithoutExtension($zip.Name)
            $extension = $zip.Extension

            # Verificar si ya tiene la hora al final
            if ($nombreBase -notmatch "_\d{6}$") {
                $nombreBase += "_$horaZip"
            }

            $nuevoNombre = "$nombreBase$extension"
            $destino = Join-Path $carpeta.FullName $nuevoNombre

            try {
                Move-Item -Path $zip.FullName -Destination $destino -Force
                Add-Content -Path $logFile -Value "   ↪ Movido: $($zip.Name) → $nuevoNombre desde subcarpeta '$($subDir.Name)'"
            } catch {
                Add-Content -Path $logFile -Value "   ❌ ERROR al mover $($zip.Name): $_"
            }
        }

        # Eliminar subcarpeta si queda vacía
        if ((Get-ChildItem -Path $subDir.FullName).Count -eq 0) {
            try {
                Remove-Item -Path $subDir.FullName -Force -Recurse
                Add-Content -Path $logFile -Value "   🗑 Subcarpeta vacía eliminada: $($subDir.Name)"
            } catch {
                Add-Content -Path $logFile -Value "   ❌ ERROR al eliminar subcarpeta $($subDir.Name): $_"
            }
        }
    }

    # Obtener archivos .zip en la carpeta principal de empresa
    $archivos = Get-ChildItem -Path $carpeta.FullName -Filter "*.zip" | Sort-Object LastWriteTime -Descending
    Add-Content -Path $logFile -Value "   Total de copias encontradas: $($archivos.Count)"

    # Verificar si hubo copia hoy
    $copiasHoy = $archivos | Where-Object { $_.LastWriteTime.Date -eq $fechaHoy }
    if ($copiasHoy.Count -gt 0) {
        $copiasDetectadasHoy += $copiasHoy.Count
        foreach ($copia in $copiasHoy) {
            Add-Content -Path $logFile -Value "   ✔ Copia de hoy detectada: $($copia.Name) [$($copia.LastWriteTime)]"
        }
    } else {
        Add-Content -Path $logFile -Value "   ⚠ NO se detectó copia de seguridad de hoy."
        $empresasIncompletas += $nombreEmpresa
    }

    # Eliminar copias antiguas si hay más de 7
    if ($archivos.Count -gt 7) {
        $archivosAEliminar = $archivos | Select-Object -Skip 7
        foreach ($archivo in $archivosAEliminar) {
            try {
                Remove-Item $archivo.FullName -Force
                Add-Content -Path $logFile -Value "   🗑 Eliminado: $($archivo.Name)"
            } catch {
                Add-Content -Path $logFile -Value "   ❌ ERROR al eliminar: $($archivo.Name) - $_"
            }
        }
    } else {
        Add-Content -Path $logFile -Value "   ℹ No se eliminaron copias. Total actual dentro del límite."
    }

    Add-Content -Path $logFile -Value ""
}

# Resumen final
Add-Content -Path $logFile -Value "Resumen del proceso:"
Add-Content -Path $logFile -Value "   Total de empresas analizadas: $totalEmpresas"
Add-Content -Path $logFile -Value "   Copias de seguridad detectadas hoy: $copiasDetectadasHoy"
Add-Content -Path $logFile -Value "   Copias esperadas por empresa: 1"
Add-Content -Path $logFile -Value "   Copias totales esperadas: $totalEmpresas"

if ($empresasIncompletas.Count -gt 0) {
    Add-Content -Path $logFile -Value "   ⚠ Empresas sin respaldo hoy:"
    foreach ($empresa in $empresasIncompletas) {
        Add-Content -Path $logFile -Value "      - $empresa"
    }
    Add-Content -Path $logFile -Value "   Total con error: $($empresasIncompletas.Count)"
} else {
    Add-Content -Path $logFile -Value "   ✅ Todas las empresas realizaron su copia de seguridad diaria."
}

Add-Content -Path $logFile -Value "===== [$fecha $hora] Fin del mantenimiento =====`n"
