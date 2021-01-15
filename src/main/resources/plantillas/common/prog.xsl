<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="ISO-8859-1"/>
<xsl:param name="pathProgXml"/>
<!--********************************************************************-->
<!--  Sistema de Plantillas para Generar Promociones                    -->
<!--  Autor: Fabián Ramírez                                             -->
<xsl:variable name="sist_version">1.23.002</xsl:variable>
<xsl:variable name="sist_date">28/02/13</xsl:variable>
<!--                                                                    -->
<!--  Versión del compilador de promociones requerida:                  -->
<xsl:variable name="pc_version">1.11.15.18</xsl:variable>
<!--********************************************************************-->


<!--********************************************************************-->
<!--  Versionado del Sistema de Plantillas para Promociones             -->
<!--  PLANTILLAS: <x>.<xx>.<xxx>                                        -->
<!--  PLANTILLAS: <version>.<subversion>.<build>                        -->
<!--                                                                    -->
<!--  <version>: Por ahora estara fijo en '1'.                          -->
<!--  <subversion>: Se debe incrementar cada vez que se introduzcan     -->
<!--                cambios en el nucleo del sistema de plantillas.     -->
<!--  <build>: Se debe incrementar cada vez que se introduzca cualquier -->
<!--           tipo de cambio/correccion en cualquier plantilla.        -->
<!--                                                                    -->
<!--                                                                    -->
<!--  En <pc_version> se debe registrar tambien la version del          -->
<!--  compilador de promociones que requieren las promociones que       -->
<!--  generan esta version del sistema de plantillas.                   -->
<!--  Recordar que dos compiladores de versiones:                       -->
<!--  - pc_<A1>.<B1>.<C1>.<D1>                                          -->
<!--  - pc_<A2>.<B2>.<C2>.<D2>                                          -->
<!--  son compatibles, si y solo si: <A1> = <A2> y <B1> = <B2>          -->
<!--                                                                    -->
<!--********************************************************************-->




<xsl:include href="types.xsl"/>
<xsl:include href="includes.xsl"/>


<xsl:template match="version">
<xsl:param name="verMode">info</xsl:param>
<xsl:if test="$verMode='info'">
&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"&gt;
&lt;html xmlns="http://www.w3.org/1999/xhtml"&gt;
&lt;head&gt;
  &lt;meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /&gt;
  &lt;title&gt;Plantillas para la Generación de Promociones&lt;/title&gt;
&lt;/head&gt;

&lt;body&gt;
  &lt;h3&gt;Sistema de Plantillas para la Generación de Promociones&lt;/h3&gt;
  &lt;p&gt;<xsl:if test="sist_ver"><xsl:apply-templates select="sist_ver"/></xsl:if>&lt;br/&gt;
  <xsl:if test="sist_date"><xsl:apply-templates select="sist_date"/></xsl:if>&lt;/p&gt;

  &lt;p&gt;<xsl:if test="actual_pc_ver"><xsl:apply-templates select="actual_pc_ver"/></xsl:if>&lt;/p&gt;
  &lt;p&gt;<xsl:if test="pc_ver"><xsl:apply-templates select="pc_ver"/></xsl:if>&lt;/p&gt;

  <xsl:if test="promos_ver">
    &lt;p&gt;Versiones de las Plantillas de Promociones:
      &lt;ol&gt;
        <xsl:for-each select="promos_ver/promo">
          &lt;li&gt;
            <xsl:apply-templates select=".">
              <xsl:with-param name="view">version</xsl:with-param>
            </xsl:apply-templates>
          &lt;/li&gt;
        </xsl:for-each>
      &lt;/ol&gt;
    &lt;/p&gt;
  </xsl:if>
&lt;/body&gt;
&lt;/html&gt;
</xsl:if>
<xsl:if test="not($verMode='info')">
	<xsl:for-each select="promos_ver/promo">
		<xsl:variable name="text1"><xsl:apply-templates select="."><xsl:with-param name="view">version</xsl:with-param><xsl:with-param name="verMode">check</xsl:with-param></xsl:apply-templates></xsl:variable>
	</xsl:for-each>
</xsl:if>
</xsl:template>

<xsl:template match="sist_ver">[Versión: <xsl:value-of select="$sist_version"/>]</xsl:template>

<xsl:template match="sist_date">[Fecha: <xsl:value-of select="$sist_date"/>]</xsl:template>

<xsl:template match="pc_ver">
Versión del Compilador de Promociones Requerida: <xsl:value-of select="$pc_version"/>
<xsl:call-template name="warningVersions">
  <xsl:with-param name="compareWith" select="$pc_version"/>
</xsl:call-template>
</xsl:template>

<xsl:template match="actual_pc_ver">
&lt;p>Versión del Compilador de Promociones en Uso: <xsl:value-of select="."/></xsl:template>

<xsl:variable name="infinito">999999</xsl:variable>
<xsl:variable name="promoConf" select="document($pathProgXml)"/>

