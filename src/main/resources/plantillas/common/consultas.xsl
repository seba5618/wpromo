<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exslt="http://exslt.org/common" version="1.0">
<xsl:output method="text" encoding="ISO-8859-1"/>
<!--********************************************************************-->
<!--  Transformación para la Generación de Scripts SQL para Consultas   -->
<!--  Autor: Fabián Ramírez                                             -->
<!--  Autor2: Marcelo mancuso 29/09/2017                                -->
<xsl:variable name="sist_version">1.2.009</xsl:variable>
<xsl:variable name="sist_date">22/02/2011</xsl:variable>
<!--********************************************************************-->

<!--
Definición de Tipos de Promociones

# Tipos de Promociones
# 1- Articulos
# 2- Articulos Exceptuados
# 3- Departamentos
# 4- Departamentos Exceptuados
# 5- Clasificaciones
# 6- Clasificaciones Exceptuadas
# 7- Incondicional
# 8- Departamentos, Con Artículos Excluidos
# 9- Perfiles le agregue yo

-->


<xsl:template match="sist_ver">[Versión: <xsl:value-of select="$sist_version"/>]</xsl:template>
<xsl:template match="sist_date">[Fecha: <xsl:value-of select="$sist_date"/>]</xsl:template>

<xsl:variable name="val_afinidad" select="/prog/promo[@promotype='global_config']/consultas/validar_afinidad"/>
<xsl:variable name="val_vigencia" select="/prog/promo[@promotype='global_config']/consultas/validar_vigencia"/>
<xsl:variable name="val_rangofecha" select="/prog/promo[@promotype='global_config']/consultas/validar_rangofecha"/>
<xsl:variable name="val_rangohora" select="/prog/promo[@promotype='global_config']/consultas/validar_rangohora"/>
<xsl:variable name="val_rangocaja" select="/prog/promo[@promotype='global_config']/consultas/validar_rangocaja"/>
<xsl:variable name="val_perfil" select="/prog/promo[@promotype='global_config']/consultas/validar_perfil"/>
<xsl:variable name="val_rangotarjeta" select="/prog/promo[@promotype='global_config']/consultas/validar_rangotarjeta"/>


<xsl:template match="prog">
###### <xsl:value-of select="$val_rangohora"/>

#
# Script de Consulta de Promociones generado con Versión de Plantillas Nro: <xsl:value-of select="$sist_version"/> - (<xsl:value-of select="$sist_date"/>)
#

# Vaciado de Tablas
TRUNCATE TABLE promos_participantes;
TRUNCATE TABLE promos_vigencia;

	<xsl:for-each select="promo">
	  <xsl:variable name="promo_id" select="@id"/>
