<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Clasificación Puntos Obliga Medios
	Autor: Elio Mauro Carreras
	Fecha: 26/05/2008
  **********************************************************************-->

<xsl:template match="promo[@promotype='clasificacion_puntos_obliga_medios']">

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

	<xsl:variable name="promo_name">Promoción: Clasificación Puntos Obliga Medios</xsl:variable>
	<xsl:variable name="promo_version">1.0.2</xsl:variable>
	<xsl:variable name="promo_date">14/08/2008</xsl:variable>
	<xsl:variable name="pc_version">1.11.15.18</xsl:variable>


	<xsl:variable name="cod_promo"><xsl:value-of select="$index"/></xsl:variable>

<!-- <<<<<<<<<<<<<< -->
	<xsl:variable name="promo_id">
		<xsl:value-of select="@id"/>
		<!--xsl:apply-templates select="promo_id"/-->
	</xsl:variable>
	<xsl:variable name="cod_externo"><xsl:apply-templates select="cod_externo"/></xsl:variable>

	<xsl:variable name="ignora_exclusion_arts"><xsl:apply-templates select="ignora_exclusion_arts"/></xsl:variable>
	<xsl:variable name="excluir"><xsl:apply-templates select="excluir"/></xsl:variable>

	<xsl:variable name="clasificaciones"><xsl:apply-templates select="clasificaciones"/></xsl:variable>
	<xsl:variable name="msj_obliga_medios"><xsl:apply-templates select="mensaje_medios/msj_obliga_medios"/></xsl:variable>

	<xsl:variable name="medios_requeridos">{<xsl:for-each select="medios/m/medio">
			<xsl:if test="@datatype = 'mutual'">mutual m<xsl:value-of select="."/>s<xsl:apply-templates select="../plan"/></xsl:if>
			<xsl:if test="@datatype = 'idcard'">card(<xsl:if test=". = 0">null</xsl:if><xsl:if test=". &gt; 0">i<xsl:apply-templates select="."/></xsl:if>,<xsl:if test="../plan = 0">null</xsl:if><xsl:if test="../plan &gt; 0">p<xsl:apply-templates select="../plan"/></xsl:if>)</xsl:if>
			<xsl:if test="@datatype = 'ticket'">ticket m<xsl:value-of select="."/>s<xsl:apply-templates select="../plan"/></xsl:if>
			<xsl:if test="@datatype = 'cash'"><xsl:apply-templates select="."/></xsl:if>
			<xsl:if test="@datatype = 'ctacte'"><xsl:apply-templates select="."/></xsl:if>
			<xsl:if test="@datatype = 'cheque'"><xsl:apply-templates select="."/></xsl:if>
			<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>}
	</xsl:variable>

<!-- >>>>>>>>>>>>>> -->



<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Promoción: Clasificación Puntos Obliga Medios *************

Promotion <xsl:value-of select="$eval"/> clasificacion_puntos_obliga_medios_<xsl:value-of select="$cod_promo"/>


Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->

	clasificaciones = <xsl:value-of select="$clasificaciones"/>;
	medios_requeridos = <xsl:value-of select="$medios_requeridos"/>;

<!-- >>>>>>>>>>>>>> -->

<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


<xsl:if test="$ignora_exclusion_arts='true'">
	monto = $((buyed - nopromotion) meet clasificaciones);
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	monto = $(purchase meet clasificaciones);
</xsl:if>


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	monto &gt; 0;
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->

	requireMeans(medios_requeridos, monto);

<xsl:if test="$msj_obliga_medios='true'">
	print("Se debe pagar: "++ monto ++ "pesos con los siguientes medios" ++	<xsl:for-each select="mensaje_medios/mensaje/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>



<!-- >>>>>>>>>>>>>> -->

<xsl:value-of select="$beneficios"/>
</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->

	// -------------------------------- promo articulo_descuento_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo clasificacion_puntos_obliga_medios_<xsl:value-of select="$cod_promo"/>

	// ------------------------------------------ promo clasificacion_puntos_obliga_medios_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>




<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>


	</xsl:template>

</xsl:stylesheet>
