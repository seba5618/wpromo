<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="../common/conds.xsl"/>
<xsl:output method="text"/>

<!--***********************************************************************
	Promoción: Importe total puntos
	Autor: Elio Mauro Carreras
	Fecha: 12/03/2007
  **********************************************************************-->

<xsl:template match="promo[@promotype='importe_total_puntos']">

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

	<xsl:variable name="promo_name">Promoción: Importe total puntos</xsl:variable>
	<xsl:variable name="promo_version">1.1.4</xsl:variable>
	<xsl:variable name="promo_date">12/09/2011</xsl:variable>
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

	<xsl:variable name="por_cada"><xsl:apply-templates select="por_cada"/></xsl:variable>
	<xsl:variable name="num_puntos"><xsl:apply-templates select="num_puntos"/></xsl:variable>

	<xsl:variable name="redondear_puntos"><xsl:apply-templates select="redondear_puntos"/></xsl:variable>
	<xsl:variable name="decimales"><xsl:apply-templates select="decimales"/></xsl:variable>


	<xsl:variable name="req_cliente"><xsl:apply-templates select="requerir_cliente"/></xsl:variable>
	<xsl:variable name="req_cliente_fiel"><xsl:apply-templates select="requerir_cliente_fiel"/></xsl:variable>
	<xsl:variable name="emitir_bono"><xsl:apply-templates select="emitir_bono"/></xsl:variable>


	<xsl:variable name="benef_anteriores"><xsl:apply-templates select="benef_anteriores"/></xsl:variable>
	<xsl:variable name="excluirplanes"><xsl:apply-templates select="excluirplanes"/></xsl:variable>
	<xsl:variable name="requerirplanes"><xsl:apply-templates select="requerirplanes"/></xsl:variable>

	<xsl:variable name="limite"><xsl:apply-templates select="limite"></xsl:apply-templates></xsl:variable>

	<xsl:variable name="articulosprevios"><xsl:apply-templates select="previos/articulosprevios"/></xsl:variable>
	<xsl:variable name="deptoprevio"><xsl:apply-templates select="previos/deptoprevio"/></xsl:variable>

	<xsl:variable name="msj_monitor_latente"><xsl:apply-templates select="mensajes/msj_monitor_latente"/></xsl:variable>
	<xsl:variable name="msj_monitor_activa"><xsl:apply-templates select="mensajes/msj_monitor_activa"/></xsl:variable>
	<xsl:variable name="msj_ticket"><xsl:apply-templates select="mensajes/msj_ticket"/></xsl:variable>
	<xsl:variable name="msj_type"><xsl:apply-templates select="mensajes/type"/></xsl:variable>
<!-- >>>>>>>>>>>>>> -->



<xsl:if test="$view='main'">
		<!-- AQUI COMIENZA LA VISTA PRINCIPAL DE LA PROMOCION -->

//********** Promoción Invel: Importe Total Puntos *************

Promotion <xsl:value-of select="$eval"/> importe_total_puntos_<xsl:value-of select="$cod_promo"/>

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
	limite_entrega = <xsl:value-of select="$limite"/>;
		// cantidad m'axima de puntos a otorgar.
	por_cada = <xsl:value-of select="$por_cada"/>;
	num_puntos = <xsl:value-of select="$num_puntos"/>;

	global publicar_arts_<xsl:value-of select="$index"/> = {};
	global publicar_puntos_<xsl:value-of select="$index"/> = 0;
<xsl:if test="$emitir_bono='true'">
	global publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="init"/>;
</xsl:if>
<!-- >>>>>>>>>>>>>> -->

<xsl:apply-templates select="conditions"><xsl:with-param name="view">parameters</xsl:with-param></xsl:apply-templates>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;


<xsl:if test="$ignora_exclusion_arts='true'">
	monto = $(buyed - nopromotion);
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	monto = $purchase;
</xsl:if>

<xsl:if test="$por_cada='0'">
<xsl:if test="$ignora_exclusion_arts='true'">
	por_cada = monto;
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	por_cada = monto;
</xsl:if>
</xsl:if>


Conditions

<xsl:apply-templates select="conditions"/>

<!-- <<<<<<<<<<<<<< -->
<xsl:if test="$req_cliente='true'">
	numRNV( ram_nro_cliente ) > 0; 
</xsl:if>
<xsl:if test="$req_cliente_fiel='true'">
	affiliated;