<xsl:key name="promoKey" match="promo" use="@posicion"/>

<xsl:key name="blockKey" match="promo" use="@block"/>

<xsl:template name="for">
<xsl:param name="from" />
<xsl:param name="to" />
<xsl:param name="index" />
<xsl:if test="$from &lt;= $to">
	promo_activa_<xsl:value-of select="$index"/>_<xsl:value-of select="$from"/> = false;
<xsl:call-template name="for">
  <xsl:with-param name="from" select="$from+1"/>
  <xsl:with-param name="to" select="$to"/>
  <xsl:with-param name="index" select="$index"/>
</xsl:call-template>
</xsl:if>
</xsl:template>





<xsl:template name="ver_token">
<xsl:param name="ver" />
<xsl:param name="pos" />

<xsl:if test="$pos=0">
	<xsl:if test="contains($ver,'.')">
		<xsl:value-of select="substring-before($ver,'.')"/>
	</xsl:if>
	<xsl:if test="not(contains($ver,'.'))">
		<xsl:value-of select="$ver"/>
	</xsl:if>
</xsl:if>

<xsl:if test="$pos&gt;0">
	<xsl:variable name="temp" select="concat(substring-before($ver,'.'),'.')" />
	<xsl:call-template name="ver_token">
	  <xsl:with-param name="ver"><xsl:value-of select="substring-after($ver,$temp)"/></xsl:with-param>
	  <xsl:with-param name="pos" select="$pos -1"/>
	</xsl:call-template>
</xsl:if>
</xsl:template>






<xsl:template name="checkVersions">
<xsl:variable name="promosVersions" select="document('version.xml')"/>
<xsl:apply-templates select="$promosVersions/version">
	<xsl:with-param name="verMode">check</xsl:with-param>
</xsl:apply-templates>
</xsl:template>

<xsl:template name="warningVersions">
<xsl:param name="compareWith" />
<xsl:param name="verMode">info</xsl:param>
<xsl:variable name="verPC"><xsl:value-of select="/version/actual_pc_ver"/></xsl:variable>
<xsl:variable name="a1"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$verPC"/><xsl:with-param name="pos" select="0"/></xsl:call-template></xsl:variable>
<xsl:variable name="b1"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$verPC"/><xsl:with-param name="pos" select="1"/></xsl:call-template></xsl:variable>
<xsl:variable name="c1"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$verPC"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable>
<xsl:variable name="d1"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$verPC"/><xsl:with-param name="pos" select="3"/></xsl:call-template></xsl:variable>
<xsl:variable name="a2"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$compareWith"/><xsl:with-param name="pos" select="0"/></xsl:call-template></xsl:variable>
<xsl:variable name="b2"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$compareWith"/><xsl:with-param name="pos" select="1"/></xsl:call-template></xsl:variable>
<xsl:variable name="c2"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$compareWith"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable>
<xsl:variable name="d2"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$compareWith"/><xsl:with-param name="pos" select="3"/></xsl:call-template></xsl:variable>

<xsl:if test="($a1=$a2)and($b1&gt;=$b2)and($c1&gt;=$c2)"></xsl:if>
<xsl:if test="not(($a1=$a2)and($b1&gt;=$b2)and($c1&gt;=$c2))">&lt;font color="red">  -  Advertencia: La version del compilador de promociones actual no satisface la version requerida.&lt;/font>
	<xsl:if test="$verMode='check'">
		<xsl:message terminate='yes'>ERROR: Version del Compilador de Promociones Incorrecta.</xsl:message>
	</xsl:if>
	<xsl:if test="$verMode='info'">
		<xsl:message terminate='no'>ERROR: Version del Compilador de Promociones Incorrecta.</xsl:message>
	</xsl:if>
</xsl:if>
</xsl:template>




	<xsl:template match="root">
	<xsl:call-template name="checkVersions"/>
// PROMOCIONES GENERADAS CON VERSION DEL SISTEMA DE PLANTILLAS Nro: <xsl:value-of select="$sist_version"/> - (<xsl:value-of select="$sist_date"/>)

		// ************************ Inicializacion Promos PRE-PAGO ************************ //
Promotion prepago prepago_init
Parameters
	global wpurch = 0;
	global excluidos = {};
	global excluir = false;
	global beneficios = 0;
	global beneficiados = {};
	global tarjeta = "";
	global per = 0;
//	global dinero_ahorrado = 0;
  global primera_vez = true;
	global anteriores = {};

  <!--xsl:for-each select="$promoConf/prog/promo[@promotype='medios_descuento_ticket']">
    <xsl:sort select="@block" data-type='number'/>
    <xsl:if test="not(preceding-sibling::promo[1]/@block = @block)">
	global monto_benef_promo65_block<xsl:value-of select="@block"/> = 0;
    </xsl:if>
	</xsl:for-each-->
	global monto_benef_promo65 = 0;
  <xsl:for-each select="$promoConf/prog/promo[@promotype='medios_descuento_ticket']">
    <xsl:sort select="preconditions/perfil" data-type='number'/>
    <xsl:if test="not(preceding-sibling::promo/preconditions/perfil = preconditions/perfil)">
	global monto_benef_promo65_perfil<xsl:value-of select="preconditions/perfil"/> = 0;
    </xsl:if>
  </xsl:for-each>

