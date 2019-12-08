<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:template match="d:note|d:important|d:warning|d:caution|d:tip">
  <xsl:choose>
    <xsl:when test="$admon.graphics != 0">
      <xsl:call-template name="graphical.admonition"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="nongraphical.admonition"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="admon.graphic.width">
  <xsl:param name="node" select="."/>
  <xsl:text>36pt</xsl:text>
</xsl:template>

<xsl:template name="admon.graphic">
  <xsl:param name="node" select="."/>

  <xsl:variable name="filename">
    <xsl:value-of select="$admon.graphics.path"/>
    <xsl:choose>
      <xsl:when test="local-name($node)='note'">note</xsl:when>
      <xsl:when test="local-name($node)='warning'">warning</xsl:when>
      <xsl:when test="local-name($node)='caution'">caution</xsl:when>
      <xsl:when test="local-name($node)='tip'">tip</xsl:when>
      <xsl:when test="local-name($node)='important'">important</xsl:when>
      <xsl:otherwise>note</xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$admon.graphics.extension"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$fop.extensions != 0
                    or $arbortext.extensions != 0">
      <xsl:value-of select="$filename"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>url(</xsl:text>
      <xsl:value-of select="$filename"/>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="graphical.admonition">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="graphic.width">
     <xsl:apply-templates select="." mode="admon.graphic.width"/>
  </xsl:variable>

  <fo:block id="{$id}"
            xsl:use-attribute-sets="graphical.admonition.properties">
    <fo:list-block provisional-distance-between-starts="{$graphic.width} + 18pt"
                    provisional-label-separation="18pt">
      <fo:list-item>
          <fo:list-item-label end-indent="label-end()">
            <fo:block>
              <fo:external-graphic width="auto" height="auto"
                                         content-width="{$graphic.width}" >
                <xsl:attribute name="src">
                  <xsl:call-template name="admon.graphic"/>
                </xsl:attribute>
              </fo:external-graphic>
            </fo:block>
            <!-- include leading indexterms in this part to prevent
                 extra spacing above first para from its space-before -->
            <xsl:apply-templates mode="leading.indexterms" 
                                 select="child::d:indexterm[not(preceding-sibling::*)]"/>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <xsl:if test="$admon.textlabel != 0 or d:title or d:info/d:title">
              <fo:block xsl:use-attribute-sets="admonition.title.properties">
                <xsl:apply-templates select="." mode="object.title.markup">
		  <xsl:with-param name="allow-anchors" select="1"/>
		</xsl:apply-templates>
              </fo:block>
            </xsl:if>
            <fo:block xsl:use-attribute-sets="admonition.properties">
              <xsl:apply-templates select="*[not(self::d:indexterm[not(preceding-sibling::*)])]"/>
            </fo:block>
          </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </fo:block>
</xsl:template>

<xsl:template name="nongraphical.admonition">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}"
            xsl:use-attribute-sets="nongraphical.admonition.properties">
    <xsl:if test="$admon.textlabel != 0 or d:title or d:info/d:title">
      <fo:block keep-with-next.within-column='always'
                xsl:use-attribute-sets="admonition.title.properties">
         <xsl:apply-templates select="." mode="object.title.markup">
	   <xsl:with-param name="allow-anchors" select="1"/>
	 </xsl:apply-templates>
      </fo:block>
    </xsl:if>

    <fo:block xsl:use-attribute-sets="admonition.properties">
      <xsl:apply-templates/>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="d:note/d:title"></xsl:template>
<xsl:template match="d:important/d:title"></xsl:template>
<xsl:template match="d:warning/d:title"></xsl:template>
<xsl:template match="d:caution/d:title"></xsl:template>
<xsl:template match="d:tip/d:title"></xsl:template>

</xsl:stylesheet>
