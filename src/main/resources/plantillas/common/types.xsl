<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     version="1.0">

<!--***********************************************************************
	Definiciones de Tipos de Datos del Lenguaje de Promociones
	Version: 0.5
	Autor: Fabian Ramirez
	Fecha: 22/06/07
  **********************************************************************-->

	<xsl:output method="xml"/>

	<xsl:template match="*[@datatype='bool']"><xsl:value-of select="."/></xsl:template>

	<xsl:template match="*[@datatype='num']"><xsl:value-of select="."/></xsl:template>

	<xsl:template match="*[@datatype='string']">"<xsl:value-of select="."/>"</xsl:template>

	<xsl:template match="*[@datatype='day']"><xsl:value-of select="."/></xsl:template>

	<xsl:template match="*[@datatype='date']"><xsl:value-of select="year"/>-<xsl:value-of select="month"/>-<xsl:value-of select="day"/></xsl:template>

	<xsl:template match="*[@datatype='time']"><xsl:value-of select="."/></xsl:template>

	<xsl:template match="*[@datatype='point/local']">point local</xsl:template>

	<xsl:template match="*[@datatype='point/central']">point central</xsl:template>

	<xsl:template match="*[@datatype='point/birthday']">point birthday</xsl:template>

	<xsl:template match="*[@datatype='point/electronic']">point e<xsl:value-of select="."/></xsl:template>

	<!-- ////////////// template: bonus ///////////////-->
	<xsl:template match="*[@datatype='bonus']">
		<xsl:if test="tipo_bono = 'canjeable'">bonus(<xsl:value-of select="target"/>,c<xsl:value-of select="type"/>,<xsl:value-of select="value"/>,"<xsl:value-of select="caption"/>")</xsl:if>
		<xsl:if test="tipo_bono = 'medio de pago'">bonus(<xsl:value-of select="target"/>,t<xsl:value-of select="type"/>,<xsl:value-of select="value"/>,"<xsl:value-of select="caption"/>")</xsl:if>
		<xsl:if test="not(tipo_bono)">bonus(<xsl:value-of select="target"/>,t<xsl:value-of select="type"/>,<xsl:value-of select="value"/>,"<xsl:value-of select="caption"/>")</xsl:if>
	</xsl:template>

	<!-- ////////////// template: bonus modo INIT ///////////////-->
	<xsl:template match="*[@datatype='bonus']" mode="init">
		<xsl:if test="tipo_bono = 'canjeable'">bonus(<xsl:value-of select="target"/>,c<xsl:value-of select="type"/>,0,"<xsl:value-of select="caption"/>")</xsl:if>
		<xsl:if test="tipo_bono = 'medio de pago'">bonus(<xsl:value-of select="target"/>,t<xsl:value-of select="type"/>,0,"<xsl:value-of select="caption"/>")</xsl:if>
		<xsl:if test="not(tipo_bono)">bonus(<xsl:value-of select="target"/>,t<xsl:value-of select="type"/>,0,"<xsl:value-of select="caption"/>")</xsl:if>
	</xsl:template>

	<!-- ////////////// template: bonus modo VAL ///////////////-->
	<xsl:template match="*[@datatype='bonus']" mode="val"><xsl:param name="valor" select="'0'"/>
		<xsl:if test="tipo_bono = 'canjeable'">bonus(<xsl:value-of select="target"/>,c<xsl:value-of select="type"/>,<xsl:value-of select="$valor"/>,"<xsl:value-of select="caption"/>")</xsl:if>
		<xsl:if test="tipo_bono = 'medio de pago'">bonus(<xsl:value-of select="target"/>,t<xsl:value-of select="type"/>,<xsl:value-of select="$valor"/>,"<xsl:value-of select="caption"/>")</xsl:if>
		<xsl:if test="not(tipo_bono)">bonus(<xsl:value-of select="target"/>,t<xsl:value-of select="type"/>,<xsl:value-of select="$valor"/>,"<xsl:value-of select="caption"/>")</xsl:if>
	</xsl:template>

	<xsl:template match="*[@datatype='article']">article <xsl:if test="cod_int"><xsl:if test="cod_bar">x<xsl:value-of select="cod_int"/>_<xsl:value-of select="cod_bar"/></xsl:if><xsl:if test="not(cod_bar)">i<xsl:value-of select="cod_int"/></xsl:if></xsl:if><xsl:if test="not(cod_int)"><xsl:if test="cod_bar">b<xsl:value-of select="cod_bar"/></xsl:if><xsl:if test="not(cod_bar)">i<xsl:value-of select="."/></xsl:if></xsl:if></xsl:template>

	<xsl:template match="*[@datatype='cash']">cash</xsl:template>

	<xsl:template match="*[@datatype='currency']">
		<xsl:if test=". &gt; 0">currency i<xsl:value-of select="."/></xsl:if>
		<xsl:if test=". = 0">currency null</xsl:if>
	</xsl:template>

	<xsl:template match="*[@datatype='card']">
		<xsl:if test="idcard &gt; 0"><xsl:if test="plan &gt; 0">card(i<xsl:value-of select="idcard"/>,p<xsl:value-of select="plan"/>)</xsl:if></xsl:if>
		<xsl:if test="idcard &gt; 0"><xsl:if test="plan = 0">card(i<xsl:value-of select="idcard"/>,null)</xsl:if></xsl:if>
		<xsl:if test="idcard = 0"><xsl:if test="plan &gt; 0">card(null,p<xsl:value-of select="plan"/>)</xsl:if></xsl:if>
		<xsl:if test="idcard = 0"><xsl:if test="plan = 0">card(null,null)</xsl:if></xsl:if>
	</xsl:template>

	<xsl:template match="*[@datatype='card']" mode="null_1">
		<xsl:if test="plan &gt; 0">card(null,p<xsl:value-of select="plan"/>)</xsl:if>
		<xsl:if test="plan = 0">card(null,null)</xsl:if>
	</xsl:template>

	<xsl:template match="*[@datatype='card']" mode="null_2">
		<xsl:if test="idcard &gt; 0">card(i<xsl:value-of select="idcard"/>,null)</xsl:if>
		<xsl:if test="idcard = 0">card(null,null)</xsl:if>
	</xsl:template>

	<xsl:template match="*[@datatype='gcard']">
		<xsl:if test="medio &gt; 0">
			<xsl:if test="idcard &gt; 0"><xsl:if test="plan &gt; 0">card(m<xsl:value-of select="medio"/>s<xsl:value-of select="idcard"/>,p<xsl:value-of select="plan"/>)</xsl:if></xsl:if>
			<xsl:if test="idcard &gt; 0"><xsl:if test="plan = 0">card(m<xsl:value-of select="medio"/>s<xsl:value-of select="idcard"/>,null)</xsl:if></xsl:if>
			<xsl:if test="idcard = 0"><xsl:if test="plan &gt; 0">card(null,p<xsl:value-of select="plan"/>)</xsl:if></xsl:if>
			<xsl:if test="idcard = 0"><xsl:if test="plan = 0">card(null,null)</xsl:if></xsl:if>
		</xsl:if>
		<xsl:if test="medio &lt;= 0">
			<xsl:if test="idcard &gt; 0"><xsl:if test="plan &gt; 0">card(i<xsl:value-of select="idcard"/>,p<xsl:value-of select="plan"/>)</xsl:if></xsl:if>
			<xsl:if test="idcard &gt; 0"><xsl:if test="plan = 0">card(i<xsl:value-of select="idcard"/>,null)</xsl:if></xsl:if>
			<xsl:if test="idcard = 0"><xsl:if test="plan &gt; 0">card(null,p<xsl:value-of select="plan"/>)</xsl:if></xsl:if>
			<xsl:if test="idcard = 0"><xsl:if test="plan = 0">card(null,null)</xsl:if></xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!--xsl:template match="*[@datatype='mutual']">
		<xsl:if test=". &gt; 0">mutual i<xsl:value-of select="."/></xsl:if>
		<xsl:if test=". = 0">mutual null</xsl:if>
	</xsl:template-->

	<!--xsl:template match="*[@datatype='ticket']">
		<xsl:if test=". &gt; 0">ticket i<xsl:value-of select="."/></xsl:if>
		<xsl:if test=". = 0">ticket null</xsl:if>
	</xsl:template-->

	<xsl:template match="*[@datatype='ticket']">ticket m<xsl:value-of select="medio"/>s<xsl:value-of select="submedio"/></xsl:template>

	<xsl:template match="*[@datatype='mutual']">mutual m<xsl:value-of select="medio"/>s<xsl:value-of select="submedio"/></xsl:template>

	<xsl:template match="*[@datatype='cheque']">
		<xsl:if test=". &gt; 0">cheque i<xsl:value-of select="."/></xsl:if>
		<xsl:if test=". = 0">cheque null</xsl:if>
	</xsl:template>

	<xsl:template match="*[@datatype='ctacte']">ctacte</xsl:template>

	<xsl:template match="*[@datatype='mean']"><xsl:apply-templates select="."/></xsl:template>

	<xsl:template match="*[@datatype='interval']">[<xsl:apply-templates select="v0"/>,<xsl:apply-templates select="v1"/>]</xsl:template>

	<xsl:template match="*[@datatype='set']">{<xsl:for-each select="day">
		  <xsl:apply-templates select="."/>
		  <xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>}</xsl:template>

	<xsl:template match="*[@datatype='amset']/item">
		<xsl:param name="index">1</xsl:param><xsl:if test="$index=3">[<xsl:apply-templates select="descarga"/> ,{<xsl:apply-templates select="element"/>}]</xsl:if>
		<xsl:if test="$index!=3">(<xsl:apply-templates select="element"/>,<xsl:if test="$index=1"><xsl:apply-templates select="count"/></xsl:if><xsl:if test="$index=2"><xsl:apply-templates select="points"/></xsl:if>)</xsl:if></xsl:template>

	<xsl:template match="*[@datatype='amset']">
		<xsl:param name="index">1</xsl:param>{<xsl:if test="$index=3">|</xsl:if><xsl:for-each select="item"><xsl:apply-templates select="."><xsl:with-param name="index"><xsl:value-of select="$index"/></xsl:with-param></xsl:apply-templates><xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each><xsl:if test="$index=3">|</xsl:if>}</xsl:template>
		
	<xsl:template match="*[@datatype='HMMamset']/item">
		<xsl:param name="index">1</xsl:param><xsl:if test="$index=3">[<xsl:apply-templates select="descarga"/> ,{<xsl:apply-templates select="element"/>}]</xsl:if>
		<xsl:if test="$index!=3">(<xsl:apply-templates select="element"/>,<xsl:if test="$index=1"><xsl:apply-templates select="count"/></xsl:if><xsl:if test="$index=2"><xsl:apply-templates select="points"/></xsl:if>)</xsl:if></xsl:template>

	<xsl:template match="*[@datatype='HMMamset']">
		<xsl:param name="index">1</xsl:param>{<xsl:if test="$index=3">|</xsl:if><xsl:for-each select="item"><xsl:apply-templates select="."><xsl:with-param name="index"><xsl:value-of select="$index"/></xsl:with-param></xsl:apply-templates><xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each><xsl:if test="$index=3">|</xsl:if>}</xsl:template>

	<xsl:template match="*[@datatype='part']/item">[<xsl:apply-templates select="rep"/>,<xsl:apply-templates select="class"/>]</xsl:template>

	<xsl:template match="*[@datatype='part']">{|<xsl:for-each select="item">
		  <xsl:apply-templates select="."/>
		  <xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>|}</xsl:template>


	<xsl:template match="*[@datatype='amset_article']/item">(<xsl:apply-templates select="article"/>,<xsl:apply-templates select="num"/>)</xsl:template>

	<xsl:template match="*[@datatype='amset_article']">{<xsl:for-each select="item">
		  <xsl:apply-templates select="."/>
		  <xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>}</xsl:template>

	<xsl:template match="*[@datatype='department']">department d<xsl:value-of select="."/></xsl:template>

	<xsl:template match="*[@datatype='clasification']">class (n<xsl:value-of select="nivel"/>,c<xsl:value-of select="concept"/>)</xsl:template>


	<!--////////////// template: union de clasificaciones /////////////////////-->
	<xsl:template match="*[@datatype='union_clasificaciones']"><xsl:for-each select="clasificacion"><xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> union </xsl:if></xsl:for-each></xsl:template>

	<!--////////////// template: union de deptos /////////////////////-->
	<xsl:template match="*[@datatype='union_deptos']"><xsl:for-each select="d/depto"><xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> union </xsl:if></xsl:for-each></xsl:template>

	<!--////////////// template: proveedor /////////////////////-->
	<xsl:template match="*[@datatype='proveedor']">department p<xsl:value-of select="."/></xsl:template>

	<!--////////////// template: union de proveedores /////////////////////-->
	<xsl:template match="*[@datatype='union_proveedores']"><xsl:for-each select="pvdor"><xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> union </xsl:if></xsl:for-each></xsl:template>

	<!--////////////// template: interseccion de clasificaciones /////////////////////-->
	<xsl:template match="*[@datatype='interseccion_clasificaciones']"><xsl:for-each select="clasificacion"><xsl:apply-templates select="."/><xsl:if test="not(position()=last())"> intersection </xsl:if></xsl:for-each></xsl:template>


</xsl:stylesheet>
