<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Grupo descuento caros baratos en bono
	Autor: Elio Mauro Carreras
	Fecha: 12/03/2007
  **********************************************************************-->

<xsl:template match="promo[@promotype='grupo_descuento_caros_baratos_bono']">

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

	<xsl:variable name="promo_name">Promoción: Grupo descuento caros baratos en bono</xsl:variable>
	<xsl:variable name="promo_version">1.8.9</xsl:variable>
	<xsl:variable name="promo_date">24/04/08</xsl:variable>
	<xsl:variable name="pc_version">1.9.13.16</xsl:variable>

	<xsl:variable name="cod_promo"><xsl:value-of select="$index"/></xsl:variable>

<!-- <<<<<<<<<<<<<< -->
	<xsl:variable name="promo_id">
		<xsl:value-of select="@id"/>
		<!--xsl:apply-templates select="promo_id"/-->
	</xsl:variable>
	<xsl:variable name="cod_externo"><xsl:apply-templates select="cod_externo"/></xsl:variable>

	<xsl:variable name="ignora_exclusion_arts"><xsl:apply-templates select="ignora_exclusion_arts"/></xsl:variable>
	<xsl:variable name="excluir"><xsl:apply-templates select="excluir"/></xsl:variable>

	<xsl:variable name="bolson"><xsl:apply-templates select="bolson"/></xsl:variable>
	<xsl:variable name="articulos"><xsl:apply-templates select="articulos"/></xsl:variable>
	
	<xsl:variable name="descuento"><xsl:apply-templates select="descuento"/></xsl:variable>
	<xsl:variable name="elegir_porcentaje"><xsl:apply-templates select="elegir_porcentaje"/></xsl:variable>

	<xsl:variable name="por_cada_arts"><xsl:apply-templates select="por_cada_arts"/></xsl:variable>
	<xsl:variable name="bonifico_arts"><xsl:apply-templates select="bonifico_arts"/></xsl:variable>

	<xsl:variable name="destino"><xsl:apply-templates select="destino"/></xsl:variable>
	<xsl:variable name="excluirplanes"><xsl:apply-templates select="excluirplanes"/></xsl:variable>

	<xsl:variable name="articulosprevios"><xsl:apply-templates select="previos/articulosprevios"/></xsl:variable>
	<xsl:variable name="deptoprevio"><xsl:apply-templates select="previos/deptoprevio"/></xsl:variable>

	<xsl:variable name="msj_monitor_latente"><xsl:apply-templates select="mensajes/msj_monitor_latente"/></xsl:variable>
	<xsl:variable name="msj_monitor_activa"><xsl:apply-templates select="mensajes/msj_monitor_activa"/></xsl:variable>
	<xsl:variable name="msj_ticket"><xsl:apply-templates select="mensajes/msj_ticket"/></xsl:variable>
	<xsl:variable name="msj_type"><xsl:apply-templates select="mensajes/type"/></xsl:variable>
<!-- >>>>>>>>>>>>>> -->



<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<xsl:if test="$articulos='baratos'">


<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Grupo Descuento a los N artículos más baratos en Bono o Monedero *************

Promotion <xsl:value-of select="$eval"/> grupo_descuento_baratos_bono_monedero_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
<!--	requireAll<xsl:value-of select="$bolson"/>;  -->
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
<xsl:if test="$elegir_porcentaje='true'">
	descuento = <xsl:value-of select="$descuento"/>;
</xsl:if>
<xsl:if test="not($elegir_porcentaje='true')">
	descuento = 1;
</xsl:if>

	descontar = <xsl:value-of select="$bonifico_arts"/>;
		// cantidad de art'iculos a los que se les har'a descuento.

	por_cada = <xsl:value-of select="$por_cada_arts"/>;
		// cantidad de art'iculos del grupo que se deben incluir en el ticket.

	bolson = <xsl:value-of select="$bolson"/>;
<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = (buyed - nopromotion) meet bolson;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = purchase meet bolson;
</xsl:if>

<xsl:if test="$destino='bono'">
	global publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="init"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	global publicar_plata_<xsl:value-of select="$index"/> = 0;
</xsl:if>
	global publicar_arts_<xsl:value-of select="$index"/> = {};

	arts_cantidad = (%(100 * \arts_a_bonificar\) / 100);

<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;

Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
//	|arts_a_bonificar| == |bolson|;

	arts_cantidad &gt;= por_cada;
	por_cada &gt; descontar;

