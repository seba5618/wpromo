@ECHO off

set localpath=COMMON
set promopath=PROMOS
set pcpath=..\PC
set index=includes.xsl
set version=version.xml

REM Listado de Plantillas de Promociones que se incluiran

ECHO ^<?xml version="1.0" encoding="UTF-8"?^> > %index%
ECHO ^<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"^> >> %index%

cd ..\%promopath%
for %%x in (*.xsl) do ECHO   ^<xsl:include href="../%promopath%/%%x"/^>  >> ..\%localpath%\%index%
cd ..\%localpath%

ECHO ^</xsl:stylesheet^> >> %index%

ECHO -----------------------------------------------

REM Generacion de Informacion de Version del Sistema de Plantillas

ECHO ^<?xml version="1.0" encoding="UTF-8"?^> > %version%
ECHO ^<?xml-stylesheet type="text/xsl" href="prog.xsl"?^> >> %version%

ECHO ^<version^> >> %version%
ECHO   ^<sist_ver/^> >> %version%
ECHO   ^<sist_date/^> >> %version%
ECHO   ^<pc_ver/^> >> %version%

FOR /F "tokens=4 delims=] " %%A IN ('%pcpath%\pc -v') DO ECHO   ^<actual_pc_ver^>%%A^</actual_pc_ver^> >> %version%

ECHO   ^<promos_ver^> >> %version%
cd ..\%promopath%
type *.xsl | find "promotype" > temp.tmp
FOR /F "tokens=2 delims='" %%A IN ('type temp.tmp') DO ECHO   	^<promo promotype="%%A"/^> >> ..\%localpath%\%version%
del temp.tmp
cd ..\%localpath%
ECHO   ^</promos_ver^> >> %version%

ECHO ^</version^> >> %version%
