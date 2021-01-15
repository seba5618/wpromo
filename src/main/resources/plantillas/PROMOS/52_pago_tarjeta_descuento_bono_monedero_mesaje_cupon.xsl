<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Pago con medio y submedio descuento en bono
	Autor: Elio Mauro Carreras
	Fecha: 12/03/2007
  **********************************************************************-->

<xsl:template match="promo[@promotype='pago_tarjeta_descuento_bono_mensaje_cupon']">

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

	<xsl:variable name="promo_name">Promoción: Pago con tarjeta descuento en bono mensaje cupon</xsl:variable>
	<xsl:variable name="promo_version">1.0.5</xsl:variable>
	<xsl:variable name="promo_date">14/08/08</xsl:variable>
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

	<xsl:variable name="tipo_descuento"><xsl:apply-templates select="tipo_descuento"/></xsl:variable>
	<xsl:variable name="descuento"><xsl:apply-templates select="descuento"/></xsl:variable>
	<xsl:variable name="por_cada"><xsl:apply-templates select="por_cada"/></xsl:variable>
	<xsl:variable name="descuento_fijo"><xsl:apply-templates select="descuento_fijo"/></xsl:variable>

	<xsl:variable name="destino"><xsl:apply-templates select="destino"/></xsl:variable>

	<xsl:variable name="imp_max_bonificacion_bool"><xsl:apply-templates select="imp_max_bonificacion_bool"/></xsl:variable>
	<xsl:variable name="imp_max_bonifica"><xsl:apply-templates select="imp_max_bonifica"/></xsl:variable>

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

//********** Promoción Invel: Pago Medio SubMedio descuento en BONO o Monedero*************

Promotion <xsl:value-of select="$eval"/> pago_tarjeta_descuento_bono_mensaje_cupon_<xsl:value-of select="$cod_promo"/>

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
<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;

<!-- <<<<<<<<<<<<<< -->
	global imprimir_<xsl:value-of select="$index"/> = false;
	global descontar_<xsl:value-of select="$index"/> = false;
	global publicar_cupon_<xsl:value-of select="$index"/> = <xsl:apply-templates select="cupon_mensaje" mode="init"/>;
<xsl:if test="$destino='bono'">
	global publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="init"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	global publicar_plata_<xsl:value-of select="$index"/> = 0;
</xsl:if>

	descuento = <xsl:value-of select="$descuento"/>;
	estas = (<xsl:for-each select="medio/card">means.<xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>);
	otras = (means.card(null,null) - estas);


<xsl:if test="$imp_max_bonificacion_bool='true'">
	imp_max_bon = <xsl:value-of select="$imp_max_bonifica"/>;
</xsl:if>

<!-- >>>>>>>>>>>>>> -->


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	estas &gt; 0 || otras &gt; 0;
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	valor_avisar = 0;
	if estas == 0 then
		valor_avisar = otras * descuento;
	fi;

<xsl:if test="$imp_max_bonificacion_bool='true'">
	valor_descontar = imp_max_bon min (estas * descuento);
</xsl:if>
<xsl:if test="$imp_max_bonificacion_bool='false'">
	valor_descontar = estas * descuento;
</xsl:if>

	if valor_avisar &gt; 0 then
		publicar_cupon_<xsl:value-of select="$index"/> = <xsl:apply-templates select="cupon_mensaje" mode="val"><xsl:with-param name="valor" select="'valor_avisar'"/></xsl:apply-templates>;
		<xsl:value-of select="$benef"/> = valor_avisar * <xsl:value-of select="$bono2benef"/>;
		imprimir_<xsl:value-of select="$index"/> = true;
	fi;

	if valor_descontar &gt; 0 then
<xsl:if test="$destino='bono'">
		publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="val"><xsl:with-param name="valor" select="'valor_descontar'"/></xsl:apply-templates>;
		<xsl:value-of select="$benef"/> = valor_descontar * <xsl:value-of select="$bono2benef"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
		publicar_plata_<xsl:value-of select="$index"/> = valor_descontar;
		<xsl:value-of select="$benef"/> = valor_descontar * <xsl:value-of select="$point2benef"/>;
</xsl:if>
		descontar_<xsl:value-of select="$index"/> = true;
	fi;

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": LATENTE");

