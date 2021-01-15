<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Artículo plan de pago
	Autor: Elio Mauro Carreras
	Fecha: 12/03/2007
  **********************************************************************-->

<xsl:template match="promo[@promotype='articulo_cantidad_cupon_externo']">

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

	<xsl:variable name="promo_name">Promoción: Artículo cantidad cupon externo</xsl:variable>
	<xsl:variable name="promo_version">1.0.3</xsl:variable>
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

	<xsl:variable name="cupon_externo"><xsl:apply-templates select="cupon_externo"/></xsl:variable>
	<xsl:variable name="precio_cupon"><xsl:apply-templates select="precio_cupon"/></xsl:variable>

	<xsl:variable name="articulosprevios"><xsl:apply-templates select="previos/articulosprevios"/></xsl:variable>
	<xsl:variable name="deptoprevio"><xsl:apply-templates select="previos/deptoprevio"/></xsl:variable>

	<xsl:variable name="msj_monitor_latente"><xsl:apply-templates select="mensajes/msj_monitor_latente"/></xsl:variable>
	<xsl:variable name="msj_monitor_activa"><xsl:apply-templates select="mensajes/msj_monitor_activa"/></xsl:variable>
	<xsl:variable name="msj_ticket"><xsl:apply-templates select="mensajes/msj_ticket"/></xsl:variable>
	<xsl:variable name="msj_type"><xsl:apply-templates select="mensajes/type"/></xsl:variable>
<!-- >>>>>>>>>>>>>> -->



<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Artículo Plan de Pago *************

Promotion <xsl:value-of select="$eval"/> articulo_cantidad_cupon_externo_<xsl:value-of select="$cod_promo"/>

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
<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


<!-- <<<<<<<<<<<<<< -->
	global promo_activada_<xsl:value-of select="$index"/> = false;
	global cupon_externo_<xsl:value-of select="$index"/> = <xsl:value-of select="$cupon_externo"/>;
	global cantidad_<xsl:value-of select="$index"/> = 0;
	global publicar_arts_<xsl:value-of select="$index"/> = {};

	bolson = <xsl:value-of select="$bolson"/>;
	precio_cupon = <xsl:value-of select="$precio_cupon"/>;
<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = (buyed - nopromotion) meet bolson;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = purchase meet bolson;
</xsl:if>

<!-- >>>>>>>>>>>>>> -->


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	|arts_a_bonificar| &gt;= 1;
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	ms_copia = {};
	for (a,k) in arts_a_bonificar do
		if((%(100 * ${(a,bolson.a)}) / 100) &gt;= precio_cupon)then
			ms_copia = ms_copia + {(a,&amp;(k / bolson.a))};
		fi;
	od;
	
	publicar_arts_<xsl:value-of select="$index"/> = ms_copia;
	cantidad_<xsl:value-of select="$index"/> = \ms_copia\ * precio_cupon;

	<xsl:value-of select="$benef"/> = cantidad_<xsl:value-of select="$index"/> * <xsl:value-of select="$medio2benef"/>;

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


<!--  /////////////////////////////////////////////////////////////////////////////////  -->
<!--  /////////////////////////////////////////////////////////////////////////////////  -->

<!-- AQUI COMIENZA LA SECCION POSTPAGO DE LA PROMO  -   PARA IMPRIMIR MENSAJES EN TICKET -->


//********** Promoción Invel: Artículo Plan de Pago // Impresiones en el Ticket  *************

Promotion postpago articulo_cantidad_cupon_externo_LOGS_<xsl:value-of select="$cod_promo"/>

PreConditions

	true

Parameters

	extern promo_activada_<xsl:value-of select="$index"/>;
	extern cupon_externo_<xsl:value-of select="$index"/>;


Conditions

	true

Benefits

	if promo_activada_<xsl:value-of select="$index"/> then
		if (means.cupon_externo_<xsl:value-of select="$index"/> &gt; 0 ) then
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
		skip;
		fi;
	fi;


</xsl:if>






<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo articulo_cantidad_cupon_externo_<xsl:value-of select="$cod_promo"/>
	extern cupon_externo_<xsl:value-of select="$index"/>;
	extern cantidad_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;

	extern promo_activada_<xsl:value-of select="$index"/>;
	// -------------------------------- promo articulo_cantidad_cupon_externo_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>







<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo articulo_cantidad_cupon_externo_<xsl:value-of select="$cod_promo"/>



promo_activada_<xsl:value-of select="$index"/> = true;

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);
	activateMean(cupon_externo_<xsl:value-of select="$index"/>, cantidad_<xsl:value-of select="$index"/>);
	rec(artsBeneficiary, publicar_arts_<xsl:value-of select="$index"/>);
	rec(meanBenefit, cupon_externo_<xsl:value-of select="$index"/>, cantidad_<xsl:value-of select="$index"/>);
<xsl:if test="preconditions/bool_perfil='true'">
	rec(perfil, per);
</xsl:if>

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>

<!--xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if-->


	// ------------------------------------------ promo articulo_cantidad_cupon_externo_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>





<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>


	</xsl:template>

</xsl:stylesheet>
