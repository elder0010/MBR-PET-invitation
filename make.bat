@echo off
Taskkill /IM xpet.exe /F
set KICKASS_PATH="bin\Kickass.jar"

call java -jar %KICKASS_PATH% mbr.asm -o mbr.pet

start mbr.pet