<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Grupo parcial agregar artículo en ticket
	Autor: Elio Mauro Carreras
	Fecha: 15/08/2008
  **********************************************************************-->

<xsl:template match="promo[@promotype='grupo_parcial_descuento_ticket']">

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

	<xsl:variable name="promo_name">Promoción: Grupo parcial agregar artículo en ticket</xsl:variable>
	<xsl:variable name="promo_version">1.9.0</xsl:variable>
		<xsl:variable name="promo_date">13/03/09</xsl:variable>
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

	<xsl:variable name="tipo_beneficio"><xsl:apply-templates select="tipo_beneficio"/></xsl:variable>
	<xsl:variable name="descuento"><xsl:apply-templates select="descuento"/></xsl:variable>

	<xsl:variable name="cantidad_limite"><xsl:apply-templates select="cantidad_limite"/></xsl:variable>
	<xsl:variable name="cantidad_comprar"><xsl:apply-templates select="cantidad_comprar"/></xsl:variable>

	<xsl:variable name="comprar">{<xsl:for-each select="comprar/item">(<xsl:apply-templates select="element"/>,1)<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>}</xsl:variable>
<!--	<xsl:variable name="entregar"><xsl:apply-templates select="entregar"/></xsl:variable> -->
	<xsl:variable name="precios">{<xsl:for-each select="entregar/item">(<xsl:apply-templates select="element"/>,<xsl:apply-templates select="precio_fijo_unitario"/><xsl:if test="not(position()=last())">), </xsl:if></xsl:for-each>)}</xsl:variable>

	<xsl:variable name="articulosprevios"><xsl:apply-templates select="previos/articulosprevios"/></xsl:variable>
	<xsl:variable name="deptoprevio"><xsl:apply-templates select="previos/deptoprevio"/></xsl:variable>

	<xsl:variable name="msj_monitor_latente"><xsl:apply-templates select="mensajes/msj_monitor_latente"/></xsl:variable>
	<xsl:variable name="msj_monitor_activa"><xsl:apply-templates select="mensajes/msj_monitor_activa"/></xsl:variable>
	<xsl:variable name="msj_ticket"><xsl:apply-templates select="mensajes/msj_ticket"/></xsl:variable>
	<xsl:variable name="msj_type"><xsl:apply-templates select="mensajes/type"/></xsl:variable>
	<xsl:variable name="descarga"><xsl:apply-templates select="descarga"/></xsl:variable>
<!-- >>>>>>>>>>>>>> -->




<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<xsl:if test="$tipo_beneficio='porcentual'">


<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Grupo parcial agregar artículo en ticket *************

Promotion <xsl:value-of select="$eval"/> grupo_parcial_descuento_ticket_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
	requireAny <xsl:value-of select="$comprar"/>;
<!-- 	requireAny <xsl:value-of select="$entregar"/>; -->
<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>


Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->

	cantidad_limite = <xsl:value-of select="$cantidad_limite"/>;
	descuento = <xsl:value-of select="$descuento"/>;

	cantidad_comprar = <xsl:value-of select="$cantidad_comprar"/>;

	comprar = <xsl:value-of select="$comprar"/>;
<!--	entregar = <xsl:value-of select="$entregar"/>;-->

<xsl:if test="$ignora_exclusion_arts='true'">
	comprados = (buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet comprar;
<!--	entregando = (buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet entregar; -->
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	comprados = (purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet comprar;
<!--	entregando = (purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet entregar; -->
</xsl:if>


	global publicar_<xsl:value-of select="$index"/> = {};
	global publicar_arts_<xsl:value-of select="$index"/> = {};
<!-- >>>>>>>>>>>>>> -->
     global descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;

<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	\comprados\ &gt;= cantidad_comprar;
<!-- >>>>>>>>>>>>>> -->

Benefits
<!-- <<<<<<<<<<<<<< -->
    cantidad = 0;
	diferencia = 0;
	<!-- Aca en c sabemos cual es el limite si la cantidad comprada o ellimite maximo
	c = (&amp;(\comprados\ / cantidad_comprar) min cantidad_limite); -->
	limite = cantidad_limite;
	for (a,k) in comprados do
			<!--bolson_a = comprados.a; -->
			bolson_a = k;
			cantidad = cantidad + k;
<!-- Acabamos de superar el limite debemos restar los que nos sobra 	-->
			if (cantidad &gt; limite)then
			    diferencia = cantidad - limite;
				diferencia = k - diferencia ;
				<!-- Esta linea es el precio de 1 articulo  y abajo a ese precio lo multiplica por la cantidad verdadera 	
				descontar = ${(a,1)} ;
				publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a, cantidad * descontar)};
				-->
				publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a,${(a,1 )} * diferencia * descuento * &amp;(k/bolson_a))};
				publicar_arts_<xsl:value-of select="$index"/> = publicar_arts_<xsl:value-of select="$index"/> + {(a, diferencia * &amp;(k/bolson_a))};
				skip;
			else	
				publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a,${(a,bolson_a)} * descuento * &amp;(k/bolson_a))};
				publicar_arts_<xsl:value-of select="$index"/> = publicar_arts_<xsl:value-of select="$index"/> + {(a, bolson_a * &amp;(k/bolson_a))};
			fi;	
			
		
			
			
	od;


	<xsl:value-of select="$benef"/> = \publicar_<xsl:value-of select="$index"/>\ * <xsl:value-of select="$cash2benef"/>;

	<xsl:if test="$excluir='true'">
		<xsl:value-of select="$excluded"/> = <xsl:value-of select="$excluded"/> + publicar_arts_<xsl:value-of select="$index"/>;
			// se excluyen los artículos bonificados para que no participen
			// de nuevas promociones.
	</xsl:if>
	imprimir_perfil_<xsl:value-of select="$index"/> = cantidad;
	blog(file, "canditdad promo: " ++ imprimir_perfil_<xsl:value-of select="$index"/>);
	imprimir_perfil1_<xsl:value-of select="$index"/> = diferencia;
	blog(file, "diferencia promo: " ++ imprimir_perfil1_<xsl:value-of select="$index"/>);
	
	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": LATENTE");
	

