<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: M x N articulos iguales (multiple) en ticket
	Autor: Elio Mauro Carreras
	Fecha: 30/05/2007
  **********************************************************************-->

<xsl:template match="promo[@promotype='m_x_n_articulos_iguales_multiple_tkt']">

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

	<xsl:variable name="promo_name">Promoción: M x N articulos iguales (multiple) en ticket</xsl:variable>
	<xsl:variable name="promo_version">1.2.1</xsl:variable>
	<xsl:variable name="promo_date">09/04/12</xsl:variable>
	<xsl:variable name="pc_version">1.10.14.16</xsl:variable>

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

	<xsl:variable name="descuento"><xsl:apply-templates select="descuento"/></xsl:variable>

	<xsl:variable name="por_cada_arts"><xsl:apply-templates select="por_cada_arts"/></xsl:variable>
	<xsl:variable name="bonifico_arts"><xsl:apply-templates select="bonifico_arts"/></xsl:variable>

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

//********** Promoción Invel: M x N articulos iguales (multiple) en ticket *************

Promotion <xsl:value-of select="$eval"/> m_x_n_articulos_iguales_multiple_ticket_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
	requireAny{<xsl:for-each select="articulos/item">(<xsl:apply-templates select="element"/>,<xsl:value-of select="$por_cada_arts"/>)<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>};

<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>


Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->
	por_cada_arts = <xsl:value-of select="$por_cada_arts"/>;
	bonifico_arts = <xsl:value-of select="$bonifico_arts"/>;

	descuento = <xsl:value-of select="$descuento"/>;
<xsl:for-each select="articulos/item">
	art_<xsl:number value="position()"/> = <xsl:apply-templates select="element"/>;
</xsl:for-each>

<xsl:if test="$ignora_exclusion_arts='true'">
<xsl:for-each select="articulos/item">
	arts_a_bonificar_<xsl:number value="position()"/> = (buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet {(art_<xsl:number value="position()"/>,1)};
</xsl:for-each>
</xsl:if>

<xsl:if test="$ignora_exclusion_arts='false'">
<xsl:for-each select="articulos/item">
	arts_a_bonificar_<xsl:number value="position()"/> = (purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet {(art_<xsl:number value="position()"/>,1)};
</xsl:for-each>
</xsl:if>

	global publicar_arts_<xsl:value-of select="$index"/> = {};
	global publicar_<xsl:value-of select="$index"/> = {};
<xsl:if test="$eans='uno'">
	global descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;
</xsl:if>

<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	bonifico_arts &lt; por_cada_arts;
	<xsl:for-each select="articulos/item">(\arts_a_bonificar_<xsl:number value="position()"/>\ &gt;= por_cada_arts)<xsl:if test="not(position()=last())"> || </xsl:if></xsl:for-each>;
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
<xsl:for-each select="articulos/item">
	c_<xsl:number value="position()"/> = (&amp;( \arts_a_bonificar_<xsl:number value="position()"/>\ / por_cada_arts) * bonifico_arts);
	if c_<xsl:number value="position()"/> &gt; 0 then
		publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(art_<xsl:number value="position()"/>, c_<xsl:number value="position()"/> * ${(art_<xsl:number value="position()"/>,1)} * descuento)};
		publicar_arts_<xsl:value-of select="$index"/> = publicar_arts_<xsl:value-of select="$index"/> + {(art_<xsl:number value="position()"/>, c_<xsl:number value="position()"/>)};
	fi;
</xsl:for-each>

	<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + publicar_<xsl:value-of select="$index"/>;
	<xsl:value-of select="$benef"/> = \publicar_<xsl:value-of select="$index"/>\ * <xsl:value-of select="$cash2benef"/>;

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
	// Parametros correspondientes a la promo m_x_n_articulos_iguales_multiple_ticket_<xsl:value-of select="$cod_promo"/>
<xsl:if test="$eans='uno'">
	extern descarga_<xsl:value-of select="$index"/>;
</xsl:if>
	extern publicar_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;
	// -------------------------------- promo m_x_n_articulos_iguales_multiple_ticket_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo m_x_n_articulos_iguales_multiple_ticket_<xsl:value-of select="$cod_promo"/>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);
<xsl:if test="$eans='varios'">
	for (a,k) in publicar_<xsl:value-of select="$index"/> do
		mc = {(a, publicar_arts_<xsl:value-of select="$index"/>.a)};
		credit(a, k, mc);
		rec(artsBeneficiary, mc);
		rec(creditBenefit, k);
	od;
</xsl:if>
<xsl:if test="$eans='uno'">
	credit(descarga_<xsl:value-of select="$index"/>,\publicar_<xsl:value-of select="$index"/>\,publicar_arts_<xsl:value-of select="$index"/>);
	for (a,k) in publicar_<xsl:value-of select="$index"/> do
		mc = {(a, publicar_arts_<xsl:value-of select="$index"/>.a)};
		rec(artsBeneficiary, mc);
		rec(creditBenefit, k);
	od;
</xsl:if>
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



	// ------------------------------------------ promo m_x_n_articulos_iguales_multiple_ticket_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>




<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>


	</xsl:template>

</xsl:stylesheet>