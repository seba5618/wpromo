<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	PromoPerfil descuento al ticket
	Autor: Elio Mauro Carreras
	Fecha: 12/03/2007
  **********************************************************************-->

<xsl:template match="promo[@promotype='perfil_descuento_al_ticket']">

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

	<xsl:variable name="promo_name">PromoPerfil descuento al ticket</xsl:variable>
	<xsl:variable name="promo_version">1.1.1</xsl:variable>
	<xsl:variable name="promo_date">22/07/09</xsl:variable>
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
	<xsl:variable name="excluir_articulos_precio_oferta"><xsl:apply-templates select="excluir_articulos_precio_oferta"/></xsl:variable>

<xsl:variable name="perf_desc"><xsl:for-each select="perfiles/perfil">
	perfil_<xsl:number value="position()"/> = <xsl:apply-templates select="codigo"/>;
	descuento_<xsl:number value="position()"/> = <xsl:apply-templates select="descuento"/>;
	descripcion_<xsl:number value="position()"/> = "<xsl:apply-templates select="descripcion"/>";
</xsl:for-each></xsl:variable>


	<xsl:variable name="limite"><xsl:apply-templates select="limite"></xsl:apply-templates></xsl:variable>
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

//********** Promoci򬟉nvel: Perfil descuento al ticket *************

Promotion <xsl:value-of select="$eval"/> perfil_descuento_al_ticket_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions
////////////////////////
<xsl:apply-templates select="preconditions"/>
////////////////////////
<xsl:value-of select="$condiciones"/>
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

	extern per;

	limite_entrega = <xsl:value-of select="$limite"/>;
		// cantidad m'axima de dinero a otorgar como beneficio.
	
<xsl:value-of select="$perf_desc"/>

<xsl:if test="$ignora_exclusion_arts='true'">
	monto  = $(buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>);
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	monto  = $(purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>);
</xsl:if>

	global imprimir_perfil_<xsl:value-of select="$index"/> = "";
	global publicar_<xsl:value-of select="$index"/> = {};
	global publicar_arts_<xsl:value-of select="$index"/> = {};
	global descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;
	global perfil_beneficiado_<xsl:value-of select="$index"/> = 0;


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	monto &gt; 0;

	<xsl:for-each select="perfiles/perfil">per ==	perfil_<xsl:number value="position()"/><xsl:if test="not(position()=last())"> || </xsl:if></xsl:for-each>;


<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
<xsl:for-each select="perfiles/perfil">
	if(per == perfil_<xsl:number value="position()"/>)then
		publicar_<xsl:value-of select="$index"/> = {(descarga_<xsl:value-of select="$index"/>, ((monto * descuento_<xsl:number value="position()"/>) min limite_entrega))};
		imprimir_perfil_<xsl:value-of select="$index"/> = descripcion_<xsl:number value="position()"/>;
		perfil_beneficiado_<xsl:value-of select="$index"/> = per;
	fi;
</xsl:for-each>
<xsl:if test="$ignora_exclusion_arts='true'">
	publicar_arts_<xsl:value-of select="$index"/> = buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	publicar_arts_<xsl:value-of select="$index"/> = purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>;
</xsl:if>

<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + publicar_<xsl:value-of select="$index"/>;
<xsl:value-of select="$benef"/> = \publicar_<xsl:value-of select="$index"/>\ * <xsl:value-of select="$cash2benef"/>;


<xsl:if test="$excluir='true'">
	<xsl:value-of select="$excluded"/> = <xsl:value-of select="$excluded"/> + publicar_arts_<xsl:value-of select="$index"/>;
		// se excluyen los art좵los bonificados para que no participen
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
	// Parametros correspondientes a la promo perfil_descuento_al_ticket_<xsl:value-of select="$cod_promo"/>
	extern publicar_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;
	extern descarga_<xsl:value-of select="$index"/>;
	extern imprimir_perfil_<xsl:value-of select="$index"/>;
	extern perfil_beneficiado_<xsl:value-of select="$index"/>;
	// -------------------------------- promo perfil_descuento_al_ticket_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo perfil_descuento_al_ticket_<xsl:value-of select="$cod_promo"/>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

	credit(descarga_<xsl:value-of select="$index"/>,\publicar_<xsl:value-of select="$index"/>\,publicar_arts_<xsl:value-of select="$index"/>);
	blog(inticket, "Perfil: " ++ imprimir_perfil_<xsl:value-of select="$index"/>);

	for (a,k) in publicar_<xsl:value-of select="$index"/> do
		mc = {(a, publicar_arts_<xsl:value-of select="$index"/>.a)};
//		rec(artsBeneficiary, mc);
		rec(perfil, perfil_beneficiado_<xsl:value-of select="$index"/>);
		rec(creditBenefit, k);
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



	// ------------------------------------------ promo perfil_descuento_al_ticket_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>






<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versi򬸠<xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>


	</xsl:template>

</xsl:stylesheet>