Benefits
	wpurch = $wholepurchase;
	excluidos = excluded;
	tarjeta = stringRNV(ram_cuenta_cliente);
	per = numRNV(ram_perfil);

		<xsl:for-each select="promo">
			<xsl:variable name="competencia" select="compiten"/>
			<xsl:variable name="eleccion" select="eleccion"/>
			  <xsl:variable name="ignora" select="ignora_exclusion"/>
			  <xsl:variable name="excluye" select="excluye"/>
			<xsl:apply-templates select=".">
				<xsl:with-param name="index"><xsl:value-of select="@id"/></xsl:with-param>
				<xsl:with-param name="eval"><xsl:value-of select="@eval"/></xsl:with-param>
				<xsl:with-param name="view">main</xsl:with-param>
				<xsl:with-param name="excluded">excluidos</xsl:with-param>
				<xsl:with-param name="benef">beneficios</xsl:with-param>
				<xsl:with-param name="beneficiados">beneficiados</xsl:with-param>
				<xsl:with-param name="competencia"><xsl:value-of select="compiten"/></xsl:with-param>
				<xsl:with-param name="eleccion"><xsl:value-of select="eleccion"/></xsl:with-param>

				<xsl:with-param name="cash2benef"><xsl:value-of select="coefs/cash"/></xsl:with-param>
				<xsl:with-param name="point2benef"><xsl:value-of select="coefs/point"/></xsl:with-param>
				<xsl:with-param name="cupon2benef"><xsl:value-of select="coefs/cupon"/></xsl:with-param>
				<xsl:with-param name="bono2benef"><xsl:value-of select="coefs/bono"/></xsl:with-param>
				<xsl:with-param name="medio2benef"><xsl:value-of select="coefs/medio"/></xsl:with-param>
		    <xsl:with-param name="parametros">
	extern excluir;
		    </xsl:with-param>
		    <xsl:with-param name="condiciones">
		    	<xsl:if test="ignora_exclusion='false'">
	!excluir;
		    	</xsl:if>
		    </xsl:with-param>
		    <xsl:with-param name="beneficios">
				  		<xsl:if test="$competencia!='true'">
	if beneficios > 0 then
		excluir = true;
	else
		skip;
	fi;
				  		</xsl:if>
				    </xsl:with-param>
			</xsl:apply-templates>

Promotion <xsl:value-of select="@eval"/> fin_bloque_raiz_<xsl:value-of select="@id"/>
Parameters
			<xsl:apply-templates select=".">
				<xsl:with-param name="index"><xsl:value-of select="@id"/></xsl:with-param>
				<xsl:with-param name="eval"><xsl:value-of select="@eval"/></xsl:with-param>
				<xsl:with-param name="view">parameters</xsl:with-param>
				<xsl:with-param name="excluded">excluidos</xsl:with-param>
				<xsl:with-param name="benef">beneficios</xsl:with-param>
				<xsl:with-param name="competencia"><xsl:value-of select="compiten"/></xsl:with-param>
				<xsl:with-param name="eleccion"><xsl:value-of select="eleccion"/></xsl:with-param>
		    <xsl:with-param name="parametros">
	extern excluir;
		    </xsl:with-param>
		    <xsl:with-param name="condiciones">
		    	<xsl:if test="ignora_exclusion='false'">
	!excluir;
		    	</xsl:if>
		    </xsl:with-param>
		    <xsl:with-param name="beneficios">
				  		<xsl:if test="$competencia!='true'">
	if beneficios > 0 then
		excluir = true;
	else
		skip;
	fi;
				  		</xsl:if>
				    </xsl:with-param>
			</xsl:apply-templates>
	extern per;
	extern tarjeta;
//	extern dinero_ahorrado;