# Promoción <xsl:value-of select="$promo_id"/> - <xsl:value-of select="@promotype"/>
# Condiciones de Vigencia.
		<xsl:apply-templates select="preconditions">
			<xsl:with-param name="promo_id"><xsl:value-of select="@id"/></xsl:with-param>
			<xsl:with-param name="promo_name"><xsl:value-of select="@promotype"/></xsl:with-param>
			<xsl:with-param name="promo_desc"><xsl:value-of select="name"/></xsl:with-param>
			<xsl:with-param name="bonifico_arts2"><xsl:value-of select="bonifico_arts"/></xsl:with-param>
			<xsl:with-param name="por_cada_arts2"><xsl:value-of select="por_cada_arts"/></xsl:with-param>
			<xsl:with-param name="cantidad_comprar"><xsl:value-of select="cantidad_comprar"/></xsl:with-param>
			<xsl:with-param name="cantidad_entregar"><xsl:value-of select="cantidad_entregar"/></xsl:with-param>
			<xsl:with-param name="descuento"><xsl:value-of select="descuento"/></xsl:with-param>
			<xsl:with-param name="descuento2"><xsl:value-of select="descuento2"/></xsl:with-param>
			<xsl:with-param name="promo_detalle"><xsl:value-of select="por_cada_arts"/></xsl:with-param>
			<xsl:with-param name="descarga"><xsl:value-of select="descarga/cod_int"/></xsl:with-param>
			<xsl:with-param name="detalle"><xsl:value-of select="detalle/linea"/></xsl:with-param>
			<xsl:with-param name="vcantdisparantes"><xsl:value-of select="count(comprar/item/element)"/></xsl:with-param>
			<xsl:with-param name="vcantbeneficios"><xsl:value-of select="count(entregar/item/element)"/></xsl:with-param>
			<xsl:with-param name="cantidad_limite"><xsl:value-of select="cantidad_limite"/></xsl:with-param>
			<xsl:with-param name="precio_fijo"><xsl:value-of select="precio_fijo"/></xsl:with-param>
			<xsl:with-param name="promo_type">
				<xsl:choose>
					<xsl:when test="bolson and not(deptos)">1</xsl:when>
					<!--<xsl:when test="comprar">1</xsl:when>-->
					<xsl:when test="comprar and not(entregar)">1</xsl:when>
					<xsl:when test="grupo">1</xsl:when>
					<xsl:when test="arts_disparantes">1</xsl:when>
					<xsl:when test="articulo">1</xsl:when>
					<xsl:when test="excluir_arts and excluir_arts='true' and not(deptos)">2</xsl:when>
					<xsl:when test="deptos and (not(deptos_excluidos) or (deptos_excluidos='false')) and not(bolson)">3</xsl:when>
					<xsl:when test="deptos_excluidos and deptos_excluidos='true'">4</xsl:when>
					<xsl:when test="clasificaciones">5</xsl:when>
					<xsl:when test="incondicional">7</xsl:when>
					<xsl:when test="bolson and deptos and por_cada_arts">8</xsl:when>
					<xsl:when test="por_cada_arts">1</xsl:when>
					<xsl:when test="comprar and entregar">1</xsl:when>
					<xsl:otherwise>9</xsl:otherwise>
					<!--xsl:when test="clasificaciones">6</xsl:when-->
					<!--xsl:when test="not(bolson) and not(comprar) and not(grupo) and not(arts_disparantes) and not(excluir_arts) and not(deptos) and not(deptos_excluidos) and not(clasificaciones)">7</xsl:when-->
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="affiliated"><xsl:if test="affiliated">1</xsl:if><xsl:if test="not(affiliated)">0</xsl:if></xsl:with-param>
		</xsl:apply-templates>

		<xsl:for-each select="preconditions/perfil">
INSERT INTO promos_participantes (cod_promo, cod_perfil) VALUES("<xsl:value-of select="$promo_id"/>", "<xsl:value-of select="."/><xsl:if test=".=''">0</xsl:if>");
		</xsl:for-each>
		
# Articulos Participantes.
		<xsl:if test="bolson">
			<xsl:apply-templates select="bolson">
				<xsl:with-param name="promo_id"><xsl:value-of select="@id"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="comprar">
			<xsl:apply-templates select="comprar">
				<xsl:with-param name="promo_id"><xsl:value-of select="@id"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="grupo">
			<xsl:apply-templates select="grupo">
				<xsl:with-param name="promo_id"><xsl:value-of select="@id"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="arts_disparantes">
			<xsl:apply-templates select="arts_disparantes">
				<xsl:with-param name="promo_id"><xsl:value-of select="@id"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="articulo">
			<xsl:apply-templates select="articulo">
				<xsl:with-param name="promo_id"><xsl:value-of select="@id"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="por_cada_arts">
			<xsl:apply-templates select="articulos">
				<xsl:with-param name="promo_id"><xsl:value-of select="@id"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
# Articulos Beneficiados.		
		<xsl:if test="comprar and cantidad_entregar">
			<xsl:apply-templates select="entregar">
				<xsl:with-param name="promo_id"><xsl:value-of select="@id"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		
		
# Departamentos Participantes.
		<xsl:if test="deptos">
			<xsl:apply-templates select="deptos">
				<xsl:with-param name="promo_id"><xsl:value-of select="@id"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>

# Clasificaciones Participantes.
		<xsl:if test="clasificaciones">
			<xsl:apply-templates select="clasificaciones">
				<xsl:with-param name="promo_id"><xsl:value-of select="@id"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>



	</xsl:for-each>

</xsl:template>




