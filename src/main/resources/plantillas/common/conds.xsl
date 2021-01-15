<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml"/>

<xsl:strip-space elements="conditions"/>

<!--***********************************************************************
	Condiciones Generales para Todas las Promociones
	Version: 0.3
	Autor: Fabian Ramirez
	Fecha: 19/09/2011
  **********************************************************************-->


<xsl:template match="preconditions">
  <xsl:param name="view">main</xsl:param>
	
	<xsl:variable name="promo_id"><xsl:value-of select="../@id"/></xsl:variable>
  <xsl:variable name="rangocaja"><xsl:apply-templates select="rangocaja"/></xsl:variable>
  <xsl:variable name="rangofecha"><xsl:apply-templates select="rangofecha"/></xsl:variable>
  <xsl:variable name="rangohora"><xsl:apply-templates select="rangohora"/></xsl:variable>
  <xsl:variable name="vigencia"><xsl:apply-templates select="vigencia"/></xsl:variable>
  <xsl:variable name="rangotarjeta"><xsl:apply-templates select="rangotarjeta"/></xsl:variable>
  <xsl:variable name="bool_perfil"><xsl:apply-templates select="bool_perfil"/></xsl:variable>
  <xsl:variable name="bool_excluir_perfil"><xsl:apply-templates select="bool_excluir_perfil"/></xsl:variable>
  <xsl:variable name="cliente_frec"><xsl:apply-templates select="cliente_frec"/></xsl:variable>
  <xsl:variable name="cantidad_entregar"><xsl:apply-templates select="cantidad_entregar"/></xsl:variable>


<xsl:if test="$view='main'">

<xsl:if test="$rangofecha='true'">
	date in <xsl:apply-templates select="rango_fecha"/>;
</xsl:if>
<xsl:if test="$rangohora='true'">
	time in <xsl:apply-templates select="rango_hora"/>;
</xsl:if>
<xsl:if test="$vigencia='true'">
	day in <xsl:apply-templates select="conjunto_dias"/>;
</xsl:if>
<xsl:if test="$rangocaja='true'">
	cashdesk in <xsl:apply-templates select="rango_caja"/>;
</xsl:if>
log(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": VIGENTE");
	<!--log(file, "Promo "++ <xsl:apply-templates select="../promo_id"/> ++ ": VIGENTE");-->
<xsl:if test="$bool_perfil='true'">
	per == <xsl:apply-templates select="perfil"/>;
</xsl:if>
<xsl:if test="$bool_excluir_perfil='true'">
	per != <xsl:apply-templates select="excluir_perfil"/>;
</xsl:if>
<xsl:if test="$cliente_frec='true'">
	cliente_frecuente;
</xsl:if>

<xsl:if test="$rangotarjeta='true'">
	<xsl:for-each select="rango_tarjeta/inter"> ( <xsl:apply-templates select="v0"/> &lt;= tarjeta &amp;&amp; tarjeta &lt;= <xsl:apply-templates select="v1"/> ) <xsl:if test="not(position()=last())"> || </xsl:if></xsl:for-each>;
</xsl:if>

</xsl:if>

</xsl:template>


<!--/////////////////////////////////////////////////////////////////////////////-->
<!--/////////////////////////////////////////////////////////////////////////////-->


<xsl:template match="conditions">
  <xsl:param name="view">main</xsl:param>

   <xsl:variable name="montomin"><xsl:apply-templates select="montomin"/></xsl:variable>
   <xsl:variable name="montomax"><xsl:apply-templates select="montomax"/></xsl:variable>
   <xsl:variable name="modo_monto"><xsl:apply-templates select="modo_monto"/></xsl:variable>

<!--xsl:if test="$view='parameters'">
	<xsl:if test="$modo_monto='bruto'">	extern wpurch;</xsl:if>
	<xsl:if test="$modo_monto='neto'">	wpurch_local = $wholepurchase;</xsl:if>
</xsl:if>

<xsl:if test="$view='main'">
<xsl:if test="$montomin='true'">
<xsl:text>	</xsl:text><xsl:if test="$modo_monto='bruto'">wpurch</xsl:if><xsl:if test="$modo_monto='neto'">wpurch_local</xsl:if> >= <xsl:apply-templates select="monto_min"/>;
</xsl:if>
<xsl:if test="$montomax='true'">
<xsl:text>	</xsl:text><xsl:if test="$modo_monto='bruto'">wpurch</xsl:if><xsl:if test="$modo_monto='neto'">wpurch_local</xsl:if> &lt;= <xsl:apply-templates select="monto_max"/>;
</xsl:if-->

<xsl:if test="$view='parameters'">
	extern wpurch;
</xsl:if>

<xsl:if test="$view='main'">
<xsl:if test="$montomin='true'">
(%(100 * wpurch) / 100) &gt;= <xsl:apply-templates select="monto_min"/>;
</xsl:if>
<xsl:if test="$montomax='true'">
(%(100 * wpurch) / 100) &lt;= <xsl:apply-templates select="monto_max"/>;
</xsl:if>

	<!--xsl:apply-templates select="../conditions2"/-->

</xsl:if>

</xsl:template>


<!--xsl:template match="conditions2">
	<xsl:variable name="exclusivo"><xsl:apply-templates select="exclusivo"/></xsl:variable>
	<xsl:if test="$exclusivo='afinidad'">affiliated;</xsl:if><xsl:if test="$exclusivo='noafinidad'">!affiliated;</xsl:if>
</xsl:template-->




</xsl:stylesheet>
