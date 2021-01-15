<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Descuento escalonado ticket
	Autor: Marcelo Mancuso
	Fecha: 03/03/2018
  **********************************************************************-->

<xsl:template match="promo[@promotype='descuento_escalonada_ticket']">

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

	<xsl:variable name="promo_name">Promoción: Descuento escalonado en ticket</xsl:variable>
	<xsl:variable name="promo_version">1.2.0</xsl:variable>
	<xsl:variable name="promo_date">31/07/09</xsl:variable>
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

	<xsl:variable name="cantidad_limite"><xsl:apply-templates select="cantidad_limite"/></xsl:variable>
	<xsl:variable name="descuento1"><xsl:apply-templates select="descuento1"/></xsl:variable>
	<xsl:variable name="descuento2"><xsl:apply-templates select="descuento2"/></xsl:variable>
	<xsl:variable name="descuento3"><xsl:apply-templates select="descuento3"/></xsl:variable>
	<xsl:variable name="cantidad1"><xsl:apply-templates select="cantidad1"/></xsl:variable>
	<xsl:variable name="cantidad2"><xsl:apply-templates select="cantidad2"/></xsl:variable>
	<xsl:variable name="cantidad3"><xsl:apply-templates select="cantidad3"/></xsl:variable>
	<xsl:variable name="grupo"><xsl:apply-templates select="grupo"/></xsl:variable>
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

//********** Promoción Invel: Descuento escalonado en ticket *************

Promotion <xsl:value-of select="$eval"/> descuento_escalonada_ticket_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
<!-- >>>>>>>>>>>>>> 
	requireAll <xsl:value-of select="$grupo"/>;-->
	requireAny <xsl:value-of select="$grupo"/>;
<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>


Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->
 	maximo_grupos = <xsl:value-of select="$cantidad_limite"/>; 
	grupo = <xsl:value-of select="$grupo"/>;
		
 	descuento1 = <xsl:value-of select="$descuento1"/> * 100 ; 
	descuento2 = <xsl:value-of select="$descuento2"/> * 100;  
	descuento3 = <xsl:value-of select="$descuento3"/> * 100;  
	cantidad1  = <xsl:value-of select="$cantidad1"/>;  
	cantidad2  = <xsl:value-of select="$cantidad2"/>;  
	cantidad3  = <xsl:value-of select="$cantidad3"/>;  
	
	

<!--	precio_fijo = <xsl:value-of select="$precio_fijo"/>; // precio fijo por grupo -->
	precio_real = $grupo;

<xsl:if test="$ignora_exclusion_arts='true'">
	comprados = (buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet grupo;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	comprados = (purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet grupo;
</xsl:if>


	global publicar_<xsl:value-of select="$index"/> = {};
	global publicar_arts_<xsl:value-of select="$index"/> = {};
<xsl:if test="$eans='uno'">
	global descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;
</xsl:if>

	global imprimir_perfil3_<xsl:value-of select="$index"/> = 1;
	global imprimir_perfil2_<xsl:value-of select="$index"/> = 1;
	global imprimir_perfil1_<xsl:value-of select="$index"/> = 1;
<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;

Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< 
	|comprados| &gt;= |grupo|; -->
	precio_real &gt;= 0;
<!-- >>>>>>>>>>>>>> -->

Benefits

	c = maximo_grupos;
	contador = 0;
	factor = 1;
	ii = 0;
	grupo1 = 0;
	grupo2 = 0;
	grupo3 = 0;
	<!--for (a,k) in comprados dov-->
	for (a,k) in comprados do
	<!--	c = c min &amp;(k / grupo.a);  -->
		contador = comprados.a;
	od;
	
	<!-- <<<<<<<<<<<<<< 
	arts_a_bonificar = comprados meet grupo;
		descuento = c * (precio_real - precio_fijo); 
	-->
	descuento = 0.00;
	<!--descuento1 = 6.00; 
	descuento2 = 7.00; 
	-->
	
	contador = \comprados\;
	factor = \comprados\;
	arts_a_bonificar = |comprados|;
	factor = 1;
	grupo1 = contador div cantidad3;
	if(contador &lt; cantidad3) then
	   grupo1 = 0;
	   grupo2 =1;
	   if(contador == cantidad1) then
			descuento2 = descuento1;
			cantidad2 = cantidad1;
	   fi;
	else
		grupo2 = contador mod cantidad3;
		if( grupo2 == 1) then
			descuento2 = descuento1;
			cantidad2 = cantidad1;
		else
			if( grupo2 == 0) then
				descuento2 = 0;
			else
				if( grupo2 == 2) then
					descuento2 = descuento2;
					grupo2= grupo2 div cantidad2;
				fi;
			fi;
		fi;
	fi;
				
	descuento = ((grupo1 * descuento3 * cantidad3) +  (grupo2 * descuento2 * cantidad2) )* factor;
	imprimir_perfil_<xsl:value-of select="$index"/> = descuento;
	imprimir_perfil1_<xsl:value-of select="$index"/> = factor;
	blog(file, "descuento: " ++ imprimir_perfil_<xsl:value-of select="$index"/>);
	blog(file, "factor: " ++ imprimir_perfil1_<xsl:value-of select="$index"/>);
	
	
	
	for (a,k) in comprados do
		if( ii == 0 ) then
			imprimir_perfil3_<xsl:value-of select="$index"/> = precio_real;
			<!--
			publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a, descuento * (${(a,k)} / precio_real))};-->
			publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a, descuento * 1)};
			publicar_arts_<xsl:value-of select="$index"/> = publicar_arts_<xsl:value-of select="$index"/> + {(a,k)};
		fi;
		ii=ii+1;
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
	// Parametros correspondientes a la promo descuento_escalonada_ticket_<xsl:value-of select="$cod_promo"/>
	extern publicar_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;
<xsl:if test="$eans='uno'">
	extern descarga_<xsl:value-of select="$index"/>;
</xsl:if>

	// -------------------------------- promo descuento_escalonada_ticket_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la descuento_escalonada_ticket_<xsl:value-of select="$cod_promo"/>

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


	// ------------------------------------------ promo descuento_escalonada_ticket_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>





<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>




	</xsl:template>

</xsl:stylesheet>
