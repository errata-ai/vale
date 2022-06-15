<?xml version="1.0"?>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		version="1.0">

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="d:task">
  <xsl:variable name="param.placement"
                select="substring-after(normalize-space($formal.title.placement),
                                        concat(local-name(.), ' '))"/>

  <xsl:variable name="placement">
    <xsl:choose>
      <xsl:when test="contains($param.placement, ' ')">
        <xsl:value-of select="substring-before($param.placement, ' ')"/>
      </xsl:when>
      <xsl:when test="$param.placement = ''">before</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$param.placement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="preamble"
                select="*[not(self::d:title
                              or self::d:titleabbrev)]"/>

  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>

    <xsl:if test="(d:title or d:info/d:title) and $placement = 'before'">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>

    <xsl:apply-templates select="$preamble"/>

    <xsl:if test="(d:title or d:info/d:title) and $placement != 'before'">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template match="d:task/d:title">
  <!-- nop -->
</xsl:template>

<xsl:template match="d:tasksummary">
  <xsl:call-template name="semiformal.object"/>
</xsl:template>

<xsl:template match="d:tasksummary/d:title"/>

<xsl:template match="d:taskprerequisites">
  <xsl:call-template name="semiformal.object"/>
</xsl:template>

<xsl:template match="d:taskprerequisites/d:title"/>

<xsl:template match="d:taskrelated">
  <xsl:call-template name="semiformal.object"/>
</xsl:template>

<xsl:template match="d:taskrelated/d:title"/>

</xsl:stylesheet>