<xsl:if test="$excluirplanes='true'">
	(<xsl:for-each select="excluir_planes/card">means.<xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>) == 0;
</xsl:if>
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
//	c = limite;
//	for (a,k) in arts_a_bonificar do
//		c = c min &amp;(k / bolson.a);
//	od;
//	arts_a_bonificar = c * bolson;

	num = &amp;(arts_cantidad / por_cada) * descontar;
	baratos = {};
	copia = arts_a_bonificar;

	for(a,k)in arts_a_bonificar do
		if (k &gt;= por_cada) then
			v = ((&amp;(k / por_cada) * descontar) min num);
			w = k -(&amp;(k / por_cada) * por_cada);
			baratos = baratos + {(a, v)};
			num = num - v;
			if (w &gt; 0) then
				copia = copia - {(a, w)};
			else
				copia = copia - {(a, k)};
			fi;				
		fi;
	od;

	for(a,k) in copia do
		if(num &gt; 0) then
			art_min = a;
			precio_min = 9999999;
			cantidad_min = 0;
			for(b,j) in copia do
				if(${(b,1)} &lt; precio_min) then
					art_min = b;
					precio_min = ${(b,1)};
					cantidad_min = j;
				fi;
			od;
			cantidad = cantidad_min min num;
			baratos = baratos + {(art_min, cantidad)};
			copia = copia - {(art_min, cantidad)};
			num = num - cantidad;
		fi;
	od;

	publicar_arts_<xsl:value-of select="$index"/> = baratos;
	valor = $baratos * descuento;

<xsl:if test="$destino='bono'">
	publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="val"><xsl:with-param name="valor" select="'valor'"/></xsl:apply-templates>;
	<xsl:value-of select="$benef"/> = valor * <xsl:value-of select="$bono2benef"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	publicar_plata_<xsl:value-of select="$index"/> = valor;
	<xsl:value-of select="$benef"/> = valor * <xsl:value-of select="$point2benef"/>;
</xsl:if>

	for (a,k) in baratos do
		<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + {(a, ${(a,k)} * descuento)};
	od;


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
	// Parametros correspondientes a la promo grupo_descuento_baratos_bono_monedero_<xsl:value-of select="$cod_promo"/>
<xsl:if test="$destino='bono'">
	extern publicar_bono_<xsl:value-of select="$index"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	extern publicar_plata_<xsl:value-of select="$index"/>;
</xsl:if>
	extern publicar_arts_<xsl:value-of select="$index"/>;
	// -------------------------------- promo grupo_descuento_baratos_bono_monedero_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo grupo_descuento_baratos_bono_monedero_<xsl:value-of select="$cod_promo"/>

