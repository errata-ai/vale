<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="doc d"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- title markup -->

<doc:mode mode="title.markup" xmlns="">
<refpurpose>Provides access to element titles</refpurpose>
<refdescription id="title.markup-desc">
<para>Processing an element in the
<literal role="mode">title.markup</literal> mode produces the
title of the element. This does not include the label.
</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:choose>
    <!-- * FIXME: this should handle other *info elements as well -->
    <!-- * but this is good enough for now. -->
    <xsl:when test="d:title|d:info/d:title">
      <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="local-name(.) = 'partintro'">
      <!-- partintro's don't have titles, use the parent (part or reference)
           title instead. -->
      <xsl:apply-templates select="parent::*" mode="title.markup"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$verbose != 0">
        <xsl:message>
          <xsl:text>Request for title of element with no title: </xsl:text>
          <xsl:value-of select="local-name(.)"/>
          <xsl:choose>
            <xsl:when test="@id">
              <xsl:text> (id="</xsl:text>
              <xsl:value-of select="@id"/>
              <xsl:text>")</xsl:text>
            </xsl:when>
            <xsl:when test="@xml:id">
              <xsl:text> (xml:id="</xsl:text>
              <xsl:value-of select="@xml:id"/>
              <xsl:text>")</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> (contained in </xsl:text>
              <xsl:value-of select="local-name(..)"/>
              <xsl:if test="../@id or ../@xml:id">
                <xsl:text> with id </xsl:text>
                <xsl:value-of select="../@id | ../@xml:id"/>
              </xsl:if>
              <xsl:text>)</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:message>
      </xsl:if>
      <xsl:text>???TITLE???</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:title" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>

  <xsl:choose>
    <xsl:when test="$allow-anchors != 0">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- only occurs in HTML Tables! -->
<xsl:template match="d:caption" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>

  <xsl:choose>
    <xsl:when test="$allow-anchors != 0">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:set" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(d:setinfo/d:title|d:info/d:title|d:title)[1]"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:book" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(d:bookinfo/d:title|d:info/d:title|d:title)[1]"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:part" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(d:partinfo/d:title|d:info/d:title|d:docinfo/d:title|d:title)[1]"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:preface|d:chapter|d:appendix" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>

<!--
  <xsl:message>
    <xsl:value-of select="local-name(.)"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$allow-anchors"/>
  </xsl:message>
-->

  <xsl:variable name="title" select="(d:docinfo/d:title
                                      |d:info/d:title
                                      |d:prefaceinfo/d:title
                                      |d:chapterinfo/d:title
                                      |d:appendixinfo/d:title
                                      |d:title)[1]"/>
  <xsl:apply-templates select="$title" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:dedication" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="d:title|d:info/d:title">
      <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Dedication'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:acknowledgements" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="d:title|d:info/d:title">
      <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Acknowledgements'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:colophon" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="d:title|d:info/d:title">
      <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Colophon'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:article" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(d:artheader/d:title
                                      |d:articleinfo/d:title
                                      |d:info/d:title
                                      |d:title)[1]"/>

  <xsl:apply-templates select="$title" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:reference" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(d:referenceinfo/d:title|d:docinfo/d:title|d:info/d:title|d:title)[1]"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:refentry" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="refmeta" select=".//d:refmeta"/>
  <xsl:variable name="refentrytitle" select="$refmeta//d:refentrytitle"/>
  <xsl:variable name="refnamediv" select=".//d:refnamediv"/>
  <xsl:variable name="refname" select="$refnamediv//d:refname"/>
  <xsl:variable name="refdesc" select="$refnamediv//d:refdescriptor"/>

  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="$refentrytitle">
        <xsl:apply-templates select="$refentrytitle[1]" mode="title.markup"/>
      </xsl:when>
      <xsl:when test="$refdesc">
        <xsl:apply-templates select="$refdesc" mode="title.markup"/>
      </xsl:when>
      <xsl:when test="$refname">
        <xsl:apply-templates select="$refname[1]" mode="title.markup"/>
      </xsl:when>
      <xsl:otherwise>REFENTRY WITHOUT TITLE???</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:copy-of select="$title"/>
</xsl:template>

<xsl:template match="d:refentrytitle|d:refname|d:refdescriptor" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="$allow-anchors != 0">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:section
                     |d:sect1|d:sect2|d:sect3|d:sect4|d:sect5
                     |d:refsect1|d:refsect2|d:refsect3|d:refsection
                     |d:topic
                     |d:simplesect"
              mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(d:info/d:title
                                      |d:sectioninfo/d:title
                                      |d:sect1info/d:title
                                      |d:sect2info/d:title
                                      |d:sect3info/d:title
                                      |d:sect4info/d:title
                                      |d:sect5info/d:title
                                      |d:refsect1info/d:title
                                      |d:refsect2info/d:title
                                      |d:refsect3info/d:title
                                      |d:refsectioninfo/d:title
                                      |d:title)[1]"/>

  <xsl:apply-templates select="$title" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:bridgehead" mode="title.markup">
  <xsl:apply-templates/> 
