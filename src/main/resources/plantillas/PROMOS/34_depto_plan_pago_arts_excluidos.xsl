<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Departamento plan de pago con artículos excluidos
	Autor: Elio Mauro Carreras
	Fecha: 12/03/2007
  **********************************************************************-->

<xsl:template match="promo[@promotype='depto_plan_pago_arts_excluidos']">

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

	<xsl:variable name="promo_name">Promoción: Departamento plan de pago con artículos excluidos</xsl:variable>
	<xsl:variable name="promo_version">1.8.7</xsl:variable>
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

	<xsl:variable name="bolson">{<xsl:for-each select="bolson/item">(<xsl:apply-templates select="element"/>,99999)<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>}</xsl:variable>
	<xsl:variable name="deptos"><xsl:apply-templates select="deptos"/></xsl:variable>

	<xsl:variable name="articulosprevios"><xsl:apply-templates select="previos/articulosprevios"/></xsl:variable>
	<xsl:variable name="deptoprevio"><xsl:apply-templates select="previos/deptoprevio"/></xsl:variable>

	<xsl:variable name="usar_min_arts_activa"><xsl:apply-templates select="usar_min_arts_activa"/></xsl:variable>
	<xsl:variable name="min_arts_activa"><xsl:apply-templates select="min_arts_activa"/></xsl:variable>

	<xsl:variable name="msj_medio"><xsl:apply-templates select="mensaje_medios/msj_medio"/></xsl:variable>

	<xsl:variable name="msj_monitor_latente"><xsl:apply-templates select="mensajes/msj_monitor_latente"/></xsl:variable>
	<xsl:variable name="msj_monitor_activa"><xsl:apply-templates select="mensajes/msj_monitor_activa"/></xsl:variable>
	<xsl:variable name="msj_ticket"><xsl:apply-templates select="mensajes/msj_ticket"/></xsl:variable>
	<xsl:variable name="msj_type"><xsl:apply-templates select="mensajes/type"/></xsl:variable>
<!-- >>>>>>>>>>>>>> -->



<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Departamento Plan de Pago con Artículos excluidos*************

Promotion <xsl:value-of select="$eval"/> depto_plan_pago_arts_excluidos_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>


Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->
	global promo_activada_<xsl:value-of select="$index"/> = false;

	bolson = <xsl:value-of select="$bolson"/>;
	deptos = <xsl:value-of select="$deptos"/>;
<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = ((buyed - nopromotion) meet 0.001 * deptos) - bolson;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = (purchase meet 0.001 * deptos) - bolson;
</xsl:if>

	global cantidad_<xsl:value-of select="$index"/> = 0;
	global publicar_arts_<xsl:value-of select="$index"/> = {};


<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	|arts_a_bonificar| &gt; 0;
<xsl:if test="$msj_medio='true'">
	input(<xsl:for-each select="mensaje_medios/texto/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>"++"&amp;"++"&amp;NO: escape       SI: enter");
</xsl:if>

<!-- monto minimo de articulos que activan la promocion -->
<xsl:if test="$usar_min_arts_activa='true'">
// monto minimo de articulos que activan la promocion
	(%(100 * $arts_a_bonificar) / 100) &gt;= <xsl:value-of select="$min_arts_activa"/>
</xsl:if>
<!-- >>>>>>>>>>>>>> -->

Benefits

<!-- <<<<<<<<<<<<<< -->
	publicar_arts_<xsl:value-of select="$index"/> = arts_a_bonificar;
	cantidad_<xsl:value-of select="$index"/> = $arts_a_bonificar;

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


//********** Promoción Invel: Departamento Plan de Pago con Artículos excluidos // Impresiones en el Ticket  *************

Promotion postpago depto_plan_pago_arts_excluidos_LOGS_<xsl:value-of select="$cod_promo"/>

PreConditions

	true

Parameters

	extern promo_activada_<xsl:value-of select="$index"/>;


Conditions

	true

Benefits

	if promo_activada_<xsl:value-of select="$index"/> then
		if (<xsl:for-each select="medio/card">means.<xsl:apply-templates select="."/> &gt; 0 <xsl:if test="not(position()=last())"> || </xsl:if></xsl:for-each>) then
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
		skip;
		fi;
	fi;


</xsl:if>






<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo depto_plan_pago_arts_excluidos_<xsl:value-of select="$cod_promo"/>
	extern cantidad_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;

	extern promo_activada_<xsl:value-of select="$index"/>;
	// -------------------------------- promo depto_plan_pago_arts_excluidos_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>







<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo depto_plan_pago_arts_excluidos_<xsl:value-of select="$cod_promo"/>

promo_activada_<xsl:value-of select="$index"/> = true;

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);
<xsl:for-each select="medio/card">
	activateMean(<xsl:apply-templates select="."/>,cantidad_<xsl:value-of select="$index"/>);
	rec(artsBeneficiary, publicar_arts_<xsl:value-of select="$index"/>);
	rec(meanBenefit, <xsl:apply-templates select="."/>, cantidad_<xsl:value-of select="$index"/>);
</xsl:for-each>
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


	// ------------------------------------------ promo depto_plan_pago_arts_excluidos_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>




<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>


	</xsl:template>

</xsl:stylesheet>