<xsl:if test="$msj_monitor_latente='true'">
	print(<xsl:for-each select="mensajes/latente/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>

<!-- >>>>>>>>>>>>>> -->

<xsl:value-of select="$beneficios"/>
</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo pago_tarjeta_descuento_bono_mensaje_cupon_<xsl:value-of select="$cod_promo"/>
	extern descontar_<xsl:value-of select="$index"/>;
	extern imprimir_<xsl:value-of select="$index"/>;
	extern publicar_cupon_<xsl:value-of select="$index"/>;
<xsl:if test="$destino='bono'">
	extern publicar_bono_<xsl:value-of select="$index"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	extern publicar_plata_<xsl:value-of select="$index"/>;
</xsl:if>
	// -------------------------------- promo pago_tarjeta_descuento_bono_mensaje_cupon_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo pago_tarjeta_descuento_bono_mensaje_cupon_<xsl:value-of select="$cod_promo"/>

	if imprimir_<xsl:value-of select="$index"/> then
		issueBonus(publicar_cupon_<xsl:value-of select="$index"/>,1);
	fi;

	if descontar_<xsl:value-of select="$index"/> then
<xsl:if test="$destino='bono'">
	issueBonus(publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>
<xsl:if test="$destino='monedero'">
	givePoints(point money,publicar_plata_<xsl:value-of select="$index"/>);
</xsl:if>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);
<xsl:for-each select="medio/card">
	if (means.<xsl:apply-templates select="."/> &gt; 0)then
		rec(meanBeneficiary, <xsl:apply-templates select="."/>);
	fi;
</xsl:for-each>

<xsl:if test="$destino='bono'">
	rec(bonusBenefit,publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>
<xsl:if test="$destino='monedero'">
	rec(pointsBenefit, point money, publicar_plata_<xsl:value-of select="$index"/>);
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

	fi;


	// ------------------------------------------ promo pago_tarjeta_descuento_bono_mensaje_cupon_<xsl:value-of select="$cod_promo"/>
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

//********** Promoción Invel: Pago MSM descuento en BONO *************

Promotion <xsl:value-of select="$eval"/> pago_tarjeta_descuento_bono_mensaje_cupon_<xsl:value-of select="$cod_promo"/>

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
<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;

<!-- <<<<<<<<<<<<<< -->
	global imprimir_<xsl:value-of select="$index"/> = false;
	global descontar_<xsl:value-of select="$index"/> = false;
	global publicar_cupon_<xsl:value-of select="$index"/> = <xsl:apply-templates select="cupon_mensaje" mode="init"/>;
<xsl:if test="$destino='bono'">
	global publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="init"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	global publicar_plata_<xsl:value-of select="$index"/> = 0;
</xsl:if>

	por_cada = <xsl:value-of select="$por_cada"/>;
	descuento_fijo = <xsl:value-of select="$descuento_fijo"/>;
	estas = (<xsl:for-each select="medio/card">means.<xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>);
	otras = (means.card(null,null) - estas);


<xsl:if test="$imp_max_bonificacion_bool='true'">
	imp_max_bon = <xsl:value-of select="$imp_max_bonifica"/>;
</xsl:if>

<!-- >>>>>>>>>>>>>> -->


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	por_cada &gt; 0;
	estas &gt; 0 || otras &gt; 0;
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	valor_avisar = 0;
	if estas == 0 then
		valor_avisar = (&amp;(otras / por_cada)  * descuento_fijo);
	fi;

<xsl:if test="$imp_max_bonificacion_bool='true'">
	valor_descontar = imp_max_bon min (&amp;(estas / por_cada) * descuento_fijo);
</xsl:if>
<xsl:if test="$imp_max_bonificacion_bool='false'">
	valor_descontar = (&amp;(estas / por_cada) * descuento_fijo);
</xsl:if>

	if valor_avisar &gt; 0 then
		publicar_cupon_<xsl:value-of select="$index"/> = <xsl:apply-templates select="cupon_mensaje" mode="val"><xsl:with-param name="valor" select="'valor_avisar'"/></xsl:apply-templates>;
		<xsl:value-of select="$benef"/> = valor_avisar * <xsl:value-of select="$bono2benef"/>;
		imprimir_<xsl:value-of select="$index"/> = true;
	fi;

	if valor_descontar &gt; 0 then
<xsl:if test="$destino='bono'">
		publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="val"><xsl:with-param name="valor" select="'valor_descontar'"/></xsl:apply-templates>;
		<xsl:value-of select="$benef"/> = valor_descontar * <xsl:value-of select="$bono2benef"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
		publicar_plata_<xsl:value-of select="$index"/> = valor_descontar;
		<xsl:value-of select="$benef"/> = valor_descontar * <xsl:value-of select="$point2benef"/>;
</xsl:if>
		descontar_<xsl:value-of select="$index"/> = true;
	fi;

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": LATENTE");

<xsl:if test="$msj_monitor_latente='true'">
	print(<xsl:for-each select="mensajes/latente/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>

<!-- >>>>>>>>>>>>>> -->

<xsl:value-of select="$beneficios"/>
</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo pago_tarjeta_descuento_bono_mensaje_cupon_<xsl:value-of select="$cod_promo"/>
	extern descontar_<xsl:value-of select="$index"/>;
	extern imprimir_<xsl:value-of select="$index"/>;
	extern publicar_cupon_<xsl:value-of select="$index"/>;
<xsl:if test="$destino='bono'">
	extern publicar_bono_<xsl:value-of select="$index"/>;
</xsl:if>
<xsl:if test="$destino='monedero'">
	extern publicar_plata_<xsl:value-of select="$index"/>;
</xsl:if>
	// -------------------------------- promo pago_tarjeta_descuento_bono_mensaje_cupon_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo pago_tarjeta_descuento_bono_mensaje_cupon_<xsl:value-of select="$cod_promo"/>

	if imprimir_<xsl:value-of select="$index"/> then
		issueBonus(publicar_cupon_<xsl:value-of select="$index"/>,1);
	fi;

	if descontar_<xsl:value-of select="$index"/> then
<xsl:if test="$destino='bono'">
	issueBonus(publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>
<xsl:if test="$destino='monedero'">
	givePoints(point money,publicar_plata_<xsl:value-of select="$index"/>);
</xsl:if>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);
<xsl:for-each select="medio/card">
	if (means.<xsl:apply-templates select="."/> &gt; 0)then
		rec(meanBeneficiary, <xsl:apply-templates select="."/>);
	fi;
</xsl:for-each>

<xsl:if test="$destino='bono'">
	rec(bonusBenefit,publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>
<xsl:if test="$destino='monedero'">
	rec(pointsBenefit, point money, publicar_plata_<xsl:value-of select="$index"/>);
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

	fi;

	// ------------------------------------------ promo pago_tarjeta_descuento_bono_mensaje_cupon_<xsl:value-of select="$cod_promo"/>
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