<xsl:if test="$destino='bono'">
	issueBonus(publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>
<xsl:if test="$destino='monedero'">
	givePoints(point money,publicar_plata_<xsl:value-of select="$index"/>);
</xsl:if>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

	rec(artsBeneficiary, publicar_arts_<xsl:value-of select="$index"/>);
<xsl:if test="preconditions/bool_perfil='true'">
	rec(perfil, per);
</xsl:if>
<xsl:if test="$destino='bono'">
	rec(bonusBenefit,publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>
<xsl:if test="$destino='monedero'">
	rec(pointsBenefit, point money, publicar_plata_<xsl:value-of select="$index"/>);
</xsl:if>


	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>



	// ------------------------------------------ promo grupo_descuento_baratos_bono_monedero_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>


</xsl:if> <!--//////// fin articulos baratos /////////-->

<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->







<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<xsl:if test="$articulos='caros'">


<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Grupo Descuento a los N artículos más caros en Bono o Monedero *************

Promotion <xsl:value-of select="$eval"/> grupo_descuento_caros_bono_monedero_<xsl:value-of select="$cod_promo"/>

<!-- <<<<<<<<<<<<<< -->

<!-- >>>>>>>>>>>>>> -->

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
<!--	requireAll<xsl:value-of select="$bolson"/>;  -->
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
<xsl:if test="$elegir_porcentaje='true'">
	descuento = <xsl:value-of select="$descuento"/>;
</xsl:if>
<xsl:if test="not($elegir_porcentaje='true')">
	descuento = 1;
</xsl:if>

	descontar = <xsl:value-of select="$bonifico_arts"/>;
		// cantidad de art'iculos a los que se les har'a descuento.

	por_cada = <xsl:value-of select="$por_cada_arts"/>;
		// cantidad de art'iculos del grupo que se deben incluir en el ticket.

	bolson = <xsl:value-of select="$bolson"/>;
<xsl:if test="$ignora_exclusion_arts='true'">
	arts_a_bonificar = (buyed - nopromotion) meet bolson;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	arts_a_bonificar = purchase meet bolson;
</xsl:if>

<xsl:if test="$destino='bono'">
	global publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="init"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	global publicar_plata_<xsl:value-of select="$index"/> = 0;
</xsl:if>
	global publicar_arts_<xsl:value-of select="$index"/> = {};

	arts_cantidad = (%(100 * \arts_a_bonificar\) / 100);


<!-- >>>>>>>>>>>>>> -->


<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
//	|arts_a_bonificar| == |bolson|;

	arts_cantidad &gt;= por_cada;
	por_cada &gt; descontar;

<xsl:if test="$excluirplanes='true'">
	(<xsl:for-each select="excluir_planes/card">means.<xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>) == 0;
</xsl:if>
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
//	c = limite;
//	for (a,k) in arts_a_bonificar do
//		c = c min &amp;(k / bolson.a);
//	od;
//	arts_a_bonificar = c * bolson;

	num = &amp;(arts_cantidad / por_cada) * descontar;
	caros = {};
	copia = arts_a_bonificar;

	for(a,k)in arts_a_bonificar do
		if (k &gt;= por_cada) then
			v = ((&amp;(k / por_cada) * descontar) min num);
			w = k -(&amp;(k / por_cada) * por_cada);
			caros = caros + {(a, v)};
			num = num - v;
			if (w &gt; 0) then
				copia = copia - {(a, w)};
			else
				copia = copia - {(a, k)};
			fi;				
		fi;
	od;

	for(a,k) in copia do
		if(num &gt; 0) then
			art_max = a;
			precio_max = 0;
			cantidad_min = 0;
			for(b,j) in copia do
				if(${(b,1)} &gt; precio_max) then
					art_max = b;
					precio_max = ${(b,1)};
					cantidad_max = j;
				fi;
			od;
			cantidad = cantidad_max min num;
			caros = caros + {(art_max, cantidad)};
			copia = copia - {(art_max, cantidad)};
			num = num - cantidad;
		fi;
	od;

	publicar_arts_<xsl:value-of select="$index"/> = caros;
	valor = $caros * descuento;

<xsl:if test="$destino='bono'">
	publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="val"><xsl:with-param name="valor" select="'valor'"/></xsl:apply-templates>;
	<xsl:value-of select="$benef"/> = valor * <xsl:value-of select="$bono2benef"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	publicar_plata_<xsl:value-of select="$index"/> = valor;
	<xsl:value-of select="$benef"/> = valor * <xsl:value-of select="$point2benef"/>;
</xsl:if>


	for (a,k) in caros do
		<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + {(a, ${(a,k)} * descuento)};
	od;



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
	// Parametros correspondientes a la promo grupo_descuento_caros_bono_monedero_<xsl:value-of select="$cod_promo"/>
<xsl:if test="$destino='bono'">
	extern publicar_bono_<xsl:value-of select="$index"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	extern publicar_plata_<xsl:value-of select="$index"/>;
</xsl:if>
	extern publicar_arts_<xsl:value-of select="$index"/>;
	// -------------------------------- promo grupo_descuento_caros_bono_monedero_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo grupo_descuento_caros_bono_monedero_<xsl:value-of select="$cod_promo"/>

<xsl:if test="$destino='bono'">
	issueBonus(publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>
<xsl:if test="$destino='monedero'">
	givePoints(point money,publicar_plata_<xsl:value-of select="$index"/>);
</xsl:if>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

	rec(artsBeneficiary, publicar_arts_<xsl:value-of select="$index"/>);
<xsl:if test="preconditions/bool_perfil='true'">
	rec(perfil, per);
</xsl:if>
<xsl:if test="$destino='bono'">
	rec(bonusBenefit,publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>
<xsl:if test="$destino='monedero'">
	rec(pointsBenefit, point money, publicar_plata_<xsl:value-of select="$index"/>);
</xsl:if>


	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>



	// ------------------------------------------ promo grupo_descuento_caros_bono_monedero_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>


</xsl:if> <!--//////// fin articulos caros /////////-->

<!--////////////////////////////////////////////////////////////////////////////////////////////-->
<!--////////////////////////////////////////////////////////////////////////////////////////////-->




<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>


	</xsl:template>

</xsl:stylesheet>