Benefits
			<xsl:apply-templates select=".">
				<xsl:with-param name="index"><xsl:value-of select="@id"/></xsl:with-param>
				<xsl:with-param name="eval"><xsl:value-of select="@eval"/></xsl:with-param>
				<xsl:with-param name="view">benefits</xsl:with-param>
				<xsl:with-param name="excluded">excluidos</xsl:with-param>
				<xsl:with-param name="benef">beneficios</xsl:with-param>
				<xsl:with-param name="beneficiados">beneficiados</xsl:with-param>
				<xsl:with-param name="competencia"><xsl:value-of select="compiten"/></xsl:with-param>
				<xsl:with-param name="eleccion"><xsl:value-of select="eleccion"/></xsl:with-param>

				<xsl:with-param name="cash2benef"><xsl:value-of select="coefs/cash"/></xsl:with-param>
				<xsl:with-param name="point2benef"><xsl:value-of select="coefs/point"/></xsl:with-param>
				<xsl:with-param name="cupon2benef"><xsl:value-of select="coefs/cupon"/></xsl:with-param>
				<xsl:with-param name="bono2benef"><xsl:value-of select="coefs/bono"/></xsl:with-param>
				<xsl:with-param name="medio2benef"><xsl:value-of select="coefs/medio"/></xsl:with-param>
		    <xsl:with-param name="parametros">
	extern excluir;
		    </xsl:with-param>
		    <xsl:with-param name="condiciones">
		    	<xsl:if test="ignora_exclusion='false'">
	!excluir;
		    	</xsl:if>
		    </xsl:with-param>
		    <xsl:with-param name="beneficios">
				  		<xsl:if test="$competencia!='true'">
	if beneficios > 0 then
		excluir = true;
	else
		skip;
	fi;
				  		</xsl:if>
				    </xsl:with-param>
			</xsl:apply-templates>
	<xsl:if test="@id='0'">
//	Si se acumularon descuentos, se imprime el mensaje apropiado.
//	if dinero_ahorrado > 0 then
//		if log(total, "REBAJADO UD. AHORRO $"++dinero_ahorrado) then skip; else skip; fi;
//	else skip; fi;
	</xsl:if>

	skip;

		</xsl:for-each>
	</xsl:template>



	<xsl:template match="promos">
		<xsl:apply-templates/>
	  <xsl:variable name="promoBlock" select="@block"/>
	</xsl:template>







<xsl:template match="promo[@promotype='block']">
  <xsl:param name="index">0</xsl:param>
  <xsl:param name="view">main</xsl:param>
  <xsl:param name="eval">prepago</xsl:param>
  <xsl:param name="competencia">null</xsl:param>
  <xsl:param name="eleccion">null</xsl:param>
  <xsl:param name="excluded">excluidos</xsl:param>
  <xsl:param name="benef">benef</xsl:param>
  <xsl:param name="beneficiados">beneficiados</xsl:param>
  <xsl:param name="parametros"></xsl:param>
  <xsl:param name="condiciones"></xsl:param>
  <xsl:param name="beneficios">skip;</xsl:param>
  <xsl:param name="cash2benef"></xsl:param>
  <xsl:param name="point2benef"></xsl:param>
  <xsl:param name="cupon2benef"></xsl:param>
  <xsl:param name="bono2benef"></xsl:param>
  <xsl:param name="medio2benef"></xsl:param>

  <xsl:variable name="promoBlock" select="@id"/>
  <xsl:variable name="cash2b"><xsl:if test="coefs/cash"><xsl:value-of select="coefs/cash"/></xsl:if><xsl:if test="not(coefs/cash)"><xsl:value-of select="$cash2benef"/></xsl:if></xsl:variable>
  <xsl:variable name="point2b"><xsl:if test="coefs/point"><xsl:value-of select="coefs/point"/></xsl:if><xsl:if test="not(coefs/point)"><xsl:value-of select="$point2benef"/></xsl:if></xsl:variable>
  <xsl:variable name="cupon2b"><xsl:if test="coefs/cupon"><xsl:value-of select="coefs/cupon"/></xsl:if><xsl:if test="not(coefs/cupon)"><xsl:value-of select="$cupon2benef"/></xsl:if></xsl:variable>
  <xsl:variable name="bono2b"><xsl:if test="coefs/bono"><xsl:value-of select="coefs/bono"/></xsl:if><xsl:if test="not(coefs/bono)"><xsl:value-of select="$bono2benef"/></xsl:if></xsl:variable>
  <xsl:variable name="medio2b"><xsl:if test="coefs/medio"><xsl:value-of select="coefs/medio"/></xsl:if><xsl:if test="not(coefs/medio)"><xsl:value-of select="$medio2benef"/></xsl:if></xsl:variable>


<xsl:if test="($view='main') or ($view='prepago') or ($view='postpago')">

  // ******  INICIO BLOQUE **************************************************************** //
  // ******  BLOQUE NAME = <xsl:apply-templates select="name"/>
  // ******  BLOQUE ID = <xsl:value-of select="$promoBlock"/>
  // ******  CASH2BENEF = <xsl:value-of select="$cash2benef"/>


//************** BLOQUE DE PROMOCIONES ********************
// Seccion Inicial

Promotion <xsl:value-of select="$eval"/> bloque_seccion_inicial_<xsl:value-of select="$index"/>

// Description:

Parameters
<xsl:value-of select="$parametros"/>
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$benef"/>;
	extern <xsl:value-of select="$beneficiados"/>;
	global excluir_<xsl:value-of select="$index"/> = false;


	  <xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>
  global benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> = 0;
<xsl:if test="$competencia='true'">
  global excluidos_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> = {};
  global beneficiados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> = {};
</xsl:if>
	    </xsl:for-each>
	  </xsl:for-each>

