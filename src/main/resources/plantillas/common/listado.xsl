<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="ISO-8859-1"/>

<xsl:include href="includes.xsl"/>
<xsl:variable name="promosVersions" select="document('version.xml')"/>

<xsl:variable name="predef" select="document('tree.xml')"/>
<xsl:variable name="promos" select="."/>


<xsl:template match="prog">
&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"&gt;
&lt;html xmlns="http://www.w3.org/1999/xhtml"&gt;
&lt;head&gt;
	&lt;meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /&gt;
	&lt;title&gt;Programa de Promociones&lt;/title&gt;
&lt;/head&gt;

&lt;body&gt;
	&lt;h3&gt;Programa de Promociones&lt;/h3&gt;
	&lt;h3&gt;
		<xsl:call-template name="arbol"/>
	&lt;/h3&gt;

	&lt;ul&gt;
	<xsl:for-each select="$predef/root/promo">
	<xsl:sort select="@priority" data-type='number'/>
	&lt;li&gt;
		&lt;h4&gt;
			[<xsl:value-of select="@id"/>] <xsl:value-of select="name"/>

			<xsl:if test="@promotype='block'">
				<xsl:if test="compiten='true'"> - Bloque de Competencia.
					<xsl:if test="eleccion='mayor'">Se aplica la promoción que otorgue el MAYOR beneficio.</xsl:if>
					<xsl:if test="eleccion='menor'">Se aplica la promoción que otorgue el MENOR beneficio.</xsl:if>
				</xsl:if>
				<xsl:if test="compiten!='true'"> - Bloque Secuencial</xsl:if>
			</xsl:if>

			<xsl:if test="@promotype!='block'"> - (
		      		<xsl:apply-templates select=".">
					<xsl:with-param name="view">version</xsl:with-param>
					<xsl:with-param name="verMode">info</xsl:with-param>
		      		</xsl:apply-templates>)
			</xsl:if>
		&lt;/h4&gt;

		&lt;p&gt;
			<xsl:if test="excluye='true'">
				EXCLUYE las próximas promociones de este mismo bloque.
			</xsl:if>

			<xsl:if test="excluye!='true'">
				NO EXCLUYE las próximas promociones de este mismo bloque.
			</xsl:if>

			<xsl:if test="ignora_exclusion='true'">
				Se IGNORA la exclusión de las promociones previas de este mismo bloque.
			</xsl:if>

			<xsl:if test="ignora_exclusion!='true'">
				Se ACATA la exclusión de las promociones previas de este mismo bloque.
			</xsl:if>
		&lt;/p&gt;

		<xsl:if test="@promotype='block'">
	      		<xsl:apply-templates select=".">
				<xsl:with-param name="view">version</xsl:with-param>
				<xsl:with-param name="verMode">info</xsl:with-param>
	      		</xsl:apply-templates>
		</xsl:if>
	&lt;/li&gt;
	</xsl:for-each>
	&lt;/ul&gt;

&lt;/body&gt;
&lt;/html&gt;
</xsl:template>


<xsl:template match="promo[@promotype='block']">
&lt;ul&gt;
<xsl:for-each select="$promos/prog/promo[@block=current()/@id]">
<xsl:sort select="@priority" data-type='number'/>
&lt;li&gt;
	&lt;h4&gt;
		[<xsl:value-of select="@id"/>] <xsl:value-of select="name"/>

					<xsl:if test="@promotype='block'">
						<xsl:if test="compiten='true'"> - Bloque de Competencia.
							<xsl:if test="eleccion='mayor'">Se aplica la promoción que otorgue el MAYOR beneficio.</xsl:if>
							<xsl:if test="eleccion='menor'">Se aplica la promoción que otorgue el MENOR beneficio.</xsl:if>
						</xsl:if>
						<xsl:if test="compiten!='true'"> - Bloque Secuencial</xsl:if>
					</xsl:if>

					<xsl:if test="@promotype!='block'"> - (
	      		<xsl:apply-templates select=".">
							<xsl:with-param name="view">version</xsl:with-param>
							<xsl:with-param name="verMode">info</xsl:with-param>
	      		</xsl:apply-templates>)
					</xsl:if>

	&lt;/h4&gt;

	&lt;p&gt;
		<xsl:if test="excluye='true'">
			EXCLUYE las próximas promociones de este mismo bloque.
		</xsl:if>

		<xsl:if test="excluye!='true'">
			NO EXCLUYE las próximas promociones de este mismo bloque.
		</xsl:if>

		<xsl:if test="ignora_exclusion='true'">
			Se IGNORA la exclusión de las promociones previas de este mismo bloque.
		</xsl:if>

		<xsl:if test="ignora_exclusion!='true'">
			Se ACATA la exclusión de las promociones previas de este mismo bloque.
		</xsl:if>
	&lt;/p&gt;

	<xsl:if test="@promotype='block'">
		<xsl:apply-templates select=".">
			<xsl:with-param name="view">version</xsl:with-param>
			<xsl:with-param name="verMode">info</xsl:with-param>
		</xsl:apply-templates>
	</xsl:if>
&lt;/li&gt;
</xsl:for-each>
&lt;/ul&gt;
</xsl:template>


<xsl:template match="promo">Desconocido</xsl:template>


