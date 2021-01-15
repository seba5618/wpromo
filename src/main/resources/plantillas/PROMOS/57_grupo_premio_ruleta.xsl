<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Grupo Premio Ruleta 
	Autor: Elio Mauro Carreras
	Fecha: 26/08/2008
  **********************************************************************-->

<xsl:template match="promo[@promotype='grupo_premio_ruleta']">

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

	<xsl:variable name="promo_name">Promoción: Grupo Premio Ruleta</xsl:variable>
	<xsl:variable name="promo_version">1.1.0</xsl:variable>
	<xsl:variable name="promo_date">19/03/09</xsl:variable>
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

	<xsl:variable name="bolson"><xsl:apply-templates select="bolson"/></xsl:variable>
	<xsl:variable name="premios"><xsl:apply-templates select="premios"/></xsl:variable>
	<xsl:variable name="num_articulos_comprar"><xsl:apply-templates select="num_articulos_comprar"/></xsl:variable>

	<xsl:variable name="descuento_al_total_bool"><xsl:apply-templates select="descuento_al_total_bool"/></xsl:variable>
	<xsl:variable name="descuento_al_total"><xsl:apply-templates select="descuento_al_total"/></xsl:variable>
	<xsl:variable name="descarga"><xsl:apply-templates select="descarga"/></xsl:variable>

	<xsl:variable name="descuento_al_bolson_bool"><xsl:apply-templates select="descuento_al_bolson_bool"/></xsl:variable>
	<xsl:variable name="descuento_al_bolson"><xsl:apply-templates select="descuento_al_bolson"/></xsl:variable>

	<xsl:variable name="usar_min_arts_activa"><xsl:apply-templates select="usar_min_arts_activa"/></xsl:variable>
	<xsl:variable name="min_arts_activa"><xsl:apply-templates select="min_arts_activa"/></xsl:variable>

	<xsl:variable name="articulosprevios"><xsl:apply-templates select="previos/articulosprevios"/></xsl:variable>
	<xsl:variable name="deptoprevio"><xsl:apply-templates select="previos/deptoprevio"/></xsl:variable>

	<xsl:variable name="msj_monitor_latente"><xsl:apply-templates select="mensajes/msj_monitor_latente"/></xsl:variable>
	<xsl:variable name="msj_monitor_activa"><xsl:apply-templates select="mensajes/msj_monitor_activa"/></xsl:variable>
	<xsl:variable name="msj_ticket"><xsl:apply-templates select="mensajes/msj_ticket"/></xsl:variable>
	<xsl:variable name="msj_type"><xsl:apply-templates select="mensajes/type"/></xsl:variable>
<!-- >>>>>>>>>>>>>> -->


<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Grupo Premio Ruleta *************

Promotion <xsl:value-of select="$eval"/> grupo_premio_ruleta_<xsl:value-of select="$cod_promo"/>

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

<!-- <<<<<<<<<<<<<< -->
	d_total_bool = false;
	d_bolson_bool = false;

	num_articulos = <xsl:value-of select="$num_articulos_comprar"/>;

	bolson = <xsl:value-of select="$bolson"/>;
	premios = <xsl:value-of select="$premios"/>;

	num_premios_arts = |premios|;
	num_premios = num_premios_arts;

<xsl:for-each select="videos/video">
	<xsl:if test="position()=last()">
	num_videos = <xsl:value-of select="position()"/>;
	</xsl:if>
</xsl:for-each>

<xsl:if test="$descuento_al_total_bool='true'">
	descuento_al_total = <xsl:value-of select="$descuento_al_total"/>;
	num_premios = num_premios + 1;
	d_total_bool = true;
	global descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;
</xsl:if>
<xsl:if test="$descuento_al_bolson_bool='true'">
	descuento_al_bolson = <xsl:value-of select="$descuento_al_bolson"/>;
	num_premios = num_premios + 1;
	d_bolson_bool = true;
</xsl:if>

<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = (buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet bolson;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = (purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet bolson;
</xsl:if>

	global publicar_arts_<xsl:value-of select="$index"/> = {};
	global publicar_<xsl:value-of select="$index"/> = {};
	global distribuir_<xsl:value-of select="$index"/> = false;
<xsl:if test="$descuento_al_total_bool='true'">
	global descuento_total_<xsl:value-of select="$index"/> = false;
</xsl:if>

	global video_name_<xsl:value-of select="$index"/> = "";
<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	\arts_a_bonificar\ &gt;= num_articulos;
	num_premios &gt;= 1;

<!-- monto minimo de articulos que activan la promocion -->
<xsl:if test="$usar_min_arts_activa='true'">
// monto minimo de articulos que activan la promocion
	(%(100 * $arts_a_bonificar) / 100) &gt;= <xsl:value-of select="$min_arts_activa"/>
</xsl:if>
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->

	random_seed = numRNV( nro_evento ) + numRNV( nro_caja ) + numRNV( nro_z );
	m = 46337;
	a = 127;
	
	x1 = (a * random_seed) mod m;
	x2 = (a * x1) mod m;
	x3 = (a * x2) mod m;
	x4 = (a * x3) mod m;
	x5 = (a * x4) mod m;
	x6 = (a * x5) mod m;
	x7 = (a * x6) mod m;

	sorteo = &amp;((x7 / m) * num_premios) + 1;
	sorteo_video = &amp;((x7 / m) * num_videos) + 1;

<xsl:if test="$descuento_al_total_bool='true'">
	if(sorteo == num_premios_arts + 1 &amp;&amp; d_total_bool)then
		publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(descarga_<xsl:value-of select="$index"/>, $(purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>)* descuento_al_total)};
		publicar_arts_<xsl:value-of select="$index"/> = purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>;
		descuento_total_<xsl:value-of select="$index"/> = true;
	fi;
</xsl:if>

<xsl:if test="$descuento_al_bolson_bool='true'">
	if((sorteo == num_premios_arts + 2) || (sorteo == num_premios_arts + 1 &amp;&amp; !d_total_bool))then
		for(a,k) in arts_a_bonificar do
			publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a, ${(a,k)} * descuento_al_bolson)};
		od;
		publicar_arts_<xsl:value-of select="$index"/> = arts_a_bonificar;
	fi;