Conditions
<xsl:value-of select="$condiciones"/>

Benefits

	  <xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>
<xsl:if test="$competencia='true'">
  excluidos_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> = <xsl:value-of select="$excluded"/>;
  beneficiados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> = <xsl:value-of select="$beneficiados"/>;
</xsl:if>
	    </xsl:for-each>
	  </xsl:for-each>

  skip;


  // ********  PROMOCIONES DEL BLOQUE <xsl:value-of select="$promoBlock"/> **************************************************** //


	  <xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>
			  <xsl:variable name="ignora" select="ignora_exclusion"/>
			  <xsl:variable name="excluye" select="excluye"/>
					<xsl:apply-templates select=".">
				    <xsl:with-param name="index"><xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
				    <xsl:with-param name="eval"><xsl:value-of select="$eval"/></xsl:with-param>
				    <xsl:with-param name="view">main</xsl:with-param>
				    <xsl:with-param name="competencia"><xsl:value-of select="compiten"/></xsl:with-param>
				    <xsl:with-param name="eleccion"><xsl:value-of select="eleccion"/></xsl:with-param>
				    <xsl:with-param name="excluded"><xsl:if test="$competencia='true'">excluidos_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:if><xsl:if test="$competencia!='true'"><xsl:value-of select="$excluded"/></xsl:if></xsl:with-param>
				    <xsl:with-param name="beneficiados"><xsl:if test="$competencia='true'">beneficiados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:if><xsl:if test="$competencia!='true'"><xsl:value-of select="$beneficiados"/></xsl:if></xsl:with-param>

					<xsl:with-param name="cash2benef"><xsl:value-of select="$cash2b"/></xsl:with-param>
					<xsl:with-param name="point2benef"><xsl:value-of select="$point2b"/></xsl:with-param>
					<xsl:with-param name="cupon2benef"><xsl:value-of select="$cupon2b"/></xsl:with-param>
					<xsl:with-param name="bono2benef"><xsl:value-of select="$bono2b"/></xsl:with-param>
					<xsl:with-param name="medio2benef"><xsl:value-of select="$medio2b"/></xsl:with-param>

				    <xsl:with-param name="parametros">
<!--// Heredados del Grupo -->
<xsl:value-of select="$parametros"/>

	extern excluir_<xsl:value-of select="$index"/>;
//	extern <xsl:if test="$competencia='true'">beneficiados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:if><xsl:if test="$competencia!='true'"><xsl:value-of select="$beneficiados"/></xsl:if>;
				    </xsl:with-param>
				    <xsl:with-param name="condiciones">
<!--// Heredadas del Grupo -->
<xsl:value-of select="$condiciones"/>

<!--// PADRE IGNORA : <xsl:value-of select="$ignora"/>
// ME    IGNORA : <xsl:value-of select="ignora_exclusion"/>-->
		    	<xsl:if test="$ignora='false'">
	!excluir_<xsl:value-of select="$index"/>;
		    	</xsl:if>
				    </xsl:with-param>
				    <xsl:with-param name="beneficios">
				  		<xsl:if test="$competencia!='true' and $excluye='true'">
	if benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> > 0 then
		excluir_<xsl:value-of select="$index"/> = true;
	else
		skip;
	fi;
				  		</xsl:if>
				    </xsl:with-param>
				    <xsl:with-param name="benef">benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
					</xsl:apply-templates>

// FIN DE PROMO <xsl:value-of select="position()-1"/> del BLOQUE <xsl:value-of select="$index"/>

Promotion <xsl:value-of select="$eval"/> undo_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>
<xsl:if test="$competencia='true'">// DE COMPETENCIA</xsl:if>
Parameters
//	extern <xsl:if test="$competencia!='true'">excluidos_<xsl:value-of select="$index"/></xsl:if><xsl:if test="$competencia='true'"><xsl:value-of select="$excluded"/></xsl:if>;
	extern <xsl:value-of select="$excluded"/>;
Conditions
Benefits
//	excluded = <xsl:if test="$competencia!='true'">excluidos_<xsl:value-of select="$index"/></xsl:if><xsl:if test="$competencia='true'"><xsl:value-of select="$excluded"/></xsl:if>;
	excluded = <xsl:value-of select="$excluded"/>;
	skip;

// --- *** ---


	    </xsl:for-each>
	  </xsl:for-each>




  // ********  FIN BLOQUE <xsl:value-of select="$promoBlock"/> *************************************************************** //
//************** BLOOQUE DE PROMOCIONES ********************
// Seccion Final

Promotion <xsl:value-of select="$eval"/> bloque_seccion_final_<xsl:value-of select="$index"/>

// Description: COMPITEN = <xsl:value-of select="$competencia"/>

Parameters
<xsl:value-of select="$parametros"/>
<!--xsl:if test="$competencia!='true'">
	extern <xsl:value-of select="$excluded"/>;</xsl:if-->
	extern <xsl:value-of select="$excluded"/>;
	extern <xsl:value-of select="$beneficiados"/>;
	extern <xsl:value-of select="$benef"/>;
