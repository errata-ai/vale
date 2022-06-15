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

<xsl:template match="d:table" mode="htmlTable">
  <xsl:element name="table" namespace="">
    <xsl:apply-templates select="@*" mode="htmlTableAtt"/>
    <xsl:call-template name="htmlTable"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:colgroup" mode="htmlTable">
  <xsl:element name="{local-name()}" namespace="">
    <xsl:apply-templates select="@*" mode="htmlTableAtt"/>
    <xsl:apply-templates mode="htmlTable"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:col" mode="htmlTable">
  <xsl:element name="{local-name()}" namespace="">
    <xsl:apply-templates select="@*" mode="htmlTableAtt"/>
  </xsl:element>
</xsl:template>

<!-- Handled by formal.object.title template -->
<xsl:template match="d:caption" mode="htmlTable"/>

<xsl:template match="d:tbody|d:thead|d:tfoot|d:tr" mode="htmlTable">
  <xsl:element name="{local-name(.)}">
    <xsl:apply-templates select="@*" mode="htmlTableAtt"/>
    <xsl:apply-templates mode="htmlTable"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:th|d:td" mode="htmlTable">
  <xsl:element name="{local-name(.)}">
    <xsl:apply-templates select="@*" mode="htmlTableAtt"/>
    <xsl:apply-templates/> <!-- *not* mode=htmlTable -->
  </xsl:element>
</xsl:template>

<!-- don't copy through DocBook-specific attributes on HTML table markup -->
<!-- default behavior is to not copy through because there are more
     DocBook attributes than HTML attributes -->
<xsl:template mode="htmlTableAtt" match="@*"/>

<!-- copy these through -->
<xsl:template mode="htmlTableAtt"
              match="@abbr
                   | @align
                   | @axis
                   | @bgcolor
                   | @border
                   | @cellpadding
                   | @cellspacing
                   | @char
                   | @charoff
                   | @class
                   | @dir
                   | @frame
                   | @headers
                   | @height
                   | @lang
                   | @nowrap
                   | @onclick
                   | @ondblclick
                   | @onkeydown
                   | @onkeypress
                   | @onkeyup
                   | @onmousedown
                   | @onmousemove
                   | @onmouseout
                   | @onmouseover
                   | @onmouseup
                   | @rules
                   | @scope
                   | @style
                   | @summary
                   | @title
                   | @valign
                   | @valign
                   | @width
                   | @xml:id
                   | @xml:lang">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="@span|@rowspan|@colspan" mode="htmlTableAtt">
  <!-- No need to copy through the DTD's default value "1" of the attribute -->
  <xsl:if test="number(.) != 1">
    <xsl:attribute name="{local-name(.)}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<!-- map floatstyle to HTML float values -->
<xsl:template match="@floatstyle" mode="htmlTableAtt">
  <xsl:attribute name="style">
    <xsl:text>float: </xsl:text>
    <xsl:choose>
      <xsl:when test="contains(., 'left')">left</xsl:when>
      <xsl:when test="contains(., 'right')">right</xsl:when>
      <xsl:when test="contains(., 'start')">
        <xsl:value-of select="$direction.align.start"/>
      </xsl:when>
      <xsl:when test="contains(., 'end')">
        <xsl:value-of select="$direction.align.end"/>
      </xsl:when>
      <xsl:when test="contains(., 'inside')">
        <xsl:value-of select="$direction.align.start"/>
      </xsl:when>
      <xsl:when test="contains(., 'outside')">
        <xsl:value-of select="$direction.align.end"/>
      </xsl:when>
      <xsl:when test="contains(., 'before')">none</xsl:when>
      <xsl:when test="contains(., 'none')">none</xsl:when>
    </xsl:choose>
    <xsl:text>;</xsl:text>
  </xsl:attribute>
</xsl:template>

</xsl:stylesheet>