<xsl:template name="warningVersions">
<xsl:param name="compareWith" />
<xsl:param name="verMode">info</xsl:param>
<xsl:variable name="verPC"><xsl:value-of select="$promosVersions/version/actual_pc_ver"/></xsl:variable>
<xsl:variable name="a1"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$verPC"/><xsl:with-param name="pos" select="0"/></xsl:call-template></xsl:variable>
<xsl:variable name="b1"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$verPC"/><xsl:with-param name="pos" select="1"/></xsl:call-template></xsl:variable>
<xsl:variable name="c1"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$verPC"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable>
<xsl:variable name="d1"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$verPC"/><xsl:with-param name="pos" select="3"/></xsl:call-template></xsl:variable>
<xsl:variable name="a2"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$compareWith"/><xsl:with-param name="pos" select="0"/></xsl:call-template></xsl:variable>
<xsl:variable name="b2"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$compareWith"/><xsl:with-param name="pos" select="1"/></xsl:call-template></xsl:variable>
<xsl:variable name="c2"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$compareWith"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable>
<xsl:variable name="d2"><xsl:call-template name="ver_token"><xsl:with-param name="ver" select="$compareWith"/><xsl:with-param name="pos" select="3"/></xsl:call-template></xsl:variable>

<xsl:if test="($a1=$a2)and($b1&gt;=$b2)and($c1&gt;=$c2)"></xsl:if>
<xsl:if test="not(($a1=$a2)and($b1&gt;=$b2)and($c1&gt;=$c2))">&lt;font color="red"&gt;  -  Advertencia: La versión del compilador de promociones actual no satisface la versión requerida.&lt;/font&gt;
	<xsl:if test="$verMode='check'">
		<xsl:message terminate='yes'>ERROR: Versión del Compilador de Promociones Incorrecta.</xsl:message>
	</xsl:if>
	<xsl:if test="$verMode='info'">
		<xsl:message terminate='no'>ERROR: Versión del Compilador de Promociones Incorrecta.</xsl:message>
	</xsl:if>
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


<xsl:template name="ancestro">
<xsl:param name="cota">256</xsl:param>
<xsl:param name="promoId" />
	<xsl:if test="$cota=0">-1<xsl:message>ERROR: Se detectó un ciclo en la configuración de las promociones.</xsl:message></xsl:if>
	<xsl:if test="$cota>0">
		<xsl:if test="$promoId=0">0</xsl:if>
		<xsl:if test="$promoId=1">1</xsl:if>
		<xsl:if test="$promoId>1">
			<xsl:variable name="p" select="$promos/prog/promo[@id=$promoId]"/>

			<xsl:if test="count($p)>1">-2<xsl:message>ERROR: Los identificadores de promociones deben ser únicos y se encontraron <xsl:value-of select="count($p)"/> promociones con identificador <xsl:value-of select="$promoId"/>. Deberá corregir este error antes de poder continuar.</xsl:message></xsl:if>
			<xsl:if test="count($p)&lt;1">-3<xsl:message>ERROR: Una promoción hace referencia al bloque <xsl:value-of select="$promoId"/>, el cual no está definido.</xsl:message></xsl:if>
			<xsl:if test="count($p)=1">
				<xsl:call-template name="ancestro">
					<xsl:with-param name="cota" select="$cota - 1"/>
					<xsl:with-param name="promoId" select="$p/@block"/>
				</xsl:call-template>
			</xsl:if>

		</xsl:if>
	</xsl:if>
</xsl:template>


<xsl:template name="arbol">
&lt;font color="red"&gt;
<xsl:for-each select="$promos/prog/promo">
	<xsl:if test="not(./@id)">&lt;p&gt;Se detectó una promoción sin identificador.&lt;/p&gt;</xsl:if>
	<xsl:if test="./@id">
		<xsl:variable name="p" select="$promos/prog/promo[@id=current()/@block]"/>
		<xsl:if test="(./@block!=0) and (./@block!=1) and ((count($p)!=1) or ($p/@promotype!='block'))">&lt;p&gt;El bloque al que pertenece la promoción <xsl:value-of select="./@id"/> no es un bloque válido.&lt;/p&gt;</xsl:if>
		<xsl:if test="not((./@block!=0) and (./@block!=1) and ((count($p)!=1) or ($p/@promotype!='block')))">
			<xsl:variable name="t">
		      		<xsl:apply-templates select=".">
					<xsl:with-param name="view">version</xsl:with-param>
					<xsl:with-param name="verMode">info</xsl:with-param>
      				</xsl:apply-templates>
			</xsl:variable>

			<xsl:if test="$t='Desconocido'">&lt;p&gt;El tipo de la promoción <xsl:value-of select="./@id"/> es desconocido.&lt;/p&gt;</xsl:if>
			<xsl:variable name="res"><xsl:call-template name="ancestro"><xsl:with-param name="promoId" select="./@id"/></xsl:call-template></xsl:variable>
			<xsl:if test="$res=-1">&lt;p&gt;Se detectó un ciclo a partir de promoción <xsl:value-of select="./@id"/>.&lt;/p&gt;</xsl:if>
			<xsl:if test="$res=-2">&lt;p&gt;Se detectó un identificador repetido a partir de promoción <xsl:value-of select="./@id"/>.&lt;/p&gt;</xsl:if>
			<xsl:if test="$res=-3">&lt;p&gt;Se detectó que la promoción <xsl:value-of select="./@id"/> está desconectada del árbol de promociones.&lt;/p&gt;</xsl:if>
		</xsl:if>
	</xsl:if>
</xsl:for-each>
&lt;/font&gt;
</xsl:template>

</xsl:stylesheet>