//	extern per;
//	extern tarjeta;

	  <xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>
			  <xsl:variable name="ignora" select="ignora_exclusion"/>
			  <xsl:variable name="excluye" select="excluye"/>
<xsl:if test="$competencia='true'">
	extern excluidos_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;
	extern beneficiados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;</xsl:if>
  global promo_activa_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> = false;
  extern benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;
	<!--xsl:apply-templates select=".">
    <xsl:with-param name="index"><xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
    <xsl:with-param name="view">parameters</xsl:with-param>
	</xsl:apply-templates-->
					<xsl:apply-templates select=".">
				    <xsl:with-param name="index"><xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
				    <xsl:with-param name="eval"><xsl:value-of select="$eval"/></xsl:with-param>
				    <xsl:with-param name="view">parameters</xsl:with-param>
				    <xsl:with-param name="competencia"><xsl:value-of select="compiten"/></xsl:with-param>
				    <xsl:with-param name="eleccion"><xsl:value-of select="eleccion"/></xsl:with-param>
				    <xsl:with-param name="excluded"><xsl:if test="$competencia='true'">excluidos_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:if><xsl:if test="$competencia!='true'"><xsl:value-of select="$excluded"/></xsl:if></xsl:with-param>
				    <xsl:with-param name="parametros">
	extern excluir_<xsl:value-of select="$index"/>;
				    </xsl:with-param>
				    <xsl:with-param name="condiciones">
// IGNORA : <xsl:value-of select="$ignora"/>

		    	<xsl:if test="$ignora='false'">
	!excluir_<xsl:value-of select="$index"/>;
		    	</xsl:if>
				    </xsl:with-param>
				    <xsl:with-param name="beneficios">
				  		<xsl:if test="$competencia!='true' and $excluye='true'">
	if benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> > 0 then
		excluir_<xsl:value-of select="$index"/> = true;
	else
		skip;
	fi;
				  		</xsl:if>
				    </xsl:with-param>
				    <xsl:with-param name="benef">benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
					</xsl:apply-templates>

	    </xsl:for-each>
	  </xsl:for-each>

Conditions
// -----------------------------------------------
<xsl:value-of select="$condiciones"/>
// -----------------------------------------------

Benefits

<xsl:if test="$competencia='true'">

// Buscando el <xsl:if test="$eleccion='mayor'">MEJOR</xsl:if><xsl:if test="$eleccion='menor'">PEOR</xsl:if> beneficio
<xsl:if test="$eleccion='mayor'">
	benef = 0;
</xsl:if>
<xsl:if test="$eleccion='menor'">
	benef = <xsl:value-of select="$infinito"/>;
</xsl:if>
	  <xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>
<xsl:if test="$eleccion='mayor'">
	if benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> > benef then
</xsl:if>
<xsl:if test="$eleccion='menor'">
	if ( benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> > 0 ) &amp;&amp; ( benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> &lt; benef ) then
</xsl:if>
<!--xsl:for-each select="$numeros/nums/n">
  <xsl:if test="$subindex>=position()">		promo_activa_<xsl:value-of select="$index"/>_<xsl:number value="position()-1"/> = false;
</xsl:if></xsl:for-each-->
<xsl:call-template name="for">
  <xsl:with-param name="from" select="0"/>
  <xsl:with-param name="to"><xsl:value-of select="$subindex"/></xsl:with-param>
  <xsl:with-param name="index"><xsl:value-of select="$index"/></xsl:with-param>
</xsl:call-template>
		promo_activa_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> = true;
		benef = benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;
	else
		skip;
	fi;
	    </xsl:for-each>
	  </xsl:for-each>
// ---------------------------

// Aplicando efectos secundarios del <xsl:if test="$eleccion='mayor'">MEJOR</xsl:if><xsl:if test="$eleccion='menor'">PEOR</xsl:if> beneficio

		  <xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>
	if promo_activa_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> then
		<xsl:value-of select="$excluded"/> = excluidos_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;
		<xsl:value-of select="$beneficiados"/> = beneficiados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;
	else
		skip;
	fi;
	    </xsl:for-each>
	  </xsl:for-each>
// -------------------------------------------------
<xsl:if test="$eleccion='mayor'">
	<xsl:value-of select="$benef"/> = benef;
</xsl:if>
<xsl:if test="$eleccion='menor'">
	<xsl:value-of select="$benef"/> = ( benef &lt; <xsl:value-of select="$infinito"/> ? benef : 0 );
</xsl:if>
// -------------------------------------------------

</xsl:if>