</xsl:if>
	monto &gt;= por_cada;
<xsl:if test="$excluirplanes='true'">
	(<xsl:for-each select="excluir_planes/card">means.<xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> + </xsl:if></xsl:for-each>) == 0;
</xsl:if>
<xsl:if test="$requerirplanes='true'">

  (<xsl:for-each select="medios/m/medio">means.<xsl:if test="@datatype = 'mutual'">mutual m<xsl:value-of select="."/>s<xsl:apply-templates select="../plan"/></xsl:if>
			<xsl:if test="@datatype = 'idcard'">card(<xsl:if test="not(. &gt; 0)">null</xsl:if><xsl:if test=". &gt; 0">i<xsl:apply-templates select="."/></xsl:if>,<xsl:if test="not(../plan &gt; 0)">null</xsl:if><xsl:if test="../plan &gt; 0">p<xsl:apply-templates select="../plan"/></xsl:if>)</xsl:if>
			<xsl:if test="@datatype = 'ticket'">ticket m<xsl:value-of select="."/>s<xsl:apply-templates select="../plan"/></xsl:if>
			<xsl:if test="@datatype = 'cash'"><xsl:apply-templates select="."/></xsl:if>
			<xsl:if test="@datatype = 'currency'">currency m<xsl:value-of select="."/>s<xsl:apply-templates select="../plan"/></xsl:if>
			<xsl:if test="@datatype = 'ctacte'">ctacte</xsl:if>
			<xsl:if test="@datatype = 'cheque'">cheque m<xsl:value-of select="."/>s<xsl:apply-templates select="../plan"/></xsl:if>
			<xsl:if test="@datatype = 'gmean'">card(m<xsl:apply-templates select="."/>,<xsl:if test="not(../plan &gt; 0)">null</xsl:if><xsl:if test="../plan &gt; 0">p<xsl:apply-templates select="../plan"/></xsl:if>)</xsl:if>
			<xsl:if test="not(position()=last())"> + </xsl:if>
</xsl:for-each>) &gt; 0;
</xsl:if>
<!-- >>>>>>>>>>>>>> -->


Benefits

<!-- <<<<<<<<<<<<<< -->
	valor = ((&amp;(monto / por_cada) * num_puntos) min limite_entrega);
	<xsl:variable name = "mult" >
		<xsl:call-template name = "pow" >
			<xsl:with-param name = "base" select = "10" />
			<xsl:with-param name = "pow" select = "$decimales" />
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:choose>
	   <xsl:when test = "$redondear_puntos='round'" >
  valor = (%(valor*<xsl:value-of select="$mult"/>)) / <xsl:value-of select="$mult"/>;
	   </xsl:when>
	   <xsl:when test = "$redondear_puntos='floor'" >
  valor = (&amp;(valor*<xsl:value-of select="$mult"/>)) / <xsl:value-of select="$mult"/>;
	   </xsl:when>
	   <xsl:when test = "$redondear_puntos='ceil'" >
	v = &amp;(valor*<xsl:value-of select="$mult"/>);
	if v &lt; (valor*<xsl:value-of select="$mult"/>) then
		valor = (v + 1) / <xsl:value-of select="$mult"/>;
	else 
		valor = v / <xsl:value-of select="$mult"/>;
	fi;
	   </xsl:when>
	   <xsl:otherwise>
	   </xsl:otherwise>
	</xsl:choose>	

<xsl:if test="$ignora_exclusion_arts='true'">
	publicar_arts_<xsl:value-of select="$index"/> = (buyed - nopromotion);
</xsl:if>
<xsl:if test="$ignora_exclusion_arts='false'">
	publicar_arts_<xsl:value-of select="$index"/> = purchase;
</xsl:if>

	publicar_puntos_<xsl:value-of select="$index"/> = valor;
	<xsl:value-of select="$benef"/> = valor * <xsl:value-of select="$point2benef"/>;
<xsl:if test="$emitir_bono='true'">
	publicar_bono_<xsl:value-of select="$index"/> = <xsl:apply-templates select="bono" mode="val"><xsl:with-param name="valor" select="'valor'"/></xsl:apply-templates>;
</xsl:if>


	pr_arts = $publicar_arts_<xsl:value-of select="$index"/>;
	for (a,k) in publicar_arts_<xsl:value-of select="$index"/> do
		<xsl:value-of select="$beneficiados"/> = <xsl:value-of select="$beneficiados"/> + {(a, valor * (${(a,k)} / pr_arts))};
	od;



