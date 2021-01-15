<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Medios - Descuento en Ticket
	Autor: Fabian Ramirez
	Fecha: 21/07/2009
  **********************************************************************-->

<xsl:template match="promo[@promotype='bambu_un_medio_descuento_ticket']">

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

	<xsl:variable name="promo_name">Promoción: Medios - Descuento en Ticket</xsl:variable>
	<xsl:variable name="promo_version">1.0.19</xsl:variable>
	<xsl:variable name="promo_date">22/03/2013</xsl:variable>
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

	<!--xsl:variable name="msj_obliga_medios"><xsl:apply-templates select="mensajes/medios_promocionados"/></xsl:variable-->

	<xsl:variable name="medios_requeridos">{<xsl:for-each select="medios/m/medio">
			<xsl:if test="@datatype = 'mutual'">mutual m<xsl:value-of select="."/>s<xsl:apply-templates select="../submedio"/></xsl:if>
			<xsl:if test="@datatype = 'idcard'">card(<xsl:if test="not(. &gt; 0)">null</xsl:if><xsl:if test=". &gt; 0">i<xsl:apply-templates select="."/></xsl:if>,<xsl:if test="not(../submedio &gt; 0)">null</xsl:if><xsl:if test="../submedio &gt; 0">p<xsl:apply-templates select="../submedio"/></xsl:if>)</xsl:if>
			<xsl:if test="@datatype = 'gcard'">
				<xsl:if test=". &gt; 0">
					<xsl:if test="../submedio &gt; 0"><xsl:if test="../plan &gt; 0">card(m<xsl:value-of select="."/>s<xsl:value-of select="../submedio"/>,p<xsl:value-of select="../plan"/>)</xsl:if></xsl:if>
					<xsl:if test="../submedio &gt; 0"><xsl:if test="../plan = 0">card(m<xsl:value-of select="."/>s<xsl:value-of select="../submedio"/>,null)</xsl:if></xsl:if>
					<xsl:if test="../submedio = 0"><xsl:if test="../plan &gt; 0">card(null,p<xsl:value-of select="../plan"/>)</xsl:if></xsl:if>
					<xsl:if test="../submedio = 0"><xsl:if test="../plan = 0">card(null,null)</xsl:if></xsl:if>
				</xsl:if>
				<xsl:if test=". &lt;= 0">
					<xsl:if test="../submedio &gt; 0"><xsl:if test="../plan &gt; 0">card(i<xsl:value-of select="../submedio"/>,p<xsl:value-of select="../plan"/>)</xsl:if></xsl:if>
					<xsl:if test="../submedio &gt; 0"><xsl:if test="../plan = 0">card(i<xsl:value-of select="../submedio"/>,null)</xsl:if></xsl:if>
					<xsl:if test="../submedio = 0"><xsl:if test="../plan &gt; 0">card(null,p<xsl:value-of select="../plan"/>)</xsl:if></xsl:if>
					<xsl:if test="../submedio = 0"><xsl:if test="../plan = 0">card(null,null)</xsl:if></xsl:if>
				</xsl:if>
				</xsl:if>
			<xsl:if test="@datatype = 'ticket'">ticket m<xsl:value-of select="."/>s<xsl:apply-templates select="../submedio"/></xsl:if>
			<xsl:if test="@datatype = 'cash'"><xsl:apply-templates select="."/></xsl:if>
			<xsl:if test="@datatype = 'currency'">currency m<xsl:value-of select="."/>s<xsl:apply-templates select="../submedio"/></xsl:if>
			<xsl:if test="@datatype = 'ctacte'">ctacte</xsl:if>
			<xsl:if test="@datatype = 'cheque'">cheque m<xsl:value-of select="."/>s<xsl:apply-templates select="../submedio"/></xsl:if>
			<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>}
	</xsl:variable>

		<xsl:variable name="mediorequerido"><xsl:for-each select="medios/m/medio">
		    <xsl:if test="@datatype = 'mutual'"><xsl:value-of select="."/></xsl:if>
			<xsl:if test="@datatype = 'idcard'">card(<xsl:if test="not(. &gt; 0)">null</xsl:if><xsl:if test=". &gt; 0">i<xsl:apply-templates select="."/></xsl:if>,<xsl:if test="not(../submedio &gt; 0)">null</xsl:if><xsl:if test="../submedio &gt; 0">p<xsl:apply-templates select="../submedio"/></xsl:if>)</xsl:if>
			<xsl:if test="@datatype = 'gcard'">
				<xsl:if test=". &gt; 0">
					<xsl:if test="../submedio &gt; 0"><xsl:value-of select="."/></xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="@datatype = 'ticket'"><xsl:value-of select="."/></xsl:if>
			<xsl:if test="@datatype = 'cash'"><xsl:value-of select="."/></xsl:if>
			<xsl:if test="@datatype = 'currency'">currency m<xsl:value-of select="."/>s<xsl:apply-templates select="../submedio"/></xsl:if>
			<xsl:if test="@datatype = 'ctacte'"><xsl:value-of select="."/></xsl:if>
			<xsl:if test="@datatype = 'cheque'"><xsl:value-of select="."/></xsl:if>
			<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>
	</xsl:variable>
	
	<xsl:variable name="submedio_requerido"><xsl:for-each select="medios/m/medio">
			<xsl:if test="@datatype = 'mutual'"><xsl:apply-templates select="../submedio"/></xsl:if>
			<xsl:if test="@datatype = 'idcard'">card(<xsl:if test="not(. &gt; 0)">null</xsl:if><xsl:if test=". &gt; 0">i<xsl:apply-templates select="."/></xsl:if>,<xsl:if test="not(../submedio &gt; 0)">null</xsl:if><xsl:if test="../submedio &gt; 0">p<xsl:apply-templates select="../submedio"/></xsl:if>)</xsl:if>
			<xsl:if test="@datatype = 'gcard'"> <xsl:value-of select="../submedio"/></xsl:if>
			<xsl:if test="@datatype = 'ticket'"><xsl:apply-templates select="../submedio"/></xsl:if>
			<xsl:if test="@datatype = 'cash'"><xsl:apply-templates select="../submedio"/></xsl:if>
			<xsl:if test="@datatype = 'currency'">currency m<xsl:value-of select="."/>s<xsl:apply-templates select="../submedio"/></xsl:if>
			<xsl:if test="@datatype = 'ctacte'">ctacte</xsl:if>
			<xsl:if test="@datatype = 'cheque'">cheque m<xsl:value-of select="."/>s<xsl:apply-templates select="../submedio"/></xsl:if>
			<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>
	</xsl:variable>
	
	<xsl:variable name="plan_requerido"><xsl:for-each select="medios/m/medio">
			<xsl:if test="@datatype = 'mutual'">0</xsl:if>
			<xsl:if test="@datatype = 'idcard'">card(<xsl:if test="not(. &gt; 0)">null</xsl:if><xsl:if test=". &gt; 0">i<xsl:apply-templates select="."/></xsl:if>,<xsl:if test="not(../submedio &gt; 0)">null</xsl:if><xsl:if test="../submedio &gt; 0">p<xsl:apply-templates select="../submedio"/></xsl:if>)</xsl:if>
			<xsl:if test="@datatype = 'gcard'"> <xsl:if test="../plan &gt; 0"><xsl:value-of select="../plan"/></xsl:if></xsl:if>
			<xsl:if test="@datatype = 'gcard'"> <xsl:if test="../plan = 0">0</xsl:if></xsl:if>
			<xsl:if test="@datatype = 'ticket'">0</xsl:if>
			<xsl:if test="@datatype = 'cash'">0</xsl:if>
			<xsl:if test="@datatype = 'currency'">0</xsl:if>
			<xsl:if test="@datatype = 'ctacte'">0</xsl:if>
			<xsl:if test="@datatype = 'cheque'">0</xsl:if>
			<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>
	</xsl:variable>
	
	  

	
	

	<xsl:variable name="descuento"><xsl:apply-templates select="descuento"/></xsl:variable>
	<xsl:variable name="comportamiento"><xsl:apply-templates select="comportamiento"/></xsl:variable>
	
	<xsl:variable name="val_perfil"><xsl:apply-templates select="preconditions/bool_perfil"/></xsl:variable>
	<!--
	<xsl:variable name="monto_benef">monto_benef_promo65<xsl:if test="$val_perfil='true'">_perfil<xsl:apply-templates select="preconditions/perfil"/></xsl:if></xsl:variable>
	-->

	<xsl:variable name="eans"><xsl:apply-templates select="nuevo_eans"/></xsl:variable>
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