<xsl:if test="$competencia!='true'">
	// Promos NO Compiten - SUMANDO LOS BENEFICIOS DE TODAS

	benef = 0;
	  <xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>

	if benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> > 0 then
		promo_activa_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> = true;
		benef = benef + benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;
	else skip; fi;
		    </xsl:for-each>
		  </xsl:for-each>
	skip;
	// ----------------------------------------------------
	<xsl:value-of select="$benef"/> = benef;
	// -------------------------------------------------

</xsl:if>

<!--
// Y cOmo manejo la propagaciOn de EXCLUCIONES???
	  <xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>
	excluir_<xsl:value-of select="$index"/> = excluir_<xsl:value-of select="$index"/> || excluir_<xsl:value-of select="$index"/>;
		    </xsl:for-each>
		  </xsl:for-each>
-->
// Aplicando los Beneficios que vienen por parametro
<xsl:value-of select="$beneficios"/>
// -------------------------------------------------


</xsl:if>








<xsl:if test="$view='parameters'">
	// Parametros correspondientes al bloque_<xsl:value-of select="$index"/>

<!--xsl:if test="$competencia!='true' and $excluded!='excluidos'">
	extern <xsl:value-of select="$excluded"/>;</xsl:if-->
<!--xsl:if test="$benef!='beneficios'">
	extern <xsl:value-of select="$benef"/>;</xsl:if-->

	  <xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>
			  <xsl:variable name="ignora" select="ignora_exclusion"/>
			  <xsl:variable name="excluye" select="excluye"/>
<xsl:if test="$competencia='true'">
	extern excluidos_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;
//  extern benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;</xsl:if>
	extern promo_activa_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;
	<!--xsl:apply-templates select=".">
    <xsl:with-param name="index"><xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
    <xsl:with-param name="view">parameters</xsl:with-param>
	</xsl:apply-templates-->
					<xsl:apply-templates select=".">
				    <xsl:with-param name="index"><xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
				    <xsl:with-param name="eval"><xsl:value-of select="$eval"/></xsl:with-param>
				    <xsl:with-param name="view">parameters</xsl:with-param>
				    <xsl:with-param name="competencia"><xsl:value-of select="compiten"/></xsl:with-param>
				    <xsl:with-param name="eleccion"><xsl:value-of select="eleccion"/></xsl:with-param>
				    <xsl:with-param name="excluded"><xsl:if test="$competencia='true'">excluidos_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:if><xsl:if test="$competencia!='true'"><xsl:value-of select="$excluded"/></xsl:if></xsl:with-param>
				    <xsl:with-param name="parametros">
	extern excluir_<xsl:value-of select="$index"/>;
				    </xsl:with-param>
				    <xsl:with-param name="condiciones">
// IGNORA : <xsl:value-of select="$ignora"/>

		    	<xsl:if test="$ignora='false'">
	!excluir_<xsl:value-of select="$index"/>;
		    	</xsl:if>
				    </xsl:with-param>
				    <xsl:with-param name="beneficios">
				  		<xsl:if test="$competencia!='true'">
	if benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> > 0 then
		excluir_<xsl:value-of select="$index"/> = true;
	else
		skip;
	fi;
				  		</xsl:if>
				    </xsl:with-param>
				    <xsl:with-param name="benef">benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
					</xsl:apply-templates>

	    </xsl:for-each>
	  </xsl:for-each>

	  <!--xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>
<xsl:if test="$competencia='true'">
  extern promo_activa_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;
  extern excluidos_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/>;
</xsl:if>
	    </xsl:for-each>
	  </xsl:for-each-->

	// ---------- ---------------- -- bloque_<xsl:value-of select="$index"/>
</xsl:if>












<xsl:if test="$view='benefits'">
	// Aplicando Beneficios correspondientes al bloque_<xsl:value-of select="$index"/>

// BENEFICIO -> COMPETENCIA = <xsl:value-of select="$competencia"/>

<xsl:if test="$competencia='true'">
// Aplicando el MEJOR Beneficio

		  <xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>
			  <xsl:variable name="ignora" select="ignora_exclusion"/>
			  <xsl:variable name="excluye" select="excluye"/>
	if promo_activa_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> then
					<!--xsl:apply-templates select=".">
				    <xsl:with-param name="index"><xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
				    <xsl:with-param name="view">benefits</xsl:with-param>
					</xsl:apply-templates-->
					<xsl:apply-templates select=".">
				    <xsl:with-param name="index"><xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
				    <xsl:with-param name="eval"><xsl:value-of select="$eval"/></xsl:with-param>
				    <xsl:with-param name="view">benefits</xsl:with-param>
				    <xsl:with-param name="competencia"><xsl:value-of select="compiten"/></xsl:with-param>
				    <xsl:with-param name="eleccion"><xsl:value-of select="eleccion"/></xsl:with-param>
				    <xsl:with-param name="excluded"><xsl:if test="$competencia='true'">excluidos_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:if><xsl:if test="$competencia!='true'"><xsl:value-of select="$excluded"/></xsl:if></xsl:with-param>
				    <xsl:with-param name="parametros">
	extern excluir_<xsl:value-of select="$index"/>;
				    </xsl:with-param>
				    <xsl:with-param name="condiciones">
