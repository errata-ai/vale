<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:xi="http://www.w3.org/2001/XInclude"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:param name="textdata.default.encoding"></xsl:param>

<!-- * This stylesheet makes a copy of a source tree, replacing all -->
<!-- * instances of the following with corresponding Xinclude instances -->
<!-- * in the result tree. -->
<!-- * -->
<!-- *   <textobject><textdata fileref="foo.txt"> -->
<!-- *   <imagedata format="linespecific" fileref="foo.txt"> -->
<!-- *   <inlinegraphic format="linespecific" fileref="foo.txt"> -->
<!-- * -->
<!-- * Those become: -->
<!-- * -->
<!-- *   <xi:include href="foo.txt" parse="text"/> -->
<!-- * -->
<!-- * It also works as expected with entityref in place of fileref, -->
<!-- * and copies over the value of the <textdata>“encoding” atrribute (if -->
<!-- * found). It is basically intended as an alternative to using the -->
<!-- * DocBook XSLT Java insertfile() extension. -->

<!-- ==================================================================== -->

<xsl:template name="get.external.filename">
  <xsl:choose>
    <xsl:when test="@entityref">
      <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@fileref"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:textobject[child::d:textdata[@entityref|@fileref]]">
  <xsl:apply-templates select="d:textdata"/>
</xsl:template>

<xsl:template match="d:textdata[@entityref|@fileref]">
  <xsl:variable name="filename">
    <xsl:call-template name="get.external.filename"/>
  </xsl:variable>
  <xsl:variable name="encoding">
    <xsl:choose>
      <xsl:when test="@encoding">
        <xsl:value-of select="@encoding"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$textdata.default.encoding"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xi:include href="{$filename}" parse="text" encoding="{$encoding}"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template
    match="d:inlinemediaobject
           [child::d:imageobject
           [child::d:imagedata
           [@format = 'linespecific' and
           (@entityref|@fileref)]]]">
  <xsl:apply-templates select="d:imageobject/d:imagedata"/>
</xsl:template>

<xsl:template match="d:imagedata
                     [@format = 'linespecific' and
                     (@entityref|@fileref)]">
  <xsl:variable name="filename">
    <xsl:call-template name="get.external.filename"/>
  </xsl:variable>
  <xi:include href="{$filename}" parse="text" encoding="{$textdata.default.encoding}"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:inlinegraphic
                     [@format = 'linespecific' and
                     (@entityref|@fileref)]">
  <xsl:variable name="filename">
    <xsl:call-template name="get.external.filename"/>
  </xsl:variable>
  <xi:include href="{$filename}" parse="text" encoding="{$textdata.default.encoding}"/>
</xsl:template>

<!-- ==================================================================== -->

<!-- * copy everything else into result tree as-is -->
<xsl:template match="node() | @*">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
