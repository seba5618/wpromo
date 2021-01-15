<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Pago con medio y submedio cupon en ticket o monitor
	Autor: Elio Mauro Carreras
	Fecha: 12/03/2007
  **********************************************************************-->

<xsl:template match="promo[@promotype='pago_msm_cupon_ticket_monitor']">

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

	<xsl:variable name="promo_name">Promoción: Pago con medio y submedio cupon en ticket o monitor</xsl:variable>
	<xsl:variable name="promo_version">1.9.9</xsl:variable>
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

	<xsl:variable name="tipo_descuento"><xsl:apply-templates select="tipo_descuento"/></xsl:variable>
	<xsl:variable name="descuento"><xsl:apply-templates select="descuento"/></xsl:variable>
	<xsl:variable name="por_cada"><xsl:apply-templates select="por_cada"/></xsl:variable>
	<xsl:variable name="descuento_fijo"><xsl:apply-templates select="descuento_fijo"/></xsl:variable>

<xsl:variable name="medios"><xsl:for-each select="medios/m/medio">
<xsl:if test="@datatype = 'mutual'">
	global medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/> = <xsl:apply-templates select="."/>;
</xsl:if>
<xsl:if test="@datatype = 'idcard'">
	global medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/> = card(<xsl:if test=". = 0">null</xsl:if><xsl:if test=". &gt; 0">i<xsl:apply-templates select="."/></xsl:if>,<xsl:if test="../plan = 0">null</xsl:if><xsl:if test="../plan &gt; 0">p<xsl:apply-templates select="../plan"/></xsl:if>);
</xsl:if>
<xsl:if test="@datatype = 'ticket'">
	global medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/> = <xsl:apply-templates select="."/>;
</xsl:if>
<xsl:if test="@datatype = 'cash'">
	global medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/> = <xsl:apply-templates select="."/>;
</xsl:if>
<xsl:if test="@datatype = 'ctacte'">
	global medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/> = <xsl:apply-templates select="."/>;
</xsl:if>
<xsl:if test="@datatype = 'cheque'">
	global medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/> = <xsl:apply-templates select="."/>;
</xsl:if>
</xsl:for-each></xsl:variable>

	<xsl:variable name="cupon"><xsl:apply-templates select="cupon" mode="init"/></xsl:variable>
	<xsl:variable name="por_cada2"><xsl:apply-templates select="por_cada2"/></xsl:variable>
	<xsl:variable name="num_cupones"><xsl:apply-templates select="num_cupones"/></xsl:variable>

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

//********** Promoción Invel: Pago Medio SubMedio cupon en TICKET o MONITOR *************

Promotion <xsl:value-of select="$eval"/> pago_msm_cupon_ticket_monitor_<xsl:value-of select="$cod_promo"/>

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
	<xsl:value-of select="$medios"/>
	global publicar_cupon_<xsl:value-of select="$index"/> = <xsl:value-of select="$cupon"/>;
	global cantidad_<xsl:value-of select="$index"/> = 0;

	descuento = <xsl:value-of select="$descuento"/>;

	por_cada2 = <xsl:value-of select="$por_cada2"/>;
	num_cupones = <xsl:value-of select="$num_cupones"/>;

<!-- //////////////////////////////////////////////////////////////////////////////////
La siguiente solucion es transitoria.
Debe volverse atrás cuando 'means.medio' devuelva el monto exacto pagado con el medio 
////////////////////////////////////////////////////////////////////////////////////////-->
	monto = ((<xsl:for-each select="medios/m">means.medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>)
	- (<xsl:for-each select="medios/m">change.medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>));
	valor = monto * descuento;



<!-- >>>>>>>>>>>>>> -->


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	valor &gt;= por_cada2;
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	cantidad_<xsl:value-of select="$index"/> = (&amp;(valor / por_cada2) * num_cupones);
	<xsl:value-of select="$benef"/> = cantidad_<xsl:value-of select="$index"/> * <xsl:value-of select="$cupon2benef"/>;


	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": LATENTE");

