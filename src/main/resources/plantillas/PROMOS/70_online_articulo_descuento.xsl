﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promocion: Online - Articulo descuento en ticket
	Autor: Fabian Ramirez
	Fecha: 21/02/2011
  **********************************************************************-->

<xsl:template match="promo[@promotype='online_articulo_descuento']">

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

	<xsl:variable name="promo_name">Promocion Articulo descuento en ticket</xsl:variable>
	<xsl:variable name="promo_version">1.0.0</xsl:variable>
	<xsl:variable name="promo_date">21/02/11</xsl:variable>
	<xsl:variable name="pc_version">1.12.21.24</xsl:variable>

	<xsl:variable name="cod_promo"><xsl:value-of select="$index"/></xsl:variable>

<!-- <<<<<<<<<<<<<< -->
	<xsl:variable name="promo_id">
		<xsl:value-of select="@id"/>
		<!--xsl:apply-templates select="promo_id"/-->
	</xsl:variable>
	<xsl:variable name="cod_externo"><xsl:apply-templates select="cod_externo"/></xsl:variable>

	<xsl:variable name="ignora_exclusion_arts"><xsl:apply-templates select="ignora_exclusion_arts"/></xsl:variable>
	<xsl:variable name="excluir"><xsl:apply-templates select="excluir"/></xsl:variable>
	<xsl:variable name="excluir_articulos_precio_oferta"><xsl:apply-templates select="excluir_articulos_precio_oferta"/></xsl:variable>

	<xsl:variable name="bolson"><xsl:apply-templates select="bolson"/></xsl:variable>

	<xsl:variable name="usar_min_arts_activa"><xsl:apply-templates select="usar_min_arts_activa"/></xsl:variable>
	<xsl:variable name="min_arts_activa"><xsl:apply-templates select="min_arts_activa"/></xsl:variable>

	<xsl:variable name="tipo_descuento"><xsl:apply-templates select="tipo_descuento"/></xsl:variable>
	<xsl:variable name="descuento"><xsl:apply-templates select="descuento"/></xsl:variable>
	<xsl:variable name="por_cada"><xsl:apply-templates select="por_cada"/></xsl:variable>
	<xsl:variable name="descuento_fijo"><xsl:apply-templates select="descuento_fijo"/></xsl:variable>

	<xsl:variable name="eans"><xsl:apply-templates select="nuevo_eans"/></xsl:variable>
	<xsl:variable name="descarga"><xsl:apply-templates select="descarga"/></xsl:variable>

	<xsl:variable name="articulosprevios"><xsl:apply-templates select="previos/articulosprevios"/></xsl:variable>
	<xsl:variable name="deptoprevio"><xsl:apply-templates select="previos/deptoprevio"/></xsl:variable>

	<xsl:variable name="msj_monitor_latente"><xsl:apply-templates select="mensajes/msj_monitor_latente"/></xsl:variable>
	<xsl:variable name="msj_monitor_activa"><xsl:apply-templates select="mensajes/msj_monitor_activa"/></xsl:variable>
	<xsl:variable name="msj_ticket"><xsl:apply-templates select="mensajes/msj_ticket"/></xsl:variable>
	<xsl:variable name="msj_type"><xsl:apply-templates select="mensajes/type"/></xsl:variable>
<!-- >>>>>>>>>>>>>> -->



<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promocion Invel: Articulo Descuento en Ticket *************

Promotion online online_articulo_descuento_<xsl:value-of select="$cod_promo"/>
//Promotion <xsl:value-of select="$eval"/> articulo_descuento_tkt_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->
<!--
PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
	requireAny<xsl:value-of select="$bolson"/>;

-->
Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->
	descuento = <xsl:value-of select="$descuento"/>;
	bolson = <xsl:value-of select="$bolson"/>;
<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = (added - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet (0.01 * bolson);
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = (added - nopromotion  <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet (0.01 * bolson);
</xsl:if>

	//global publicar_arts_<xsl:value-of select="$index"/> = {};
	//global publicar_<xsl:value-of select="$index"/> = {};
<xsl:if test="$eans='uno'">
	//global descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;
	descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;
</xsl:if>

<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	|arts_a_bonificar| &gt;= 1;



Benefits

	// Aplicando Beneficios correspondientes a la promo articulo_descuento_tkt_<xsl:value-of select="$cod_promo"/>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

<!-- <<<<<<<<<<<<<< -->
	for (a,k) in arts_a_bonificar do
		//bolson_a = bolson.a;
		//publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a,${(a,bolson_a)} * descuento * &amp;(k/bolson_a))};
		//publicar_arts_<xsl:value-of select="$index"/> = publicar_arts_<xsl:value-of select="$index"/> + {(a, bolson_a * &amp;(k/bolson_a))};


	<xsl:if test="$eans='varios'">
    credit(a, descuento * ${(a,k)}, {(a,k)});
	</xsl:if>
	<xsl:if test="$eans='uno'">
    credit(descarga_<xsl:value-of select="$index"/>, descuento * ${(a,k)}, {(a,k)});
	</xsl:if>
    rec(artsBeneficiary, {(a,k)});
    rec(creditBenefit, descuento * ${(a,k)});



	<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + {(a,k)};
	<xsl:value-of select="$benef"/> = (descuento * ${(a,k)}) * <xsl:value-of select="$cash2benef"/>;

	<xsl:if test="$excluir='true'">
		<xsl:value-of select="$excluded"/> = <xsl:value-of select="$excluded"/> + {(a,k)};
			// se excluyen los articulos bonificados para que no participen
			// de nuevas promociones.
	</xsl:if>


	od;

<xsl:if test="preconditions/bool_perfil='true'">
	rec(perfil, per);
</xsl:if>

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>


Cancellation
Parameters
<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = (cancelled - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet (0.01 * bolson);
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = (cancelled - nopromotion  <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet (0.01 * bolson);
</xsl:if>

Conditions
	|arts_a_bonificar| &gt;= 1;

Benefits

	// Aplicando Beneficios correspondientes a la promo articulo_descuento_tkt_<xsl:value-of select="$cod_promo"/>
	// Informando eventos
	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

	for (a,k) in arts_a_bonificar do

	<xsl:if test="$eans='varios'">
    credit(a, -descuento * ${(a,k)}, {(a,k)});
	</xsl:if>
	<xsl:if test="$eans='uno'">
    credit(descarga_<xsl:value-of select="$index"/>, -descuento * ${(a,k)}, {(a,k)});
	</xsl:if>
    rec(artsBeneficiary, {(a,k)});
    rec(creditBenefit, -descuento * ${(a,k)});



	<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> - {(a,k)};
	<xsl:value-of select="$benef"/> = (-descuento * ${(a,k)}) * <xsl:value-of select="$cash2benef"/>;

	<xsl:if test="$excluir='true'">
		<xsl:value-of select="$excluded"/> = <xsl:value-of select="$excluded"/> - {(a,k)};
			// se excluyen los articulos bonificados para que no participen
			// de nuevas promociones.
	</xsl:if>
	od;

<xsl:if test="preconditions/bool_perfil='true'">
	rec(perfil, per);
</xsl:if>

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>


<xsl:value-of select="$beneficios"/>
</xsl:if>






<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versi򬸠<xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>



	</xsl:template>

</xsl:stylesheet>