<xsl:template match="preconditions">
<xsl:param name="promo_id"/>
<xsl:param name="promo_name"/>
<xsl:param name="promo_desc"/>
<xsl:param name="promo_detalle"/>
<xsl:param name="por_cada_arts2"/>
<xsl:param name="cantidad_comprar"/>
<xsl:param name="cantidad_entregar"/>
<xsl:param name="bonifico_arts2"/>
<xsl:param name="descuento"/>
<xsl:param name="descuento2"/>
<xsl:param name="cantidad_limite"/>
<xsl:param name="precio_fijo"/>
<xsl:param name="descarga"/>
<xsl:param name="detalle"/>
<xsl:param name="vcantdisparantes"/>
<xsl:param name="vcantbeneficios"/>
<xsl:param name="promo_type">0</xsl:param>
<xsl:param name="affiliated">0</xsl:param>



<xsl:variable name="vafinidad">
	<xsl:choose>
		<xsl:when test="$val_afinidad='true'">"<xsl:value-of select="$affiliated"/>"</xsl:when>
		<xsl:when test="$val_afinidad='false'">"0"</xsl:when>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="vvigencia">
	<xsl:choose>
		<xsl:when test="$val_vigencia='true'">"<xsl:apply-templates select="vigencia"/>"</xsl:when>
		<xsl:when test="$val_vigencia='false' and vigencia='false'">"<xsl:apply-templates select="vigencia"/>"</xsl:when>
		<xsl:when test="$val_vigencia='false' and vigencia='true'">"<xsl:apply-templates select="vigencia"/>"</xsl:when>
	<!-- este es el original	<xsl:when test="$val_vigencia='false'">"0"</xsl:when>-->
	</xsl:choose>
</xsl:variable>

<xsl:variable name="vrfecha">
	<xsl:choose>
		<xsl:when test="$val_rangofecha='true'">"<xsl:apply-templates select="rangofecha"/>"</xsl:when>
		<xsl:when test="$val_rangofecha='false'">"<xsl:apply-templates select="rangofecha"/>"</xsl:when>
<!--		<xsl:when test="$val_rangofecha='false'">"0"</xsl:when> -->
	</xsl:choose>
</xsl:variable>

<xsl:variable name="vrhora">
	<xsl:choose>
		<xsl:when test="$val_rangohora='true'">"<xsl:apply-templates select="rangohora"/>"</xsl:when>
		<xsl:when test="$val_rangohora='false'">"0"</xsl:when>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="vrcaja">
	<xsl:choose>
		<xsl:when test="$val_rangocaja='true'">"<xsl:apply-templates select="rangocaja"/>"</xsl:when>
		<xsl:when test="$val_rangocaja='false'">"<xsl:apply-templates select="rangocaja"/>"</xsl:when>
	<!--		<xsl:when test="$val_rangocaja='false'">"0"</xsl:when> -->
	</xsl:choose>
</xsl:variable>

<xsl:variable name="vperfil">
	<xsl:choose>
		<xsl:when test="$val_perfil='true'">"<xsl:apply-templates select="bool_perfil"/>"</xsl:when>
		<xsl:when test="$val_perfil='false' and bool_perfil='false'">"0"</xsl:when>
		<xsl:when test="$val_perfil='false' and bool_perfil='true'">"<xsl:apply-templates select="perfil"/>"</xsl:when>  
	</xsl:choose>
</xsl:variable>

<xsl:variable name="vrtarjeta">
	<xsl:choose>
		<xsl:when test="$val_rangotarjeta='true'">"<xsl:apply-templates select="rangotarjeta"/>"</xsl:when>
		<xsl:when test="$val_rangotarjeta='false'">"0"</xsl:when>
	</xsl:choose>
</xsl:variable>


