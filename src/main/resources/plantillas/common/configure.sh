#!/bin/bash
# configure.sh
# Generar archivo de inclusión de plantillas: "includes.xsl" 
# Generar archivo de versionado de plantillas: "version.xml" 

export localpath=common
export promopath=promos
export pcpath=../pc
export index=includes.xsl
export version=version.xml

# Listado de Plantillas de Promociones que se incluiran

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $index
echo "<xsl:stylesheet xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\" version=\"1.0\">" >> $index

cd ../$promopath
for x in `ls *.xsl`; do 
	echo "  <xsl:include href=\"../"$promopath"/$x\"/>"  >> ../$localpath/$index
done
cd ../$localpath

echo "</xsl:stylesheet>" >> $index

echo -----------------------------------------------

# Generacion de Informacion de Version del Sistema de Plantillas

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $version
echo "<?xml-stylesheet type=\"text/xsl\" href=\"prog.xsl\"?>" >> $version

echo "<version>" >> $version
echo "  <sist_ver/>" >> $version
echo "  <sist_date/>" >> $version
echo "  <pc_ver/>" >> $version

$pcpath/pc -v | awk -F "[" '{ print $2 }' | awk -F " " '{ print $2 }' | awk -F "]" '{ system("echo \"  <actual_pc_ver>"$1"</actual_pc_ver>\"") }' >> $version

echo "  <promos_ver>" >> $version
cd ../$promopath
cat *.xsl | grep promotype | awk -F "'"  '{ system("echo \"  	<promo promotype=\\\"\""$2"\"\\\"/>\" >> ../$localpath/$version") }'

cd ../$localpath
echo "  </promos_ver>" >> $version

echo "</version>" >> $version

