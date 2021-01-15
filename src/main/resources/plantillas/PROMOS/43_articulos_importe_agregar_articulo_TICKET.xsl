<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Artículo descuento en ticket
	Autor: Elio Mauro Carreras
	Fecha: 15/08/2008
  **********************************************************************-->

<xsl:template match="promo[@promotype='articulos_importe_agregar_articulo_tkt']">

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

	<xsl:variable name="promo_name">Promoción: Artículo descuento en ticket</xsl:variable>
	<xsl:variable name="promo_version">1.8.10</xsl:variable>
	<xsl:variable name="promo_date">20/08/08</xsl:variable>
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

	<xsl:variable name="arts_disparantes"><xsl:apply-templates select="arts_disparantes"/></xsl:variable>
	<xsl:variable name="arts_benef"><xsl:apply-templates select="arts_benef"/></xsl:variable>
	<xsl:variable name="precios">{<xsl:for-each select="arts_benef/item">(<xsl:apply-templates select="element"/>,<xsl:apply-templates select="precio_fijo_unitario"/><xsl:if test="not(position()=last())">), </xsl:if></xsl:for-each>)}</xsl:variable>

	<xsl:variable name="cantidad_limite"><xsl:apply-templates select="cantidad_limite"/></xsl:variable>
	<xsl:variable name="monto_min_dis"><xsl:apply-templates select="monto_min_dis"/></xsl:variable>

	<xsl:variable name="tipo_descuento"><xsl:apply-templates select="tipo_descuento"/></xsl:variable>
	<xsl:variable name="descuento"><xsl:apply-templates select="descuento"/></xsl:variable>

	<xsl:variable name="eans"><xsl:apply-templates select="nuevo_eans"/></xsl:variable>
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

//********** Promoción Invel: Artículos Importe Agregar Articulo en Ticket *************

Promotion <xsl:value-of select="$eval"/> articulos_importe_agregar_articulo_tkt_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
	requireAny<xsl:value-of select="$arts_disparantes"/>;
	requireAny<xsl:value-of select="$arts_benef"/>;
<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>



Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->
	cantidad_limite = <xsl:value-of select="$cantidad_limite"/>; // maximo de grupos a beneficiar
	monto_min_dis = <xsl:value-of select="$monto_min_dis"/>; // monto minimo en arts. disparantes
	descuento = <xsl:value-of select="$descuento"/>;

	arts_disparantes = <xsl:value-of select="$arts_disparantes"/>;
	arts_benef = <xsl:value-of select="$arts_benef"/>;

<xsl:if test="$ignora_exclusion_arts='true'">
	comprados = (buyed - nopromotion) meet arts_disparantes;
	arts_a_bonificar = (buyed - nopromotion) meet arts_benef;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	comprados = purchase meet arts_disparantes;
	arts_a_bonificar = purchase meet arts_benef;
</xsl:if>

	pr_comprados = (%(100 * $comprados) / 100);

//	global str_ahorro_<xsl:value-of select="$index"/> = "";
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
	pr_comprados &gt;= monto_min_dis;
	|arts_a_bonificar| &gt;= 1;
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	c = (&amp;(pr_comprados / monto_min_dis) min cantidad_limite);
	for (a,k) in arts_benef do
		cantidad = (c * k) min arts_a_bonificar.a;
		if (cantidad &gt; 0)then
			publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a, descuento * cantidad * ${(a,1)})};
			publicar_arts_<xsl:value-of select="$index"/> = publicar_arts_<xsl:value-of select="$index"/> + {(a,cantidad)};
		fi;
	od;

	<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + publicar_<xsl:value-of select="$index"/>;
	<xsl:value-of select="$benef"/> = \publicar_<xsl:value-of select="$index"/>\ * <xsl:value-of select="$cash2benef"/>;

	<xsl:if test="$excluir='true'">
		<xsl:value-of select="$excluded"/> = <xsl:value-of select="$excluded"/> + publicar_arts_<xsl:value-of select="$index"/>;
			// se excluyen los artículos bonificados para que no participen
			// de nuevas promociones.
	</xsl:if>


//	str_ahorro_<xsl:value-of select="$index"/> = ("REBAJA:   "++(descuento * 100)++"%   SOBRE   "++($publicar_arts_<xsl:value-of select="$index"/>)++"  =  "++ (\publicar_<xsl:value-of select="$index"/>\));
	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": LATENTE");