</xsl:if>
	
	if(1 &lt;= sorteo &amp;&amp; sorteo &lt;= num_premios_arts)then
		conteo = 1;
		for(a,k) in premios do
			if(conteo == sorteo)then
				publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a, ${(a,k)})};
				publicar_arts_<xsl:value-of select="$index"/> = {(a,k)};
				distribuir_<xsl:value-of select="$index"/> = true;
			fi;
			conteo = conteo + 1;
		od;
	fi;


	<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + publicar_<xsl:value-of select="$index"/>;
	<xsl:value-of select="$benef"/> = \publicar_<xsl:value-of select="$index"/>\ * <xsl:value-of select="$cash2benef"/>;

	<xsl:if test="$excluir='true'">
		<xsl:value-of select="$excluded"/> = <xsl:value-of select="$excluded"/> + publicar_arts_<xsl:value-of select="$index"/>;
			// se excluyen los artículos bonificados para que no participen
			// de nuevas promociones.
	</xsl:if>


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

<xsl:for-each select="videos/video">
	if(sorteo_video == <xsl:value-of select="position()"/>)then
		video_name_<xsl:value-of select="$index"/> = "<xsl:apply-templates select="."/>";
	fi;
</xsl:for-each>

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": LATENTE");

<xsl:if test="$msj_monitor_latente='true'">
	print(<xsl:for-each select="mensajes/latente/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>

<!-- >>>>>>>>>>>>>> -->

<xsl:value-of select="$beneficios"/>
</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo grupo_premio_ruleta_<xsl:value-of select="$cod_promo"/>
	extern publicar_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;
	extern distribuir_<xsl:value-of select="$index"/>;
<xsl:if test="$descuento_al_total_bool='true'">
	extern descuento_total_<xsl:value-of select="$index"/>;
	extern descarga_<xsl:value-of select="$index"/>;
</xsl:if>

	extern video_name_<xsl:value-of select="$index"/>;


	// -------------------------------- promo grupo_premio_ruleta_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo grupo_premio_ruleta_<xsl:value-of select="$cod_promo"/>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

<xsl:if test="$descuento_al_total_bool='true'">
	if(descuento_total_<xsl:value-of select="$index"/>)then
		monto = \publicar_<xsl:value-of select="$index"/>\;
		credit(descarga_<xsl:value-of select="$index"/>, monto, publicar_arts_<xsl:value-of select="$index"/>);
    rec(artsBeneficiary, publicar_arts_<xsl:value-of select="$index"/>);
    rec(creditBenefit, monto);
	else
		for (a,k) in publicar_<xsl:value-of select="$index"/> do
			cant_a = publicar_arts_<xsl:value-of select="$index"/>.a;
			mc = {(a, cant_a)};

			if(distribuir_<xsl:value-of select="$index"/>)then
     		distribute(a, cant_a, 0);
     		credit(a, k, mc);
     		rec(artsBeneficiary, mc);
     		rec(creditBenefit, k);
      else
       	credit(a, k, mc);
       	rec(artsBeneficiary, mc);
       	rec(creditBenefit, k);
			fi;
		od;
	fi;
</xsl:if>
<xsl:if test="$descuento_al_total_bool='false'">
	for (a,k) in publicar_<xsl:value-of select="$index"/> do

		cant_a = publicar_arts_<xsl:value-of select="$index"/>.a;
		mc = {(a, cant_a)};

		if(distribuir_<xsl:value-of select="$index"/>)then
     	distribute(a, cant_a, 0);
     	credit(a, k, mc);
     	rec(artsBeneficiary, mc);
     	rec(creditBenefit, k);
		else
     	credit(a, k, mc);
     	rec(artsBeneficiary, mc);
     	rec(creditBenefit, k);
		fi;
	od;
</xsl:if>

	eproc (ivideo, "file="++video_name_<xsl:value-of select="$index"/>);

<xsl:if test="preconditions/bool_perfil='true'">
	rec(perfil, per);
</xsl:if>

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>




	// ------------------------------------------ promo grupo_premio_ruleta_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>





	</xsl:template>

</xsl:stylesheet>