<!-- Texto informativo de condiciones de vigencia -->
<xsl:variable name="tafinidad">
	<xsl:choose>
		<xsl:when test="$val_afinidad='true'"></xsl:when>
		<xsl:when test="$val_afinidad='false' and $affiliated='1'">Para clientes fieles.\n</xsl:when>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="tvigencia">
	<xsl:choose>
		<xsl:when test="$val_vigencia='true'"></xsl:when>
		<xsl:when test="$val_vigencia='false' and vigencia='true'">Sólo días: <xsl:apply-templates select="conjunto_dias"/>.\n</xsl:when>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="trfecha">
	<xsl:choose>
		<xsl:when test="$val_rangofecha='true'"></xsl:when>
		<xsl:when test="$val_rangofecha='false' and rangofecha='true'">Desde el <xsl:call-template name="fecha"><xsl:with-param name="date" select="rango_fecha/v0"/></xsl:call-template> hasta el <xsl:call-template name="fecha"><xsl:with-param name="date" select="rango_fecha/v1"/></xsl:call-template>.\n</xsl:when>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="trhora">
	<xsl:choose>
		<xsl:when test="$val_rangohora='true'"></xsl:when>
		<xsl:when test="$val_rangohora='false' and rangohora='true'">Desde las <xsl:value-of select="rango_hora/v0"/> hs hasta las <xsl:value-of select="rango_hora/v1"/> hs.\n</xsl:when>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="trcaja">
	<xsl:choose>
		<xsl:when test="$val_rangocaja='true'"></xsl:when>
		<xsl:when test="$val_rangocaja='false' and rangocaja='true'">Desde caja nro. <xsl:apply-templates select="rango_caja/v0"/> hasta caja nro. <xsl:apply-templates select="rango_caja/v1"/>.\n</xsl:when>  
	</xsl:choose>
</xsl:variable>

<xsl:variable name="tperfil">
	<xsl:choose>
		<xsl:when test="$val_perfil='true'"></xsl:when>
		<xsl:when test="$val_perfil='false' and bool_perfil='true'">Para perfil de cliente nro. <xsl:apply-templates select="perfil"/>.\n</xsl:when>  
	</xsl:choose>
</xsl:variable>

<xsl:variable name="trtarjeta">
	<xsl:choose>
		<xsl:when test="$val_rangotarjeta='true'"></xsl:when>
		<xsl:when test="$val_rangotarjeta='false' and rangotarjeta='true'">
			<xsl:for-each select="rango_tarjeta/inter">Tarjetas entre <xsl:apply-templates select="v0"/> y <xsl:apply-templates select="v1"/>.\n</xsl:for-each>
		</xsl:when>  
	</xsl:choose>
</xsl:variable>


<xsl:variable name="promo_detalle"><xsl:value-of select="$por_cada_arts2"/>;<xsl:value-of select="$bonifico_arts2"/>;<xsl:value-of select="$descuento * 100"/>;<xsl:value-of select="$descarga"/>;<xsl:value-of select="$detalle"/></xsl:variable> 
<xsl:variable name="tinfo"><xsl:value-of select="$tafinidad"/><xsl:value-of select="$tvigencia"/><xsl:value-of select="$trfecha"/><xsl:value-of select="$trhora"/><xsl:value-of select="$trcaja"/><xsl:value-of select="$tperfil"/><xsl:value-of select="$trtarjeta"/> </xsl:variable>

<!-- Para las promos que procesa la caja cambiamos el detalle -->
<xsl:variable name="promo_detalle">
	<xsl:choose>
	  <xsl:when test="$promo_name='almacor_articulo_cantidad_agregar_articulo_ticket'">
		<xsl:value-of select="$vcantdisparantes"/>;<xsl:value-of select="$vcantbeneficios"/>;<xsl:value-of select="$cantidad_comprar"/>;<xsl:value-of select="$cantidad_entregar"/>;<xsl:value-of select="$descuento2 * 100"/>;<xsl:value-of select="$detalle"/>
	  </xsl:when>
	  	  <xsl:when test="$promo_name='grupo_parcial_precio_fijo_ticket'">
		   <xsl:value-of select="$cantidad_limite"/>;<xsl:value-of select="$precio_fijo"/>;<xsl:value-of select="$detalle"/>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:value-of select="$por_cada_arts2"/>;<xsl:value-of select="$bonifico_arts2"/>;<xsl:value-of select="$descuento * 100"/>;<xsl:value-of select="$descarga"/>;<xsl:value-of select="$detalle"/>
	  </xsl:otherwise>
	</xsl:choose>
 </xsl:variable>

