﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Departamento descuento en ticket
	Autor: Elio Mauro Carreras
	Fecha: 12/03/2007
  **********************************************************************-->

<xsl:template match="promo[@promotype='depto_descuento_tkt']">

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

	<xsl:variable name="promo_name">Promoción: Departamento descuento en ticket</xsl:variable>
	<xsl:variable name="promo_version">1.8.11</xsl:variable>
	<xsl:variable name="promo_date">24/04/08</xsl:variable>
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

	<xsl:variable name="tipo_descuento"><xsl:apply-templates select="tipo_descuento"/></xsl:variable>
	<xsl:variable name="descuento"><xsl:apply-templates select="descuento"/></xsl:variable>
	<xsl:variable name="por_cada"><xsl:apply-templates select="por_cada"/></xsl:variable>
	<xsl:variable name="descuento_fijo"><xsl:apply-templates select="descuento_fijo"/></xsl:variable>

	<xsl:variable name="benef_anteriores"><xsl:apply-templates select="benef_anteriores"/></xsl:variable>
	<xsl:variable name="deptos"><xsl:apply-templates select="deptos"/></xsl:variable>

	<xsl:variable name="usar_min_arts_activa"><xsl:apply-templates select="usar_min_arts_activa"/></xsl:variable>
	<xsl:variable name="min_arts_activa"><xsl:apply-templates select="min_arts_activa"/></xsl:variable>

	<xsl:variable name="eans"><xsl:apply-templates select="eans"/></xsl:variable>
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
<xsl:if test="$tipo_descuento='porcentual'">


<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Departamento Descuento Ticket *************

Promotion <xsl:value-of select="$eval"/> departamento_descuento_ticket_<xsl:value-of select="$cod_promo"/>

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
	descuento = <xsl:value-of select="$descuento"/>;
<xsl:if test="$eans='uno'">
	global descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;

	deptos = <xsl:value-of select="$deptos"/>;
<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = (buyed - nopromotion) meet 0.001 * deptos;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = purchase meet 0.001 * deptos;
</xsl:if>
</xsl:if>

<xsl:if test="$eans='varios'">
<xsl:for-each select="deptos/d/descarga">
	desc_<xsl:number value="position()"/> = <xsl:apply-templates select="."/>;
	global pub_<xsl:number value="position()"/> = {};
	global arts_<xsl:number value="position()"/> = {};
</xsl:for-each>
<xsl:text>
</xsl:text>
<xsl:if test="$ignora_exclusion_arts='true'">
<xsl:for-each select="deptos/d/depto">
	arts_<xsl:number value="position()"/> = (buyed - nopromotion) meet 0.001 * <xsl:apply-templates select="."/>;</xsl:for-each>
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
<xsl:for-each select="deptos/d/depto">
	arts_<xsl:number value="position()"/> = purchase meet 0.001 * <xsl:apply-templates select="."/>;</xsl:for-each>
</xsl:if>
	arts_a_bonificar = <xsl:for-each select="deptos/d/depto">arts_<xsl:number value="position()"/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>;
</xsl:if>

	global publicar_arts_<xsl:value-of select="$index"/> = {};
	global publicar_<xsl:value-of select="$index"/> = {};


<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


<xsl:if test="$benef_anteriores='true'">
<xsl:if test="$eans='uno'">
	monto  = (%(100 * ($arts_a_bonificar - \<xsl:value-of select="$beneficiados"/> meet 0.001 * deptos\)) / 100);
</xsl:if>
<xsl:if test="$eans='varios'">
	monto  = (%(100 * ($arts_a_bonificar - \<xsl:value-of select="$beneficiados"/> meet 0.001 * (<xsl:for-each select="deptos/d/depto"><xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> union </xsl:if></xsl:for-each>)\)) / 100);
</xsl:if>
</xsl:if>

<xsl:if test="$benef_anteriores='false'">
	monto  = (%(100 * $arts_a_bonificar) / 100);
</xsl:if>



Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	monto &gt; 0;

<xsl:if test="$usar_min_arts_activa='true'">
// monto minimo de articulos que activan la promocion
	monto &gt;= <xsl:value-of select="$min_arts_activa"/>
</xsl:if>
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	valor = monto * descuento;
	pr_arts = $arts_a_bonificar;
	for (a,k) in arts_a_bonificar do
		publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a, valor * (${(a,k)} / pr_arts))};
	od;

	publicar_arts_<xsl:value-of select="$index"/> = arts_a_bonificar;
	<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + publicar_<xsl:value-of select="$index"/>;
	<xsl:value-of select="$benef"/> = valor * <xsl:value-of select="$cash2benef"/>;

<xsl:if test="$eans='varios'">
<xsl:for-each select="deptos/d/depto">
	pub_<xsl:number value="position()"/> = pub_<xsl:number value="position()"/> + {(desc_<xsl:number value="position()"/>, $arts_<xsl:number value="position()"/> * descuento)};
</xsl:for-each>
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
	// Parametros correspondientes a la promo departamento_descuento_ticket_<xsl:value-of select="$cod_promo"/>
<xsl:if test="$eans='uno'">
	extern descarga_<xsl:value-of select="$index"/>;
</xsl:if>
<xsl:if test="$eans='varios'">
<xsl:for-each select="deptos/d/descarga">
	extern pub_<xsl:number value="position()"/>;
	extern arts_<xsl:number value="position()"/>;
</xsl:for-each>
</xsl:if>
	extern publicar_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;
	// -------------------------------- promo departamento_descuento_ticket_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo departamento_descuento_ticket_<xsl:value-of select="$cod_promo"/>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