<xsl:if test="$msj_monitor_latente='true'">
	print(<xsl:for-each select="mensajes/latente/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>

<!-- >>>>>>>>>>>>>> -->

<xsl:value-of select="$beneficios"/>
</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo grupo_parcial_descuento_ticket_<xsl:value-of select="$cod_promo"/>
	extern descarga_<xsl:value-of select="$index"/>;
	extern publicar_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;
	// -------------------------------- promo grupo_parcial_descuento_ticket_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo grupo_parcial_descuento_ticket_<xsl:value-of select="$cod_promo"/>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);
	credit(descarga_<xsl:value-of select="$index"/>,\publicar_<xsl:value-of select="$index"/>\,publicar_arts_<xsl:value-of select="$index"/>);
	for (a,k) in publicar_<xsl:value-of select="$index"/> do
		mc = {(a, publicar_arts_<xsl:value-of select="$index"/>.a)};

		rec(artsBeneficiary, mc);
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


	// ------------------------------------------ promo grupo_parcial_descuento_ticket_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>




</xsl:if> <!--//////// fin descuento porcentual /////////-->

<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->







<!--////////////////////comienzo descuento precio fijo NO ESTA Y NO ANDA!!!!!!////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<xsl:if test="$tipo_beneficio='precio fijo'">


<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Grupo parcial agregar artículo en ticket *************

Promotion <xsl:value-of select="$eval"/> grupo_parcial_descuento_ticket_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
	requireAny <xsl:value-of select="$comprar"/>;
<!--	requireAny <xsl:value-of select="$entregar"/>; -->
<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>


Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->

	cantidad_limite = <xsl:value-of select="$cantidad_limite"/>;
	cantidad_comprar = <xsl:value-of select="$cantidad_comprar"/>;

	comprar = <xsl:value-of select="$comprar"/>;
<!--	entregar = <xsl:value-of select="$entregar"/>; -->
	precios = <xsl:value-of select="$precios"/>;


<xsl:if test="$ignora_exclusion_arts='true'">
	comprados = (buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet comprar;
<!--	entregando = (buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet entregar; -->
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	comprados = (purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet comprar;
<!--	entregando = (purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet entregar; -->
</xsl:if>


	global publicar_<xsl:value-of select="$index"/> = {};
	global publicar_arts_<xsl:value-of select="$index"/> = {};
	global descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;
<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;
	


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	\comprados\ &gt;= cantidad_comprar;
<!-- >>>>>>>>>>>>>> -->

Benefits
<!-- <<<<<<<<<<<<<< -->

	cantidad = 1;
	c = (&amp;(\comprados\ / cantidad_comprar) min cantidad_limite);
	for (a,k) in comprados do
		descontar = ${(a,1)} - precios.a;
		publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a, cantidad * descontar)};
		publicar_arts_<xsl:value-of select="$index"/> = publicar_arts_<xsl:value-of select="$index"/> + {(a,cantidad)};
	od;


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
	// Parametros correspondientes a la promo grupo_parcial_descuento_ticket_<xsl:value-of select="$cod_promo"/>
	extern descarga_<xsl:value-of select="$index"/>;
	extern publicar_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;
	// -------------------------------- promo grupo_parcial_descuento_ticket_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la grupo_parcial_descuento_ticket_<xsl:value-of select="$cod_promo"/>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);
	credit(descarga_<xsl:value-of select="$index"/>,\publicar_<xsl:value-of select="$index"/>\,publicar_arts_<xsl:value-of select="$index"/>);
	for (a,k) in publicar_<xsl:value-of select="$index"/> do
		mc = {(a, publicar_arts_<xsl:value-of select="$index"/>.a)};
<!--		credit(a, k, mc); -->
		rec(artsBeneficiary, mc);
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


	// ------------------------------------------ promo grupo_parcial_descuento_ticket_<xsl:value-of select="$cod_promo"/>
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