<xsl:if test="$msj_monitor_latente='true'">
	print(<xsl:for-each select="mensajes/latente/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>

<!-- >>>>>>>>>>>>>> -->

<xsl:value-of select="$beneficios"/>
</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo articulos_importe_agregar_articulo_tkt_<xsl:value-of select="$cod_promo"/>
<xsl:if test="$eans='uno'">
	extern descarga_<xsl:value-of select="$index"/>;
</xsl:if>
//	extern str_ahorro_<xsl:value-of select="$index"/>;
	extern publicar_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;
	// -------------------------------- promo articulos_importe_agregar_articulo_tkt_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo articulos_importe_agregar_articulo_tkt_<xsl:value-of select="$cod_promo"/>

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

//	dinero_ahorrado = dinero_ahorrado + \publicar_<xsl:value-of select="$index"/>\;
//	blog(body, str_ahorro_<xsl:value-of select="$index"/>);

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>




	// ------------------------------------------ promo articulos_importe_agregar_articulo_tkt_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>




</xsl:if> <!--//////// fin descuento porcentual /////////-->

<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->










<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<xsl:if test="$tipo_descuento='precio fijo'">


<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Artículos Importe Agregar Articulo en Ticket *************

Promotion <xsl:value-of select="$eval"/> articulos_importe_agregar_articulo_tkt_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
	requireAny<xsl:value-of select="$arts_disparantes"/>;
	requireAny<xsl:value-of select="$arts_benef"/>;
<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>



Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->
	cantidad_limite = <xsl:value-of select="$cantidad_limite"/>; // maximo de grupos a beneficiar
	monto_min_dis = <xsl:value-of select="$monto_min_dis"/>; // monto minimo en arts. disparantes

	arts_disparantes = <xsl:value-of select="$arts_disparantes"/>;
	arts_benef = <xsl:value-of select="$arts_benef"/>;
	precios = <xsl:value-of select="$precios"/>;

<xsl:if test="$ignora_exclusion_arts='true'">
	comprados = (buyed - nopromotion) meet arts_disparantes;
	arts_a_bonificar = (buyed - nopromotion) meet arts_benef;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	comprados = purchase meet arts_disparantes;
	arts_a_bonificar = purchase meet arts_benef;
</xsl:if>

	pr_comprados = (%(100 * $comprados) / 100);

//	global str_ahorro_<xsl:value-of select="$index"/> = "";
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
	pr_comprados &gt;= monto_min_dis;
	|arts_a_bonificar| &gt;= 1;
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	c = (&amp;(pr_comprados / monto_min_dis) min cantidad_limite);
	for (a,k) in arts_benef do
		cantidad = (c * k) min arts_a_bonificar.a;
		descontar = ${(a,1)} - precios.a;
		if (cantidad &gt; 0 &amp;&amp; descontar &gt; 0)then
			publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a, cantidad * descontar)};
			publicar_arts_<xsl:value-of select="$index"/> = publicar_arts_<xsl:value-of select="$index"/> + {(a,cantidad)};
		fi;
	od;

	<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + publicar_<xsl:value-of select="$index"/>;
	<xsl:value-of select="$benef"/> = \publicar_<xsl:value-of select="$index"/>\ * <xsl:value-of select="$cash2benef"/>;

	<xsl:if test="$excluir='true'">
		<xsl:value-of select="$excluded"/> = <xsl:value-of select="$excluded"/> + publicar_arts_<xsl:value-of select="$index"/>;
			// se excluyen los artículos bonificados para que no participen
			// de nuevas promociones.
	</xsl:if>

//	str_ahorro_<xsl:value-of select="$index"/> = ("REBAJA:   descuento de "++ \publicar_<xsl:value-of select="$index"/>\ ++ "   SOBRE   "++($publicar_arts_<xsl:value-of select="$index"/>)++"  =  "++ (\publicar_<xsl:value-of select="$index"/>\));
	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": LATENTE");

<xsl:if test="$msj_monitor_latente='true'">
	print(<xsl:for-each select="mensajes/latente/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>

<!-- >>>>>>>>>>>>>> -->

<xsl:value-of select="$beneficios"/>
</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo articulos_importe_agregar_articulo_tkt_<xsl:value-of select="$cod_promo"/>
<xsl:if test="$eans='uno'">
	extern descarga_<xsl:value-of select="$index"/>;
</xsl:if>
//	extern str_ahorro_<xsl:value-of select="$index"/>;
	extern publicar_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;
	// -------------------------------- promo articulos_importe_agregar_articulo_tkt_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo articulos_importe_agregar_articulo_tkt_<xsl:value-of select="$cod_promo"/>

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

//	dinero_ahorrado = dinero_ahorrado + \publicar_<xsl:value-of select="$index"/>\;
//	blog(body, str_ahorro_<xsl:value-of select="$index"/>);

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>




	// ------------------------------------------ promo articulos_importe_agregar_articulo_tkt_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>




</xsl:if> <!--//////// fin precio fijo /////////-->

<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->




<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>





	</xsl:template>

</xsl:stylesheet>