//********** Promoción Invel: Promoción: Medios - Descuento en Ticket *************

Promotion <xsl:value-of select="$eval"/> bambu_un_medio_descuento_ticket_<xsl:value-of select="$cod_promo"/>

PreConditions

<xsl:apply-templates select="preconditions"/>
<xsl:value-of select="$condiciones"/>
<xsl:if test="$comportamiento='articulos'">
	requireAny<xsl:value-of select="$bolson"/>;
</xsl:if>
<xsl:if test="$articulosprevios='true'">
	requireAll<xsl:apply-templates select="previos/articulos_previos"/>;
</xsl:if>
<xsl:if test="$deptoprevio ='true'">
	require ( [ <xsl:apply-templates select="previos/depto_previo/depto"/> ], <xsl:apply-templates select="previos/depto_previo/cantidad"/> );
</xsl:if>


Parameters
<xsl:value-of select="$parametros"/>

<!-- <<<<<<<<<<<<<< -->

<!-- 	descuento = <xsl:value-of select="$descuento"/>;-->
    
	descuento = <xsl:value-of select="$descuento"/>;
	mediorequerido = <xsl:value-of select="$mediorequerido"/>;
	submedio_requerido = <xsl:value-of select="$submedio_requerido"/>;
	plan_requerido = <xsl:value-of select="$plan_requerido"/>;
	limite_entrega = <xsl:value-of select="$limite"/>; 
	
	
