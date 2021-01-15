<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Artículo Dispara Video
	Autor: Elio Mauro Carreras
	Fecha: 16/07/2008
  **********************************************************************-->

<xsl:template match="promo[@promotype='articulo_dispara_video']">

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

	<xsl:variable name="promo_name">Promoción: Artículo Dispara Video</xsl:variable>
	<xsl:variable name="promo_version">1.0.2</xsl:variable>
	<xsl:variable name="promo_date">12/05/11</xsl:variable>
	<xsl:variable name="pc_version">1.12.19.22</xsl:variable>

	<xsl:variable name="cod_promo"><xsl:value-of select="$index"/></xsl:variable>

<!-- <<<<<<<<<<<<<< -->
	<xsl:variable name="promo_id">
		<xsl:value-of select="@id"/>
		<!--xsl:apply-templates select="promo_id"/-->
	</xsl:variable>

	<xsl:variable name="cod_externo"><xsl:apply-templates select="cod_externo"/></xsl:variable>
	<xsl:variable name="bolson"><xsl:apply-templates select="bolson"/></xsl:variable>
	<xsl:variable name="video"><xsl:apply-templates select="video"/></xsl:variable>
	<xsl:variable name="n_veces"><xsl:apply-templates select="n_veces"/></xsl:variable>
	
	<xsl:variable name="msj_monitor_latente"><xsl:apply-templates select="mensajes/msj_monitor_latente"/></xsl:variable>
	<xsl:variable name="msj_monitor_activa"><xsl:apply-templates select="mensajes/msj_monitor_activa"/></xsl:variable>
	<xsl:variable name="msj_ticket"><xsl:apply-templates select="mensajes/msj_ticket"/></xsl:variable>
	<xsl:variable name="msj_type"><xsl:apply-templates select="mensajes/type"/></xsl:variable>
<!-- >>>>>>>>>>>>>> -->



<!-- /////////////////////////////////////////////////////////////////// -->
<!-- Se muestra el video cada vez que se tickea un artículo del conjunto -->
<!-- /////////////////////////////////////////////////////////////////// -->
<xsl:if test="$n_veces='muchas'">

<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Articulo Dispara Video *************

Promotion online articulo_dispara_video_<xsl:value-of select="$cod_promo"/>

//PreConditions

//	requireAny<xsl:value-of select="$bolson"/>;

Parameters

	//extern anteriores;

	bolson = <xsl:value-of select="$bolson"/>;
	//arts = (purchase meet bolson) - anteriores;
	arts = added meet bolson;
	

Conditions

	|arts| &gt; 0;

Benefits

//	print("<xsl:value-of select="$video"/>");
	eproc (ivideo, "file=<xsl:value-of select="$video"/>");
	//anteriores = purchase;

Cancellation
Benefits
 skip;

</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo articulo_dispara_video_<xsl:value-of select="$cod_promo"/>

	// -------------------------------- promo articulo_dispara_video_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo articulo_dispara_video_<xsl:value-of select="$cod_promo"/>

	// ------------------------------------------ promo articulo_dispara_video_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>


</xsl:if>





<!-- /////////////////////////////////////// -->
<!-- Se muestra el video solo la primera vez -->
<!-- /////////////////////////////////////// -->
<xsl:if test="$n_veces='una_sola'">

<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Articulo Dispara Video *************

Promotion online articulo_dispara_video_<xsl:value-of select="$cod_promo"/>

//PreConditions

//	requireAny<xsl:value-of select="$bolson"/>;

Parameters

	extern primera_vez;

	bolson = <xsl:value-of select="$bolson"/>;
	arts = purchase meet bolson;


Conditions

	primera_vez;
	|arts| &gt; 0;


Benefits

//	print("<xsl:value-of select="$video"/>");
	eproc (ivideo, "file=<xsl:value-of select="$video"/>");
	primera_vez = false;


Cancellation
Benefits
 skip;

</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo articulo_dispara_video_<xsl:value-of select="$cod_promo"/>

	// -------------------------------- promo articulo_dispara_video_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo articulo_dispara_video_<xsl:value-of select="$cod_promo"/>

	// ------------------------------------------ promo articulo_dispara_video_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>


</xsl:if>











<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>





	</xsl:template>

</xsl:stylesheet>