<xsl:if test="rango_tarjeta/inter">
	<xsl:for-each select="rango_tarjeta/inter">
	INSERT INTO promos_vigencia(    cod_promo, nombre, descripcion, rango_hora, hora_desde, hora_hasta, rango_fecha, fecha_desde, fecha_hasta, tipo, dias, domingo, lunes, martes, miercoles, jueves, viernes, sabado, perfil, rango_caja, caja_desde, caja_hasta, rango_tarjeta, tarjeta_desde, tarjeta_hasta, afinidad, detalle, info) VALUES("<xsl:value-of select="$promo_id"/>", "<xsl:value-of select="$promo_name"/>", "<xsl:value-of select="$promo_desc"/>", <xsl:value-of select="$vrhora"/>, "<xsl:apply-templates select="../../rango_hora/v0"/>", "<xsl:apply-templates select="../../rango_hora/v1"/>", <xsl:value-of select="$vrfecha"/>, "<xsl:apply-templates select="../../rango_fecha/v0"/>", "<xsl:apply-templates select="../../rango_fecha/v1"/>", "<xsl:value-of select="$promo_type"/>", <xsl:value-of select="$vvigencia"/>, "<xsl:call-template name="days"><xsl:with-param name="setday" select="../../conjunto_dias"/><xsl:with-param name="day">sunday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="../../conjunto_dias"/><xsl:with-param name="day">monday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="../../conjunto_dias"/><xsl:with-param name="day">tuesday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="../../conjunto_dias"/><xsl:with-param name="day">wednesday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="../../conjunto_dias"/><xsl:with-param name="day">thursday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="../../conjunto_dias"/><xsl:with-param name="day">friday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="../../conjunto_dias"/><xsl:with-param name="day">saturday</xsl:with-param></xsl:call-template>", <xsl:value-of select="$vperfil"/>, <xsl:value-of select="$vrcaja"/>, "<xsl:apply-templates select="../../rango_caja/v0"/><xsl:if test="not(../../rango_caja/v0)">0</xsl:if><xsl:if test="../../rango_caja/v0=''">0</xsl:if>", "<xsl:apply-templates select="../../rango_caja/v1"/><xsl:if test="not(../../rango_caja/v1)">0</xsl:if><xsl:if test="../../rango_caja/v1=''">0</xsl:if>", <xsl:value-of select="$vrtarjeta"/>, "<xsl:apply-templates select="v0"/>", "<xsl:apply-templates select="v1"/>", <xsl:value-of select="$vafinidad"/>, "<xsl:value-of select="$promo_detalle"/>");
	</xsl:for-each>
</xsl:if>


<xsl:if test="not(rango_tarjeta/inter)">
INSERT INTO promos_vigencia (cod_promo, nombre, descripcion, rango_hora, hora_desde, hora_hasta, rango_fecha, fecha_desde, fecha_hasta, tipo, dias, domingo, lunes, martes, miercoles, jueves, viernes, sabado, perfil, rango_caja, caja_desde, caja_hasta, rango_tarjeta, tarjeta_desde, tarjeta_hasta, afinidad, detalle, info) VALUES("<xsl:value-of select="$promo_id"/>", "<xsl:value-of select="$promo_name"/>", "<xsl:value-of select="$promo_desc"/>", <xsl:value-of select="$vrhora"/>, "<xsl:apply-templates select="rango_hora/v0"/>", "<xsl:apply-templates select="rango_hora/v1"/>", <xsl:value-of select="$vrfecha"/>, "<xsl:apply-templates select="rango_fecha/v0"/>", "<xsl:apply-templates select="rango_fecha/v1"/>", "<xsl:value-of select="$promo_type"/>", <xsl:value-of select="$vvigencia"/>, "<xsl:call-template name="days"><xsl:with-param name="setday" select="conjunto_dias"/><xsl:with-param name="day">sunday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="conjunto_dias"/><xsl:with-param name="day">monday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="conjunto_dias"/><xsl:with-param name="day">tuesday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="conjunto_dias"/><xsl:with-param name="day">wednesday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="conjunto_dias"/><xsl:with-param name="day">thursday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="conjunto_dias"/><xsl:with-param name="day">friday</xsl:with-param></xsl:call-template>", "<xsl:call-template name="days"><xsl:with-param name="setday" select="conjunto_dias"/><xsl:with-param name="day">saturday</xsl:with-param></xsl:call-template>", <xsl:value-of select="$vperfil"/>, <xsl:value-of select="$vrcaja"/>, "<xsl:apply-templates select="rango_caja/v0"/><xsl:if test="not(rango_caja/v0)">0</xsl:if><xsl:if test="rango_caja/v0=''">0</xsl:if>", "<xsl:apply-templates select="rango_caja/v1"/><xsl:if test="not(rango_caja/v1)">0</xsl:if><xsl:if test="rango_caja/v1=''">0</xsl:if>", <xsl:value-of select="$vrtarjeta"/>, "0", "0", <xsl:value-of select="$vafinidad"/>, "<xsl:value-of select="$promo_detalle"/>", "<xsl:value-of select="$tinfo"/>");
</xsl:if>