<xsl:if test="$comportamiento='articulos'">
  arts_involucrados = <xsl:value-of select="$bolson"/>;
</xsl:if>
<!--  extern <xsl:value-of select="$monto_benef"/>; -->


	global publicar_arts_<xsl:value-of select="$index"/> = {};
	global publicar_<xsl:value-of select="$index"/> = {};
	global descarga_<xsl:value-of select="$index"/> = <xsl:value-of select="$descarga"/>;
	global monto_requerido_<xsl:value-of select="$index"/> = 0;
<!-- >>>>>>>>>>>>>> -->

<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


<xsl:if test="$comportamiento='incondicional'">
<xsl:if test="$ignora_exclusion_arts='true'">
	bolson = (buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>);
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	bolson = purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>;
</xsl:if>
</xsl:if>

<xsl:if test="$comportamiento='articulos'">
<xsl:if test="$ignora_exclusion_arts='true'">
	bolson = (buyed - nopromotion <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet arts_involucrados;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	bolson = (purchase <xsl:if test="$excluir_articulos_precio_oferta='true'">- department specialCreditPrice</xsl:if>) meet arts_involucrados;
</xsl:if>
</xsl:if>


	submedio_pago = numRNV( cantidad_eventos_enviar_offline); 
	medio_pago = numRNV(ram_subindice_pago_cmr) ;
	plan_pago = numRNV(puerto_servidor_dbrouter) ;
<!--	monto = $bolson - <xsl:value-of select="$monto_benef"/>; -->
	monto = $bolson - 0;
	
	
	

Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
	monto &gt; 0.01;
	medio_pago &gt; 0;

<xsl:if test="$submedio_requerido &gt;0">
		submedio_pago == submedio_requerido;
</xsl:if>
	
	medio_pago == mediorequerido;
<xsl:if test="$plan_requerido &gt;0">
		plan_pago == plan_requerido;
</xsl:if>	
	
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->

<xsl:if test="mensaje_medios/mensaje/linea">
	print(<xsl:for-each select="mensaje_medios/mensaje/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
  a_pagar = 0;
  info_monto = monto;
  a_pagar = info_monto;
  


  if a_pagar > 0 then
    descuento_ajustado = <xsl:value-of select="$descuento"/> * ( (monto min a_pagar) / (monto + 0) );
   <!-- <xsl:value-of select="$monto_benef"/> = 0 + (monto min a_pagar);-->

		for (a,k) in bolson do
			publicar_<xsl:value-of select="$index"/> = publicar_<xsl:value-of select="$index"/> + {(a,${(a,k)}*descuento_ajustado)};
		od;

		publicar_arts_<xsl:value-of select="$index"/> = bolson  ;

		a_descontar = ( limite_entrega min (\publicar_<xsl:value-of select="$index"/>\)) ;
		<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + publicar_arts_<xsl:value-of select="$index"/>;
		<xsl:value-of select="$benef"/> = ( limite_entrega min (a_descontar  * <xsl:value-of select="$cash2benef"/>) );

	<xsl:if test="$excluir='true'">
		<xsl:value-of select="$excluded"/> = <xsl:value-of select="$excluded"/> + publicar_arts_<xsl:value-of select="$index"/>;
			// se excluyen los artículos bonificados para que no participen
			// de nuevas promociones.
	</xsl:if>

		monto_requerido_<xsl:value-of select="$index"/> = (monto min a_pagar) - a_descontar;

  	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": LATENTE");

<xsl:if test="$msj_monitor_latente='true'">
	  print(<xsl:for-each select="mensajes/latente/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
	fi;


<!-- >>>>>>>>>>>>>> -->

<xsl:value-of select="$beneficios"/>
</xsl:if>




<xsl:if test="$view='parameters'">
<!-- <<<<<<<<<<<<<< -->

	// -------------------------------- promo medios_descuento_<xsl:value-of select="$cod_promo"/>
	extern descarga_<xsl:value-of select="$index"/>;
	extern publicar_<xsl:value-of select="$index"/>;
	extern publicar_arts_<xsl:value-of select="$index"/>;
	extern monto_requerido_<xsl:value-of select="$index"/>;
    limite_entrega  = <xsl:value-of select="$limite"/>;
	medios_requeridos_<xsl:value-of select="$index"/> = <xsl:value-of select="$medios_requeridos"/>;	
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo bambu_un_medio_descuento_ticket_<xsl:value-of select="$cod_promo"/>

	// Informando eventos
	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);




<xsl:if test="$eans='uno'">
  credit(descarga_<xsl:value-of select="$index"/>,\publicar_<xsl:value-of select="$index"/>\ min limite_entrega,publicar_arts_<xsl:value-of select="$index"/>);
	for (a,k) in publicar_<xsl:value-of select="$index"/> do
		mc = {(a, publicar_arts_<xsl:value-of select="$index"/>.a)};
		rec(artsBeneficiary, mc);
		rec(creditBenefit, k);
	od;
</xsl:if>
<xsl:if test="$eans='varios'">
	for (a,k) in publicar_<xsl:value-of select="$index"/> do
		mc = {(a, publicar_arts_<xsl:value-of select="$index"/>.a)};
		credit(a, (k min limite_entrega), mc);
		rec(artsBeneficiary, mc);
		rec(creditBenefit, k);
	od;
</xsl:if>

<xsl:if test="preconditions/bool_perfil='true'">
	rec(perfil, per);
</xsl:if>


    requireMeans(medios_requeridos_<xsl:value-of select="$index"/>, monto_requerido_<xsl:value-of select="$index"/> min $wholepurchase );

	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>


	// ------------------------------------------ promo bambu_un_medio_descuento_ticket_<xsl:value-of select="$cod_promo"/>

<!-- >>>>>>>>>>>>>> -->
</xsl:if>




<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>


	</xsl:template>

</xsl:stylesheet>