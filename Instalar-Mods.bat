@echo off
title Instalador Automático de Modpack Minecraft (Limpieza Total)
color 0A
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║    INSTALADOR AUTOMÁTICO DE MODPACK MINECRAFT    ║
echo  ╚══════════════════════════════════════════════════╝
echo.
echo.


set "URL=https://github.com/jesusmuentes/server_mc/releases/download/v1.0/mods.zip"


set "tempdir=%temp%\mc_modpack_%random%"
set "zipfile=!tempdir!\modpack.zip"
set "extract=!tempdir!\extracted"
set "minecraft=%APPDATA%\.minecraft"
set "modsdir=!minecraft!\mods"

mkdir "!tempdir!" 2>nul
mkdir "!extract!" 2>nul

echo [1/5] Verificando instalación de Minecraft...
if not exist "!minecraft!" (
    echo [ERROR] No se encontró .minecraft
    goto :enderror
)

echo [2/5] Descargando modpack...
powershell -Command "try { Invoke-WebRequest -Uri '%URL%' -OutFile '%zipfile%' -UseBasicParsing -TimeoutSec 300 } catch { exit 1 }"
if not exist "!zipfile!" (
    echo [ERROR] Fallo la descarga. Revisa el link.
    goto :enderror
)

echo [3/5] Descomprimiendo...
powershell -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '%extract%' -Force" 2>nul
if not exist "!extract!\mods" (
    echo [ERROR] El ZIP no tiene carpeta "mods" en la raíz.
    goto :enderror
)

echo [4/5] Instalando mods...
if not exist "!modsdir!" mkdir "!modsdir!"

:: ←←← AQUÍ ESTÁ LA LIMPIEZA TOTAL ←←←
echo     Borrando todos los mods anteriores...
del /q "!modsdir!\*.*" >nul 2>&1
for /d %%x in ("!modsdir!\*") do rd /s /q "%%x" >nul 2>&1
:: ←←← FIN DE LA LIMPIEZA ←←←

robocopy "!extract!\mods" "!modsdir!" /E /MT:8 /R:2 /W:5 >nul

echo [5/5] Limpiando temporales...
rd /s /q "!tempdir!" >nul 2>&1

echo.
echo  ¡MODPACK INSTALADO!
echo  Ruta: !modsdir!
echo.
pause
exit /b 0

:enderror
rd /s /q "!tempdir!" >nul 2>&1
echo.
echo  Error durante la instalación.
pause