<xsl:if test="$excluir='true'">
	<xsl:value-of select="$excluded"/> = <xsl:value-of select="$excluded"/> + 	publicar_arts_<xsl:value-of select="$index"/>;
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
	// Parametros correspondientes a la promo articulo_descuento_<xsl:value-of select="$cod_promo"/>
	extern publicar_arts_<xsl:value-of select="$index"/>;
	extern publicar_puntos_<xsl:value-of select="$index"/>;
<xsl:if test="$emitir_bono='true'">
	extern publicar_bono_<xsl:value-of select="$index"/>;
</xsl:if>
	// -------------------------------- promo articulo_descuento_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>



<xsl:if test="$view='benefits'">
<!-- <<<<<<<<<<<<<< -->
	// Aplicando Beneficios correspondientes a la promo importe_total_puntos_<xsl:value-of select="$cod_promo"/>

	numRNV( ram_acu_puntos ) = numRNV( ram_acu_puntos ) + publicar_puntos_<xsl:value-of select="$index"/>;
<xsl:if test="$emitir_bono='true'">
	issueBonus(publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>

	// Informando eventos

	rec(promoId, <xsl:value-of select="$promo_id"/>, <xsl:value-of select="$cod_externo"/>);

	rec(artsBeneficiary, publicar_arts_<xsl:value-of select="$index"/>);
<xsl:if test="preconditions/bool_perfil='true'">
	rec(perfil, per);
</xsl:if>
<xsl:if test="$emitir_bono='true'">
  //rec(bonusBenefit,publicar_bono_<xsl:value-of select="$index"/>,1);
</xsl:if>


	blog(file, "Promo "++ <xsl:value-of select="$promo_id"/> ++ ": ACTIVA");

<xsl:if test="$msj_monitor_activa='true'">
	print(<xsl:for-each select="mensajes/activa/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>
<xsl:if test="$msj_ticket='true'">
	blog(inticket, <xsl:for-each select="mensajes/activa2/linea">"&amp;<xsl:apply-templates select="."/><xsl:if test="not(position()=last())">"++</xsl:if></xsl:for-each>");
</xsl:if>



	// ------------------------------------------ promo importe_total_puntos_<xsl:value-of select="$cod_promo"/>
<!-- >>>>>>>>>>>>>> -->
</xsl:if>






<xsl:if test="$view='version'">
<xsl:value-of select="$promo_name"/> [Versión: <xsl:value-of select="$promo_version"/>] [Fecha: <xsl:value-of select="$promo_date"/>]
<xsl:call-template name="warningVersions"><xsl:with-param name="compareWith" select="$pc_version"/><xsl:with-param name="verMode" select="$verMode"/></xsl:call-template>
</xsl:if>


	</xsl:template>


 <!-- Implementacion de la funcion pow -->

   <xsl:template name = "pow" >
       <xsl:param name = "base" select = "1" />
       <xsl:param name = "pow" select = "0" />
       <xsl:param name = "tmpResult" select = "1" />

       <xsl:variable name = "result" >
           <xsl:choose>
               <xsl:when test = "$pow >= 0" >
                   <xsl:value-of select = "$tmpResult * $base" />
               </xsl:when>
               <xsl:otherwise>
                   <xsl:value-of select = "$tmpResult div $base" />
               </xsl:otherwise>
           </xsl:choose>
       </xsl:variable>

       <xsl:variable name = "incr" >
           <xsl:choose>
               <xsl:when test = "$pow >= 0" >
                   <xsl:value-of select = "- 1" />
               </xsl:when>
               <xsl:otherwise>
                   <xsl:value-of select = "1" />
               </xsl:otherwise>
           </xsl:choose>
       </xsl:variable>

       <xsl:choose>
           <xsl:when test = "$pow = 0" >
               <xsl:value-of select = "$tmpResult" />
           </xsl:when>
           <xsl:otherwise>
               <xsl:call-template name = "pow" >
                   <xsl:with-param name = "base" select = "$base" />
                   <xsl:with-param name = "pow" select = "$pow + $incr" />
                   <xsl:with-param name = "tmpResult" select = "$result" />
               </xsl:call-template>
           </xsl:otherwise>
       </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