<xsl:if test="$eans='varios'">
<xsl:for-each select="deptos/d/depto">
	for(a,k) in pub_<xsl:number value="position()"/> do
		credit(a,k,arts_<xsl:number value="position()"/>);
		rec(artsBeneficiary, arts_<xsl:number value="position()"/>);
		rec(creditBenefit, k);
		od;
</xsl:for-each>
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



	// ------------------------------------------ promo departamento_descuento_ticket_<xsl:value-of select="$cod_promo"/>
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

//********** Promoción Invel: Departamento Descuento Monto Fijo *************

Promotion <xsl:value-of select="$eval"/> departamento_descuento_ticket_<xsl:value-of select="$cod_promo"/>

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
	por_cada = <xsl:value-of select="$por_cada"/>;
	descuento_fijo = <xsl:value-of select="$descuento_fijo"/>;

<xsl:if test="$eans='uno'">
	global descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;
	deptos = <xsl:value-of select="$deptos"/>;
<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = (buyed - nopromotion) meet 0.001 * deptos;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = purchase meet 0.001 * deptos;
</xsl:if>
</xsl:if>

<xsl:if test="$eans='varios'">
<xsl:for-each select="deptos/d/descarga">
	desc_<xsl:number value="position()"/> = <xsl:apply-templates select="."/>;
	global pub_<xsl:number value="position()"/> = {};
	global arts_<xsl:number value="position()"/> = {};
</xsl:for-each>
<xsl:text>
</xsl:text>
<xsl:if test="$ignora_exclusion_arts='true'">
<xsl:for-each select="deptos/d/depto">
	arts_<xsl:number value="position()"/> = (buyed - nopromotion) meet 0.001 * <xsl:apply-templates select="."/>;</xsl:for-each>
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
<xsl:for-each select="deptos/d/depto">
	arts_<xsl:number value="position()"/> = purchase meet 0.001 * <xsl:apply-templates select="."/>;</xsl:for-each>
</xsl:if>
	arts_a_bonificar = <xsl:for-each select="deptos/d/depto">arts_<xsl:number value="position()"/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>;
</xsl:if>

	global publicar_arts_<xsl:value-of select="$index"/> = {};
	global publicar_<xsl:value-of select="$index"/> = {};

<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;

<xsl:if test="$benef_anteriores='true'">
<xsl:if test="$eans='uno'">
	monto  = (%(100 * ($arts_a_bonificar - \<xsl:value-of select="$beneficiados"/> meet 0.001 * deptos\)) / 100);
</xsl:if>
<xsl:if test="$eans='varios'">
	monto  = (%(100 * ($arts_a_bonificar - \<xsl:value-of select="$beneficiados"/> meet 0.001 * (<xsl:for-each select="deptos/d/depto"><xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> union </xsl:if></xsl:for-each>)\)) / 100);
</xsl:if>
</xsl:if>

<xsl:if test="$benef_anteriores='false'">
	monto  = (%(100 * $arts_a_bonificar) / 100);
</xsl:if>

<xsl:if test="$por_cada='0'">
	por_cada = monto;
</xsl:if>


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	monto &gt;= por_cada;
	por_cada &gt;= descuento_fijo;

<!-- monto minimo de articulos que activan la promocion -->
<xsl:if test="$usar_min_arts_activa='true'">
// monto minimo de articulos que activan la promocion
	monto &gt;= <xsl:value-of select="$min_arts_activa"/>
</xsl:if>
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	valor = (&amp;(monto / por_cada) * descuento_fijo);
	pr_arts = $arts_a_bonificar;
	for (a,k) in arts_a_bonificar do
		publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a, valor * (${(a,k)} / pr_arts))};
	od;

	publicar_arts_<xsl:value-of select="$index"/> = arts_a_bonificar;
	<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + publicar_<xsl:value-of select="$index"/>;
	<xsl:value-of select="$benef"/> = valor * <xsl:value-of select="$cash2benef"/>;

<xsl:if test="$eans='varios'">
<xsl:for-each select="deptos/d/depto">
	pub_<xsl:number value="position()"/> = pub_<xsl:number value="position()"/> + {(desc_<xsl:number value="position()"/>, valor * ($arts_<xsl:number value="position()"/> / pr_arts))};
</xsl:for-each>
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
	// Parametros correspondientes a la promo departamento_descuento_ticket_<xsl:value-of select="$cod_promo"/>
<xsl:if test="$eans='uno'">
	extern descarga_<xsl:value-of select="$index"/>;
</xsl:if>
<xsl:if test="$eans='varios'">
<xsl:for-each select="deptos/d/descarga">
	extern pub_<xsl:number value="position()"/>;
	extern arts_<xsl:number value="position()"/>;
</xsl:for-each>
</xsl:if>
	extern publicar_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;
	// -------------------------------- promo departamento_descuento_ticket_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo departamento_descuento_ticket_<xsl:value-of select="$cod_promo"/>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

<xsl:if test="$eans='varios'">
<xsl:for-each select="deptos/d/depto">
	for(a,k) in pub_<xsl:number value="position()"/> do
		credit(a,k,arts_<xsl:number value="position()"/>);
		rec(artsBeneficiary, arts_<xsl:number value="position()"/>);
		rec(creditBenefit, k);
		od;
</xsl:for-each>
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



	// ------------------------------------------ promo departamento_descuento_ticket_<xsl:value-of select="$cod_promo"/>
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
