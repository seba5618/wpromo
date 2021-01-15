<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promocion Importe total descuento interactivo
	Autor: Fabian Ramirez
	Fecha: 5/10/2011
  **********************************************************************-->

<xsl:template match="promo[@promotype='importe_total_descuento_interactivo']">

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

	<xsl:variable name="promo_name">Promocion: Importe total descuento interactivo</xsl:variable>
	<xsl:variable name="promo_version">1.0.1</xsl:variable>
	<xsl:variable name="promo_date">06/10/2011</xsl:variable>
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

	<xsl:variable name="tipo_descuento"><xsl:apply-templates select="tipo_descuento"/></xsl:variable>

	<xsl:variable name="descarga"><xsl:apply-templates select="descarga"/></xsl:variable>

	<xsl:variable name="articulosprevios"><xsl:apply-templates select="previos/articulosprevios"/></xsl:variable>
	<xsl:variable name="deptoprevio"><xsl:apply-templates select="previos/deptoprevio"/></xsl:variable>

	<xsl:variable name="msj_monitor_latente"><xsl:apply-templates select="mensajes/msj_monitor_latente"/></xsl:variable>
	<xsl:variable name="msj_monitor_activa"><xsl:apply-templates select="mensajes/msj_monitor_activa"/></xsl:variable>
	<xsl:variable name="msj_ticket"><xsl:apply-templates select="mensajes/msj_ticket"/></xsl:variable>
	<xsl:variable name="msj_type"><xsl:apply-templates select="mensajes/type"/></xsl:variable>
<!-- >>>>>>>>>>>>>> -->




<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->


<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promocion Invel: Importe Total Descuento Interactivo *************

Promotion <xsl:value-of select="$eval"/> importe_total_descuento_interactivo_<xsl:value-of select="$cod_promo"/>

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>
  true;

Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->

	global descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;
	global valor_<xsl:value-of select="$index"/> = 0;


<!-- >>>>>>>>>>>>>> -->

<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;



Conditions

<xsl:apply-templates select="conditions"/>
  true;

Benefits

<!-- <<<<<<<<<<<<<< -->

<xsl:if test="$tipo_descuento='porcentual'">
	valor_<xsl:value-of select="$index"/> = numinput ( "Descuento Porcentual&amp;Porcentaje a descontar: %" );
	if (valor_<xsl:value-of select="$index"/> &lt; 0) || (valor_<xsl:value-of select="$index"/> &gt;= 100) then
		valor_<xsl:value-of select="$index"/> = 0;
	fi;
	
</xsl:if>

<xsl:if test="$tipo_descuento='monto fijo'">
	valor_<xsl:value-of select="$index"/> = numinput ( "Descuento Fijo&amp;Monto a descontar: $" );
	if (valor_<xsl:value-of select="$index"/> &lt; 0) || (valor_<xsl:value-of select="$index"/> &gt;= $wholepurchase) then
		valor_<xsl:value-of select="$index"/> = 0;
	fi;
</xsl:if>


<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + wholepurchase;
<xsl:value-of select="$benef"/> = $wholepurchase * <xsl:value-of select="$cash2benef"/>;


<xsl:if test="$excluir='true'">
	<xsl:value-of select="$excluded"/> = <xsl:value-of select="$excluded"/> + wholepurchase;
		// se excluyen los articulos bonificados para que no participen
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
	// Parametros correspondientes a la promo importe_total_descuento_interactivo_<xsl:value-of select="$cod_promo"/>
	extern descarga_<xsl:value-of select="$index"/>;
	extern valor_<xsl:value-of select="$index"/>;
	// -------------------------------- promo importe_total_descuento_interactivo_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo importe_total_descuento_interactivo_<xsl:value-of select="$cod_promo"/>


<xsl:if test="$tipo_descuento='porcentual'">
	monto = valor_<xsl:value-of select="$index"/> / 100 * $wholepurchase;
</xsl:if>

<xsl:if test="$tipo_descuento='monto fijo'">
	monto = valor_<xsl:value-of select="$index"/>;
</xsl:if>

	if (monto > 0) &amp;&amp; (monto &lt; $wholepurchase) then
		// Informando eventos
		rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);
		credit(descarga_<xsl:value-of select="$index"/>,monto,wholepurchase);
		rec(artsBeneficiary, wholepurchase);
		rec(creditBenefit, monto);

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

	fi;

	// ------------------------------------------ promo importe_total_descuento_interactivo_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->



<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Version: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>


	</xsl:template>

</xsl:stylesheet>
