﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Grupo cupón en bono
	Autor: Elio Mauro Carreras
	Fecha: 12/03/2007
  **********************************************************************-->

<xsl:template match="promo[@promotype='grupo_cupon_bono']">

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

	<xsl:variable name="promo_name">Promoción: Grupo cupón en bono</xsl:variable>
	<xsl:variable name="promo_version">1.9.0</xsl:variable>
	<xsl:variable name="promo_date">13/03/09</xsl:variable>
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
	<xsl:variable name="excluir_articulos_precio_oferta"><xsl:apply-templates select="excluir_articulos_precio_oferta"/></xsl:variable>

	<xsl:variable name="limite"><xsl:apply-templates select="limite"></xsl:apply-templates></xsl:variable>
	<xsl:variable name="bolson"><xsl:apply-templates select="bolson"/></xsl:variable>
	<xsl:variable name="excluirplanes"><xsl:apply-templates select="excluirplanes"/></xsl:variable>

	<xsl:variable name="tipo_descuento"><xsl:apply-templates select="tipo_descuento"/></xsl:variable>
	<xsl:variable name="descuento"><xsl:apply-templates select="descuento"/></xsl:variable>
	<xsl:variable name="descuento_fijo"><xsl:apply-templates select="descuento_fijo"/></xsl:variable>

	<xsl:variable name="por_cada2"><xsl:apply-templates select="por_cada2"/></xsl:variable>
	<xsl:variable name="num_cupones"><xsl:apply-templates select="num_cupones"/></xsl:variable>

	<xsl:variable name="articulosprevios"><xsl:apply-templates select="previos/articulosprevios"/></xsl:variable>
	<xsl:variable name="deptoprevio"><xsl:apply-templates select="previos/deptoprevio"/></xsl:variable>

	<xsl:variable name="msj_monitor_latente"><xsl:apply-templates select="mensajes/msj_monitor_latente"/></xsl:variable>
	<xsl:variable name="msj_monitor_activa"><xsl:apply-templates select="mensajes/msj_monitor_activa"/></xsl:variable>
	<xsl:variable name="msj_ticket"><xsl:apply-templates select="mensajes/msj_ticket"/></xsl:variable>
	<xsl:variable name="msj_type"><xsl:apply-templates select="mensajes/type"/></xsl:variable>
<!-- >>>>>>>>>>>>>> -->




<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<xsl:if test="$tipo_descuento='porcentual'">


<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Grupo Cupón en Bono *************

Promotion <xsl:value-of select="$eval"/> grupo_cupon_bono_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
	requireAll<xsl:value-of select="$bolson"/>;
<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>


Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->
	limite_entrega = <xsl:value-of select="$limite"/>;
		// cantidad maxima de grupos a analizar por ticket.
	descuento = <xsl:value-of select="$descuento"/>;

	por_cada2 = <xsl:value-of select="$por_cada2"/>;
	num_cupones = <xsl:value-of select="$num_cupones"/>;

	bolson = <xsl:value-of select="$bolson"/>;