</xsl:template>


<xsl:template match="*[@datatype='amset']">
<xsl:param name="promo_id"/>
<xsl:for-each select="item/element">
INSERT INTO promos_participantes (cod_promo, cod_art_int, cod_art_bar) VALUES("<xsl:value-of select="$promo_id"/>", "<xsl:value-of select="cod_int"/>", "<xsl:value-of select="cod_bar"/>");
</xsl:for-each>
</xsl:template>


<xsl:template match="*[@datatype='article']">
<xsl:param name="promo_id"/>
INSERT INTO promos_participantes (cod_promo, cod_art_int, cod_art_bar) VALUES("<xsl:value-of select="$promo_id"/>", "<xsl:value-of select="cod_int"/>", "<xsl:value-of select="cod_bar"/>");
</xsl:template>


<xsl:template match="*[@datatype='union_deptos']">
<xsl:param name="promo_id"/>
<xsl:for-each select="d">
INSERT INTO promos_participantes (cod_promo, cod_dept) VALUES("<xsl:value-of select="$promo_id"/>", "<xsl:value-of select="depto"/>");
</xsl:for-each>
</xsl:template>



<xsl:template match="*[@datatype='union_clasificaciones']">
<xsl:param name="promo_id"/>
<xsl:for-each select="clasificacion">
INSERT INTO promos_participantes (cod_promo, cod_class_nivel, cod_class_concepto) VALUES("<xsl:value-of select="$promo_id"/>", "<xsl:value-of select="nivel"/>", "<xsl:value-of select="concept"/>");
</xsl:for-each>
</xsl:template>


<xsl:template name="days">
<xsl:param name="setday"/>
<xsl:param name="day"/>
<xsl:for-each select="$setday/day"><xsl:if test=".=$day">1</xsl:if></xsl:for-each>
</xsl:template>

<xsl:template match="*[@datatype='bool']"><xsl:if test=".='true'">1</xsl:if><xsl:if test=".='false'">0</xsl:if></xsl:template>
	
<xsl:template match="*[@datatype='date']"><xsl:value-of select="year"/>/<xsl:value-of select="month"/>/<xsl:value-of select="day"/></xsl:template>

<xsl:template name="fecha">
<xsl:param name="date"/>
<xsl:value-of select="$date/day"/>/<xsl:value-of select="$date/month"/>/<xsl:value-of select="$date/year"/>
</xsl:template>

<xsl:template match="*[@datatype='time']"><xsl:if test="not(.='')"><xsl:value-of select="."/>:00</xsl:if><xsl:if test=".=''">00:00:00</xsl:if></xsl:template>

<xsl:template match="conjunto_dias">
	<xsl:for-each select="day">
		<xsl:choose>
			<xsl:when test=".='monday'">lunes</xsl:when>
			<xsl:when test=".='tuesday'">martes</xsl:when>
			<xsl:when test=".='wednesday'">miércoles</xsl:when>
			<xsl:when test=".='thursday'">jueves</xsl:when>
			<xsl:when test=".='friday'">viernes</xsl:when>
			<xsl:when test=".='saturday'">sábados</xsl:when>
			<xsl:when test=".='sunday'">domingos</xsl:when>
		</xsl:choose>		
		<xsl:if test="not(position()=last())">, </xsl:if>
	</xsl:for-each>
</xsl:template>


</xsl:stylesheet>

