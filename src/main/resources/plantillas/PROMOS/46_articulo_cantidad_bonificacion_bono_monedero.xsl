﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Artículo cantidad bonificación en bono o monedero
	Autor: Elio Mauro Carreras
	Fecha: 25/07/2007
  **********************************************************************-->

<xsl:template match="promo[@promotype='articulo_cantidad_bonificacion_bono_monedero']">

	<xsl:param name="index">999</xsl:param>
	<xsl:param name="eval">prepago</xsl:param>
	<xsl:param name="view">main</xsl:param>
	<xsl:param name="excluded">excluded</xsl:param>
	<xsl:param name="benef">benef</xsl:param>
	<xsl:param name="beneficiados"></xsl:param>
	<xsl:param name="parametros"></xsl:param>
	<xsl:param name="condiciones"></xsl:param>
	<xsl:param name="beneficios">skip;</xsl:param>
	<xsl:param name="cash2benef"></xsl:param>
	<xsl:param name="point2benef"></xsl:param>
	<xsl:param name="cupon2benef"></xsl:param>
	<xsl:param name="bono2benef"></xsl:param>
	<xsl:param name="medio2benef"></xsl:param>
	<xsl:param name="verMode">info</xsl:param>

	<xsl:variable name="promo_name">Promoción: Artículo cantidad bonificación en bono o monedero</xsl:variable>
	<xsl:variable name="promo_version">1.0.4</xsl:variable>
	<xsl:variable name="promo_date">24/04/08</xsl:variable>
	<xsl:variable name="pc_version">1.9.13.16</xsl:variable>

	<xsl:variable name="cod_promo"><xsl:value-of select="$index"/></xsl:variable>

<!-- <<<<<<<<<<<<<< -->
	<xsl:variable name="promo_id">
		<xsl:value-of select="@id"/>
		<!--xsl:apply-templates select="promo_id"/-->
	</xsl:variable>
	<xsl:variable name="cod_externo"><xsl:apply-templates select="cod_externo"/></xsl:variable>

	<xsl:variable name="ignora_exclusion_arts"><xsl:apply-templates select="ignora_exclusion_arts"/></xsl:variable>
	<xsl:variable name="excluir"><xsl:apply-templates select="excluir"/></xsl:variable>

	<xsl:variable name="bolson"><xsl:apply-templates select="bolson"/></xsl:variable>
	<xsl:variable name="excluirplanes"><xsl:apply-templates select="excluirplanes"/></xsl:variable>

	<xsl:variable name="usar_min_arts_activa"><xsl:apply-templates select="usar_min_arts_activa"/></xsl:variable>
	<xsl:variable name="min_arts_activa"><xsl:apply-templates select="min_arts_activa"/></xsl:variable>

	<xsl:variable name="descontar"><xsl:apply-templates select="descontar"/></xsl:variable>
	<xsl:variable name="destino"><xsl:apply-templates select="destino"/></xsl:variable>

	<xsl:variable name="articulosprevios"><xsl:apply-templates select="previos/articulosprevios"/></xsl:variable>
	<xsl:variable name="deptoprevio"><xsl:apply-templates select="previos/deptoprevio"/></xsl:variable>

	<xsl:variable name="msj_monitor_latente"><xsl:apply-templates select="mensajes/msj_monitor_latente"/></xsl:variable>
	<xsl:variable name="msj_monitor_activa"><xsl:apply-templates select="mensajes/msj_monitor_activa"/></xsl:variable>
	<xsl:variable name="msj_ticket"><xsl:apply-templates select="mensajes/msj_ticket"/></xsl:variable>
	<xsl:variable name="msj_type"><xsl:apply-templates select="mensajes/type"/></xsl:variable>


<xsl:variable name="limitar_medio"><xsl:apply-templates select="limitar_medio"/></xsl:variable>

<xsl:variable name="medios"><xsl:for-each select="medios/m/medio">
<xsl:if test="@datatype = 'mutual'">
	m<xsl:number value="position()"/> = <xsl:apply-templates select="."/>;
</xsl:if>
<xsl:if test="@datatype = 'idcard'">
	m<xsl:number value="position()"/> = card(<xsl:if test=". = 0">null</xsl:if><xsl:if test=". &gt; 0">i<xsl:apply-templates select="."/></xsl:if>,<xsl:if test="../plan = 0">null</xsl:if><xsl:if test="../plan &gt; 0">p<xsl:apply-templates select="../plan"/></xsl:if>);
</xsl:if>
<xsl:if test="@datatype = 'ticket'">
	m<xsl:number value="position()"/> = <xsl:apply-templates select="."/>;