// IGNORA : <xsl:value-of select="$ignora"/>

		    	<xsl:if test="$ignora='false'">
	!excluir_<xsl:value-of select="$index"/>;
		    	</xsl:if>
				    </xsl:with-param>
				    <xsl:with-param name="beneficios">
				  		<xsl:if test="$competencia!='true'">
	if benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> > 0 then
		excluir_<xsl:value-of select="$index"/> = true;
	else
		skip;
	fi;
				  		</xsl:if>
				    </xsl:with-param>
				    <xsl:with-param name="benef">benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
					</xsl:apply-templates>

		skip;
	else
		skip;
	fi;
	    </xsl:for-each>
	  </xsl:for-each>
// ----------------------------
</xsl:if>

<xsl:if test="$competencia!='true'">
// Aplicando TODOS los Beneficios

		  <xsl:for-each select="$promoConf">
	    <xsl:for-each select="key('blockKey',$promoBlock)">
	    <xsl:sort select="@priority" data-type='number'/>
			  <xsl:variable name="subindex"><xsl:value-of select="position()-1"/></xsl:variable>
			  <xsl:variable name="ignora" select="ignora_exclusion"/>
			  <xsl:variable name="excluye" select="excluye"/>
	if promo_activa_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> then
					<!--xsl:apply-templates select=".">
				    <xsl:with-param name="index"><xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
				    <xsl:with-param name="view">benefits</xsl:with-param>
					</xsl:apply-templates-->
					<xsl:apply-templates select=".">
				    <xsl:with-param name="index"><xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
				    <xsl:with-param name="eval"><xsl:value-of select="$eval"/></xsl:with-param>
				    <xsl:with-param name="view">benefits</xsl:with-param>
				    <xsl:with-param name="competencia"><xsl:value-of select="compiten"/></xsl:with-param>
				    <xsl:with-param name="eleccion"><xsl:value-of select="eleccion"/></xsl:with-param>
				    <xsl:with-param name="excluded"><xsl:if test="$competencia='true'">excluidos_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:if><xsl:if test="$competencia!='true'"><xsl:value-of select="$excluded"/></xsl:if></xsl:with-param>
				    <xsl:with-param name="parametros">
	extern excluir_<xsl:value-of select="$index"/>;
				    </xsl:with-param>
				    <xsl:with-param name="condiciones">
// IGNORA : <xsl:value-of select="$ignora"/>

		    	<xsl:if test="$ignora='false'">
	!excluir_<xsl:value-of select="$index"/>;
		    	</xsl:if>
				    </xsl:with-param>
				    <xsl:with-param name="beneficios">
				  		<xsl:if test="$competencia!='true'">
	if benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/> > 0 then
		excluir_<xsl:value-of select="$index"/> = true;
	else
		skip;
	fi;
				  		</xsl:if>
				    </xsl:with-param>
				    <xsl:with-param name="benef">benefits_otorgados_<xsl:value-of select="$index"/>_<xsl:value-of select="$subindex"/></xsl:with-param>
					</xsl:apply-templates>
		skip;
	else skip; fi;

	    </xsl:for-each>
	  </xsl:for-each>
// -----------------------------

</xsl:if>
	// --------- ---------- ---------------- -- bloque_<xsl:value-of select="$index"/>

</xsl:if>


</xsl:template>


<xsl:template match="promo[@promotype='global_config']">
  <xsl:param name="index">0</xsl:param>
  <xsl:param name="view">main</xsl:param>
  <xsl:param name="eval">prepago</xsl:param>
  <xsl:param name="competencia">null</xsl:param>
  <xsl:param name="eleccion">null</xsl:param>
  <xsl:param name="excluded">excluidos</xsl:param>
  <xsl:param name="benef">benef</xsl:param>
  <xsl:param name="beneficiados">beneficiados</xsl:param>
  <xsl:param name="parametros"></xsl:param>
  <xsl:param name="condiciones"></xsl:param>
  <xsl:param name="beneficios">skip;</xsl:param>
  <xsl:param name="cash2benef"></xsl:param>
  <xsl:param name="point2benef"></xsl:param>
  <xsl:param name="cupon2benef"></xsl:param>
  <xsl:param name="bono2benef"></xsl:param>
  <xsl:param name="medio2benef"></xsl:param>
<xsl:if test="$view='main'">
		// ************************ CONFIGURACIONES MOTOR DE PROMOCIONES ************************ //
Promotion prepago global_config
Benefits
	numRNV(cupon_error) = <xsl:apply-templates select="cupon_error"/>;
	numRNV(cupon_vigencia) = <xsl:apply-templates select="cupon_error_vigencia"/>;
	stringRNV(cupon_limite) = "<xsl:apply-templates select="cupon_error_limite"/>";
</xsl:if>
</xsl:template>


</xsl:stylesheet>

