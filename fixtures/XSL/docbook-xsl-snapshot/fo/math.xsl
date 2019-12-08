<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                exclude-result-prefixes="mml d"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:template match="d:inlineequation">
  <fo:inline>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:alt">
</xsl:template>

<xsl:template match="d:mathphrase">
  <fo:inline>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!-- "Support" for MathML -->

<xsl:template match="mml:math" xmlns:mml="http://www.w3.org/1998/Math/MathML">
  <fo:instream-foreign-object>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </fo:instream-foreign-object>
</xsl:template>

<xsl:template match="mml:*" xmlns:mml="http://www.w3.org/1998/Math/MathML">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="d:equation/d:graphic | d:informalequation/d:graphic">
  <xsl:if test="$tex.math.in.alt = ''">
    <fo:block>
      <xsl:call-template name="process.image"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:inlineequation/d:alt[@role='tex'] |
                     d:inlineequation/d:inlinemediaobject/d:textobject[@role='tex']" priority="1">
  <xsl:param name="output.delims" select="1"/>
</xsl:template>

<xsl:template match="d:equation/d:alt[@role='tex'] | d:informalequation/d:alt[@role='tex'] |
                     d:equation/d:mediaobject/d:textobject[@role='tex'] |
                     d:informalequation/d:mediaobject/d:textobject[@role='tex']" priority="1">
  <xsl:variable name="output.delims">
    <xsl:call-template name="tex.math.output.delims"/>
  </xsl:variable>
</xsl:template>

<xsl:template name="tex.math.output.delims">
  <xsl:variable name="pi.delims">
    <xsl:call-template name="pi-attribute">
      <xsl:with-param name="pis" select=".//processing-instruction('dbtex')"/>
      <xsl:with-param name="attribute" select="'delims'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="result">
    <xsl:choose>
      <xsl:when test="$pi.delims = 'no'">0</xsl:when>
      <xsl:when test="$pi.delims = '' and $tex.math.delims = 0">0</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$result"/>
</xsl:template>

</xsl:stylesheet>
