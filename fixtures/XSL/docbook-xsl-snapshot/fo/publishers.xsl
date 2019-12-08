<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  exclude-result-prefixes="dc d"
  version='1.0'>
  
<xsl:template match="d:drama/d:title"/>
<xsl:template match="d:poetry/d:title"/>
<xsl:template match="d:dialogue/d:title"/>

<xsl:template match="d:drama">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
    
  <xsl:element name="fo:{$section.container.element}" 
               use-attribute-sets="drama.properties">
    <xsl:attribute name="id"><xsl:value-of 
                        select="$id"/></xsl:attribute>
    <xsl:call-template name="drama.titlepage"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>
  
<xsl:template match="d:dialogue">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
    
  <xsl:element name="fo:{$section.container.element}" 
               use-attribute-sets="dialogue.properties">
    <xsl:attribute name="id"><xsl:value-of 
                        select="$id"/></xsl:attribute>
    <xsl:call-template name="dialogue.titlepage"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>
  
<xsl:template match="d:poetry">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
    
  <xsl:element name="fo:{$section.container.element}" 
               use-attribute-sets="poetry.properties">
    <xsl:attribute name="id"><xsl:value-of 
                        select="$id"/></xsl:attribute>
    <xsl:call-template name="poetry.titlepage"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>
  
<xsl:template match="d:stagedir">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  
  <xsl:variable name="keep.together">
    <xsl:call-template name="pi.dbfo_keep-together"/>
  </xsl:variable>
  
  <fo:block id="{$id}" xsl:use-attribute-sets="stagedir.properties">
    <xsl:if test="$keep.together != ''">
      <xsl:attribute name="keep-together.within-column"><xsl:value-of
        select="$keep.together"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates />
  </fo:block>

</xsl:template>

<xsl:template match="d:inlinestagedir">
  <fo:inline xsl:use-attribute-sets="inlinestagedir.properties">
    <xsl:call-template name="anchor"/>
    <xsl:text> [</xsl:text>
    <xsl:apply-templates />
    <xsl:text>] </xsl:text>
  </fo:inline>
</xsl:template>

<xsl:template match="d:linegroup">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="keep.together">
    <xsl:call-template name="pi.dbfo_keep-together"/>
  </xsl:variable>
  
  <fo:list-block id="{$id}" xsl:use-attribute-sets="linegroup.properties">
    <xsl:if test="$keep.together != ''">
      <xsl:attribute name="keep-together.within-column"><xsl:value-of
        select="$keep.together"/></xsl:attribute>
    </xsl:if>
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <xsl:apply-templates select="d:speaker"/>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <xsl:apply-templates select="*[not(self::d:speaker)]"/>
      </fo:list-item-body>
    </fo:list-item>
  </fo:list-block>
</xsl:template>

<xsl:template match="d:speaker">
  <fo:block xsl:use-attribute-sets="speaker.properties">
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:line">
  <fo:block xsl:use-attribute-sets="line.properties">
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