<xsl:if test="$msj_monitor_latente='true'">
	print(<xsl:for-each select="mensajes/latente/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>

<!-- >>>>>>>>>>>>>> -->

<xsl:value-of select="$beneficios"/>
</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo pago_msm_cupon_ticket_monitor_<xsl:value-of select="$cod_promo"/>
<xsl:for-each select="medios/m">
	extern medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/>;
</xsl:for-each>
	extern publicar_cupon_<xsl:value-of select="$index"/>;
	extern cantidad_<xsl:value-of select="$index"/>;
	// -------------------------------- promo pago_msm_cupon_ticket_monitor_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo pago_msm_cupon_ticket_monitor_<xsl:value-of select="$cod_promo"/>

	issueBonus(publicar_cupon_<xsl:value-of select="$index"/>,cantidad_<xsl:value-of select="$index"/>);

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);
<xsl:for-each select="medios/m">
	if (means.medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/> &gt; 0)then
		rec(meanBeneficiary, medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/>);
	fi;
</xsl:for-each>

	rec(bonusBenefit,publicar_cupon_<xsl:value-of select="$index"/>,cantidad_<xsl:value-of select="$index"/>);

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




	// ------------------------------------------ promo pago_msm_cupon_ticket_monitor_<xsl:value-of select="$cod_promo"/>
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

//********** Promoción Invel: Pago Medio SubMedio cupon en TICKET o MONITOR *************

Promotion <xsl:value-of select="$eval"/> pago_msm_cupon_ticket_monitor_<xsl:value-of select="$cod_promo"/>

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
	<xsl:value-of select="$medios"/>
	global publicar_cupon_<xsl:value-of select="$index"/> = <xsl:value-of select="$cupon"/>;
	global cantidad_<xsl:value-of select="$index"/> = 0;

	por_cada = <xsl:value-of select="$por_cada"/>;
	descuento_fijo = <xsl:value-of select="$descuento_fijo"/>;

	por_cada2 = <xsl:value-of select="$por_cada2"/>;
	num_cupones = <xsl:value-of select="$num_cupones"/>;

<!-- //////////////////////////////////////////////////////////////////////////////////
La siguiente solucion es transitoria.
Debe volverse atrás cuando 'means.medio' devuelva el monto exacto pagado con el medio 
////////////////////////////////////////////////////////////////////////////////////////-->
	monto = ((<xsl:for-each select="medios/m">means.medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>)
	- (<xsl:for-each select="medios/m">change.medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>));

<xsl:if test="$por_cada='0'">
	por_cada = monto;
</xsl:if>
	valor = (&amp;(monto / por_cada) * descuento_fijo);


<!-- >>>>>>>>>>>>>> -->



Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	valor &gt;= por_cada2;
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	cantidad_<xsl:value-of select="$index"/> = (&amp;(valor / por_cada2) * num_cupones);
	<xsl:value-of select="$benef"/> = cantidad_<xsl:value-of select="$index"/> * <xsl:value-of select="$cupon2benef"/>;


	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": LATENTE");

<xsl:if test="$msj_monitor_latente='true'">
	print(<xsl:for-each select="mensajes/latente/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>

<!-- >>>>>>>>>>>>>> -->

<xsl:value-of select="$beneficios"/>
</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->
	// Parametros correspondientes a la promo pago_msm_cupon_ticket_monitor_<xsl:value-of select="$cod_promo"/>
<xsl:for-each select="medios/m">
	extern medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/>;
</xsl:for-each>
	extern publicar_cupon_<xsl:value-of select="$index"/>;
	extern cantidad_<xsl:value-of select="$index"/>;
	// -------------------------------- promo pago_msm_cupon_ticket_monitor_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo pago_msm_cupon_ticket_monitor_<xsl:value-of select="$cod_promo"/>

	issueBonus(publicar_cupon_<xsl:value-of select="$index"/>,cantidad_<xsl:value-of select="$index"/>);

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

<xsl:for-each select="medios/m">
	if (means.medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/> &gt; 0)then
		rec(meanBeneficiary, medio<xsl:number value="position()"/>_<xsl:value-of select="$index"/>);
	fi;
</xsl:for-each>

	rec(bonusBenefit,publicar_cupon_<xsl:value-of select="$index"/>,cantidad_<xsl:value-of select="$index"/>);

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




	// ------------------------------------------ promo pago_msm_cupon_ticket_monitor_<xsl:value-of select="$cod_promo"/>
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
