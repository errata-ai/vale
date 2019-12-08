<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc d"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- subtitle markup -->

<doc:mode mode="subtitle.markup" xmlns="">
<refpurpose>Provides access to element subtitles</refpurpose>
<refdescription id="subtitle.markup-desc">
<para>Processing an element in the
<literal role="mode">subtitle.markup</literal> mode produces the
subtitle of the element.
</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="subtitle.markup">
  <xsl:param name="verbose" select="1"/>
  <xsl:if test="$verbose != 0">
    <xsl:message>
      <xsl:text>Request for subtitle of unexpected element: </xsl:text>
      <xsl:value-of select="local-name(.)"/>
    </xsl:message>
    <xsl:text>???SUBTITLE???</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:subtitle" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:set" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates select="(d:setinfo/d:subtitle|d:info/d:subtitle|d:subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:book" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates select="(d:bookinfo/d:subtitle|d:info/d:subtitle|d:subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:part" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates select="(d:partinfo/d:subtitle
                                |d:docinfo/d:subtitle
                                |d:info/d:subtitle
                                |d:subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:preface|d:chapter|d:appendix" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates select="(d:docinfo/d:subtitle
                                |d:info/d:subtitle
                                |d:prefaceinfo/d:subtitle
                                |d:chapterinfo/d:subtitle
                                |d:appendixinfo/d:subtitle
                                |d:subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:article" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates select="(d:artheader/d:subtitle
                                |d:articleinfo/d:subtitle
                                |d:info/d:subtitle
                                |d:subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:dedication|d:colophon" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates select="(d:subtitle|d:info/d:subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:reference" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates select="(d:referenceinfo/d:subtitle
                                |d:docinfo/d:subtitle
                                |d:info/d:subtitle
                                |d:subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:qandaset" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates select="(d:blockinfo/d:subtitle|d:info/d:subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:refentry" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates select="(d:refentryinfo/d:subtitle
                                |d:info/d:subtitle
                                |d:docinfo/d:subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:section
                     |d:sect1|d:sect2|d:sect3|d:sect4|d:sect5
                     |d:refsect1|d:refsect2|d:refsect3
                     |d:topic
                     |d:simplesect"
              mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates select="(d:info/d:subtitle
                                |d:sectioninfo/d:subtitle
                                |d:sect1info/d:subtitle
                                |d:sect2info/d:subtitle
                                |d:sect3info/d:subtitle
                                |d:sect4info/d:subtitle
                                |d:sect5info/d:subtitle
                                |d:refsect1info/d:subtitle
                                |d:refsect2info/d:subtitle
                                |d:refsect3info/d:subtitle
                                |d:subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>