<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = (buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet bolson;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = (purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet bolson;
</xsl:if>

	global publicar_arts_<xsl:value-of select="$index"/> = {};
	global publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="init"/>;
	global cantidad_<xsl:value-of select="$index"/> = 0;


<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	|arts_a_bonificar| == |bolson|;
		// se debe comprar todos los productos en las cantidades
		// indicadas para aplicar descuento.
<xsl:if test="$excluirplanes='true'">
	(<xsl:for-each select="excluir_planes/card">means.<xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>) == 0;
</xsl:if>
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	c = limite_entrega;
	for (a,k) in arts_a_bonificar do
		c = c min &amp;(k / bolson.a);
	od;

	valor = 0;
	valor = (descuento * c * $bolson);

	publicar_arts_<xsl:value-of select="$index"/> = c * bolson;
	cantidad_<xsl:value-of select="$index"/> = (&amp;(valor / por_cada2) * num_cupones);

	<xsl:value-of select="$benef"/> = cantidad_<xsl:value-of select="$index"/> * <xsl:value-of select="$cupon2benef"/>;


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
	// Parametros correspondientes a la promo grupo_cupon_bono_<xsl:value-of select="$cod_promo"/>
	extern publicar_arts_<xsl:value-of select="$index"/>;
	extern publicar_bono_<xsl:value-of select="$index"/>;
	extern cantidad_<xsl:value-of select="$index"/>;
	// -------------------------------- promo grupo_cupon_bono_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo grupo_cupon_bono_<xsl:value-of select="$cod_promo"/>

	issueBonus(publicar_bono_<xsl:value-of select="$index"/>,cantidad_<xsl:value-of select="$index"/>);

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

	rec(artsBeneficiary, publicar_arts_<xsl:value-of select="$index"/>);
<xsl:if test="preconditions/bool_perfil='true'">
	rec(perfil, per);
</xsl:if>
	rec(bonusBenefit,publicar_bono_<xsl:value-of select="$index"/>,cantidad_<xsl:value-of select="$index"/>);

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>




	// ------------------------------------------ promo grupo_cupon_bono_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>


</xsl:if> <!--//////// fin descuento porcentual /////////-->

<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->







<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<xsl:if test="$tipo_descuento='monto fijo'">


<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Grupo Cupón en Bono *************

Promotion <xsl:value-of select="$eval"/> grupo_descuento_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
	requireAll<xsl:value-of select="$bolson"/>;
<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>


Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->
	limite_entrega = <xsl:value-of select="$limite"/>;
		// cantidad maxima de grupos a analizar por ticket.

	descuento_fijo = <xsl:value-of select="$descuento_fijo"/>;

	por_cada2 = <xsl:value-of select="$por_cada2"/>;
	num_cupones = <xsl:value-of select="$num_cupones"/>;

	bolson = <xsl:value-of select="$bolson"/>;

<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = (buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet bolson;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = (purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet bolson;
</xsl:if>

	global publicar_arts_<xsl:value-of select="$index"/> = {};
	global publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="init"/>;
	global cantidad_<xsl:value-of select="$index"/> = 0;


<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	|arts_a_bonificar| == |bolson|;
		// se debe comprar todos los productos en las cantidades
		// indicadas para aplicar descuento.
	$bolson &gt;= descuento_fijo;
<xsl:if test="$excluirplanes='true'">
	(<xsl:for-each select="excluir_planes/card">means.<xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>) == 0;
</xsl:if>
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	c = limite_entrega;
	for (a,k) in arts_a_bonificar do
		c = c min &amp;(k / bolson.a);
	od;

	valor = 0;
	valor = (descuento_fijo * c);

	publicar_arts_<xsl:value-of select="$index"/> = c * bolson;
	cantidad_<xsl:value-of select="$index"/> = (&amp;(valor / por_cada2) * num_cupones);

	<xsl:value-of select="$benef"/> = cantidad_<xsl:value-of select="$index"/> * <xsl:value-of select="$cupon2benef"/>;


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
	// Parametros correspondientes a la promo grupo_cupon_bono_<xsl:value-of select="$cod_promo"/>
	extern publicar_arts_<xsl:value-of select="$index"/>;
	extern publicar_bono_<xsl:value-of select="$index"/>;
	extern cantidad_<xsl:value-of select="$index"/>;
	// -------------------------------- promo grupo_cupon_bono_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo grupo_cupon_bono_<xsl:value-of select="$cod_promo"/>

	issueBonus(publicar_bono_<xsl:value-of select="$index"/>,cantidad_<xsl:value-of select="$index"/>);

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

	rec(artsBeneficiary, publicar_arts_<xsl:value-of select="$index"/>);
<xsl:if test="preconditions/bool_perfil='true'">
	rec(perfil, per);
</xsl:if>
	rec(bonusBenefit,publicar_bono_<xsl:value-of select="$index"/>,cantidad_<xsl:value-of select="$index"/>);

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>



	// ------------------------------------------ promo grupo_cupon_bono_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



</xsl:if> <!--//////// fin descuento monto fijo /////////-->

<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->



<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>


	</xsl:template>

</xsl:stylesheet>