</xsl:template>

<xsl:template match="d:refsynopsisdiv" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="d:title|d:info/d:title">
      <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'RefSynopsisDiv'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:bibliography" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(d:bibliographyinfo/d:title|d:info/d:title|d:title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Bibliography'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:glossary" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(d:glossaryinfo/d:title|d:info/d:title|d:title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext.element.name">
        <xsl:with-param name="element.name" select="local-name(.)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:glossdiv" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(d:info/d:title|d:title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>ERROR: glossdiv missing its required title</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:glossentry" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="d:glossterm" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:glossterm|d:firstterm" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>

  <xsl:choose>
    <xsl:when test="$allow-anchors != 0">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:index" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(d:indexinfo/d:title|d:info/d:title|d:title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Index'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:setindex" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(d:setindexinfo/d:title|d:info/d:title|d:title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'SetIndex'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:figure|d:example|d:equation" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:table" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(d:title|d:info/d:title|d:caption)[1]" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:procedure" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:task" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:sidebar" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(d:info/d:title|d:sidebarinfo/d:title|d:title)[1]"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:abstract" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="d:title|d:info/d:title">
      <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Abstract'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:caution|d:tip|d:warning|d:important|d:note" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(d:title|d:info/d:title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">
          <xsl:choose>
            <xsl:when test="local-name(.)='note'">Note</xsl:when>
            <xsl:when test="local-name(.)='important'">Important</xsl:when>
            <xsl:when test="local-name(.)='caution'">Caution</xsl:when>
            <xsl:when test="local-name(.)='warning'">Warning</xsl:when>
            <xsl:when test="local-name(.)='tip'">Tip</xsl:when>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:question" mode="title.markup">
  <!-- questions don't have titles -->
  <xsl:call-template name="gentext">
    <xsl:with-param name="key">question</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:answer" mode="title.markup">
  <!-- answers don't have titles -->
  <xsl:call-template name="gentext">
    <xsl:with-param name="key">answer</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:qandaentry" mode="title.markup">
  <!-- qandaentrys are represented by the first question in them -->
  <xsl:apply-templates select="d:question" mode="title.markup"/>
</xsl:template>

<xsl:template match="d:qandaset" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(d:info/d:title|
                                      d:blockinfo/d:title|
                                      d:title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'QandASet'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:legalnotice" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="d:title|d:info/d:title">
      <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'LegalNotice'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<!-- titleabbrev is always processed in a mode -->
<xsl:template match="d:titleabbrev"/>

<xsl:template match="*" mode="titleabbrev.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:choose>
    <xsl:when test="d:titleabbrev">
      <xsl:apply-templates select="d:titleabbrev[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="d:info/d:titleabbrev">
      <xsl:apply-templates select="d:info/d:titleabbrev[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:book|d:part|d:set|d:preface|d:chapter|d:appendix" mode="titleabbrev.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:variable name="titleabbrev" select="(d:docinfo/d:titleabbrev
                                           |d:bookinfo/d:titleabbrev
                                           |d:info/d:titleabbrev
                                           |d:prefaceinfo/d:titleabbrev
                                           |d:setinfo/d:titleabbrev
                                           |d:partinfo/d:titleabbrev
                                           |d:chapterinfo/d:titleabbrev
                                           |d:appendixinfo/d:titleabbrev
                                           |d:titleabbrev)[1]"/>

  <xsl:choose>
    <xsl:when test="$titleabbrev">
      <xsl:apply-templates select="$titleabbrev" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:article" mode="titleabbrev.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:variable name="titleabbrev" select="(d:artheader/d:titleabbrev
                                           |d:articleinfo/d:titleabbrev
                                           |d:info/d:titleabbrev
                                           |d:titleabbrev)[1]"/>

  <xsl:choose>
    <xsl:when test="$titleabbrev">
      <xsl:apply-templates select="$titleabbrev" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:section
                     |d:sect1|d:sect2|d:sect3|d:sect4|d:sect5
                     |d:refsect1|d:refsect2|d:refsect3
                     |d:topic
                     |d:simplesect"
              mode="titleabbrev.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:variable name="titleabbrev" select="(d:info/d:titleabbrev
                                            |d:sectioninfo/d:titleabbrev
                                            |d:sect1info/d:titleabbrev
                                            |d:sect2info/d:titleabbrev
                                            |d:sect3info/d:titleabbrev
                                            |d:sect4info/d:titleabbrev
                                            |d:sect5info/d:titleabbrev
                                            |d:refsect1info/d:titleabbrev
                                            |d:refsect2info/d:titleabbrev
                                            |d:refsect3info/d:titleabbrev
                                            |d:titleabbrev)[1]"/>

  <xsl:choose>
    <xsl:when test="$titleabbrev">
      <xsl:apply-templates select="$titleabbrev" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:titleabbrev" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>

  <xsl:choose>
    <xsl:when test="$allow-anchors != 0">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="no.anchor.mode">
  <!-- Switch to normal mode if no links -->
  <xsl:choose>
    <xsl:when test="descendant-or-self::d:footnote or
                    descendant-or-self::d:anchor or
                    descendant-or-self::d:ulink or
                    descendant-or-self::d:link or
                    descendant-or-self::d:olink or
                    descendant-or-self::d:xref or
                    descendant-or-self::d:indexterm or
		    (ancestor::d:title and (@id or @xml:id))">

      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:footnote" mode="no.anchor.mode">
  <!-- nop, suppressed -->
</xsl:template>

<xsl:template match="d:footnoteref" mode="no.anchor.mode">
  <!-- nop, suppressed -->
</xsl:template>

<xsl:template match="d:anchor" mode="no.anchor.mode">
  <!-- nop, suppressed -->
</xsl:template>

<xsl:template match="d:ulink" mode="no.anchor.mode">
  <xsl:param name="url" select="@url"/>
  <xsl:choose>
    <xsl:when test="count(child::node())=0">
      <xsl:value-of select="$url"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:link" mode="no.anchor.mode">
  <xsl:choose>
    <xsl:when test="count(child::node()) &gt; 0">
      <!-- If it has content, use it -->
      <xsl:apply-templates/>
    </xsl:when>
	<!-- look for an endterm -->
    <xsl:when test="@endterm">
      <xsl:variable name="etargets" select="key('id',@endterm)"/>
      <xsl:variable name="etarget" select="$etargets[1]"/>
      <xsl:choose>
	<xsl:when test="count($etarget) = 0">
          <xsl:message>
	    <xsl:value-of select="count($etargets)"/>
	    <xsl:text>Endterm points to nonexistent ID: </xsl:text>
	    <xsl:value-of select="@endterm"/>
          </xsl:message>
	  <xsl:text>???</xsl:text>
	</xsl:when>
        <xsl:otherwise>
	  <xsl:apply-templates select="$etarget" mode="endterm"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:olink" mode="no.anchor.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:indexterm" mode="no.anchor.mode">
  <!-- nop, suppressed -->
</xsl:template>

<xsl:template match="d:xref" mode="no.anchor.mode">
  <xsl:variable name="referrer" select="."/>
  <xsl:variable name="targets" select="key('id',@linkend)|key('id',substring-after(@xlink:href,'#'))"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:variable name="refelem" select="local-name($target)"/>
  <xsl:variable name="xrefstyle">
    <xsl:apply-templates select="." mode="xrefstyle">
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="referrer" select="$referrer"/>
    </xsl:apply-templates>
  </xsl:variable>
  
  <xsl:call-template name="check.id.unique">
    <xsl:with-param name="linkend" select="@linkend"/>
  </xsl:call-template>

  <xsl:choose>
    <xsl:when test="count($target) = 0">
      <xsl:message>
        <xsl:text>XRef to nonexistent id: </xsl:text>
        <xsl:value-of select="@linkend"/> 
        <xsl:value-of select="@xlink:href"/>
      </xsl:message>
      <xsl:text>???</xsl:text>
    </xsl:when>

    <xsl:when test="@endterm">
      <xsl:variable name="etargets" select="key('id',@endterm)"/>
      <xsl:variable name="etarget" select="$etargets[1]"/>
      <xsl:choose>
        <xsl:when test="count($etarget) = 0">
          <xsl:message>
            <xsl:value-of select="count($etargets)"/>
            <xsl:text>Endterm points to nonexistent ID: </xsl:text>
            <xsl:value-of select="@endterm"/>
          </xsl:message>
          <xsl:text>???</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$etarget" mode="endterm"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="$target/@xreflabel">
      <xsl:call-template name="xref.xreflabel">
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
   
      <xsl:choose>
	<!-- Watch out for the case when there is a xref or link inside 
	     a title. See bugs #1811721 and #1838136. -->
	<xsl:when test="not(ancestor::*[@id = $target/@id] or ancestor::*[@xml:id = $target/@xml:id])">

	  <xsl:apply-templates select="$target" mode="xref-to-prefix">
	    <xsl:with-param name="referrer" select="."/>
	    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
	  </xsl:apply-templates>
	  
	  <xsl:apply-templates select="$target" mode="xref-to">
	    <xsl:with-param name="referrer" select="."/>
	    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
	  </xsl:apply-templates>
	  
	  <xsl:apply-templates select="$target" mode="xref-to-suffix">
	    <xsl:with-param name="referrer" select="."/>
	    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
	  </xsl:apply-templates>
	</xsl:when>
	
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- ============================================================ -->

<xsl:template mode="title.markup" match="d:toc">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:choose>
    <xsl:when test="d:title|d:info/d:title">
      <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'TableofContents'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