</xsl:if>
<xsl:if test="@datatype = 'cash'">
	m<xsl:number value="position()"/> = <xsl:apply-templates select="."/>;
</xsl:if>
<xsl:if test="@datatype = 'ctacte'">
	m<xsl:number value="position()"/> = <xsl:apply-templates select="."/>;
</xsl:if>
<xsl:if test="@datatype = 'cheque'">
	m<xsl:number value="position()"/> = <xsl:apply-templates select="."/>;
</xsl:if>
</xsl:for-each></xsl:variable>

<!-- >>>>>>>>>>>>>> -->



<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->


<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Articulo Cantidad Bonificación en Bono o Monedero *************

Promotion <xsl:value-of select="$eval"/> articulo_cantidad_bonificacion_bono_monedero_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
	requireAny<xsl:value-of select="$bolson"/>;

<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>


Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->
<xsl:if test="$limitar_medio='true'">
	<xsl:value-of select="$medios"/>
</xsl:if>

	descontar = <xsl:value-of select="$descontar"/>;
	bolson = <xsl:value-of select="$bolson"/>;
<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = (buyed - nopromotion) meet bolson;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = purchase meet bolson;
</xsl:if>

<xsl:if test="$destino='bono'">
	global publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="init"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	global publicar_plata_<xsl:value-of select="$index"/> = 0;
</xsl:if>
	global publicar_arts_<xsl:value-of select="$index"/> = {};


<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;



Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	|arts_a_bonificar| &gt;= 1;
<xsl:if test="$limitar_medio='true'">
	(%(100 * $arts_a_bonificar) / 100) &lt;= (%(100 * (<xsl:for-each select="medios/m">means.m<xsl:number value="position()"/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>)) / 100);
</xsl:if>
<xsl:if test="$excluirplanes='true'">
	(<xsl:for-each select="excluir_planes/card">means.<xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>) == 0;
</xsl:if>

<!-- monto minimo de articulos que activan la promocion -->
<xsl:if test="$usar_min_arts_activa='true'">
// monto minimo de articulos que activan la promocion
	(%(100 * $arts_a_bonificar) / 100) &gt;= <xsl:value-of select="$min_arts_activa"/>
</xsl:if>
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	valor = \arts_a_bonificar\ * descontar;

<xsl:if test="$destino='bono'">
	publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="val"><xsl:with-param name="valor" select="'valor'"/></xsl:apply-templates>;
	<xsl:value-of select="$benef"/> = valor * <xsl:value-of select="$bono2benef"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	publicar_plata_<xsl:value-of select="$index"/> = valor;
	<xsl:value-of select="$benef"/> = valor * <xsl:value-of select="$point2benef"/>;
</xsl:if>


	<xsl:if test="$excluir='true'">
		<xsl:value-of select="$excluded"/> = <xsl:value-of select="$excluded"/> + publicar_arts_<xsl:value-of select="$index"/>;
			// se excluyen los artículos bonificados para que no participen
			// de nuevas promociones.
	</xsl:if>


	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": LATENTE");

<xsl:if test="$msj_monitor_latente='true'">
	print(<xsl:for-each select="mensajes/latente/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>

<!-- >>>>>>>>>>>>>> -->

<xsl:value-of select="$beneficios"/>
</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo articulo_cantidad_bonificacion_bono_monedero_<xsl:value-of select="$cod_promo"/>
<xsl:if test="$destino='bono'">
	extern publicar_bono_<xsl:value-of select="$index"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	extern publicar_plata_<xsl:value-of select="$index"/>;
</xsl:if>
	extern publicar_arts_<xsl:value-of select="$index"/>;
	// -------------------------------- promo articulo_cantidad_bonificacion_bono_monedero_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo articulo_cantidad_bonificacion_bono_monedero_<xsl:value-of select="$cod_promo"/>

<xsl:if test="$destino='bono'">
	issueBonus(publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>
<xsl:if test="$destino='monedero'">
	givePoints(point money,publicar_plata_<xsl:value-of select="$index"/>);
</xsl:if>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

	rec(artsBeneficiary, publicar_arts_<xsl:value-of select="$index"/>);
<xsl:if test="preconditions/bool_perfil='true'">
	rec(perfil, per);
</xsl:if>
<xsl:if test="$destino='bono'">
	rec(bonusBenefit,publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>
<xsl:if test="$destino='monedero'">
	rec(pointsBenefit, point money, publicar_plata_<xsl:value-of select="$index"/>);
</xsl:if>

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>



	// ------------------------------------------ promo articulo_cantidad_bonificacion_bono_monedero_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>


<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->




<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>




	</xsl:template>

</xsl:stylesheet>
