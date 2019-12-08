<?xml version="1.0" encoding="ASCII"?><!--This file was created automatically by html2xhtml--><!--from the HTML stylesheets.--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="d" version="1.0">

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- Set to 2 for backwards compatibility -->
<xsl:param name="component.heading.level" select="2"/>

<xsl:template name="component.title">
  <xsl:param name="node" select="."/>

  <!-- This handles the case where a component (bibliography, for example)
       occurs inside a section; will we need parameters for this? -->

  <!-- This "level" is a section level.  To compute <h> level, add 1. -->
  <xsl:variable name="level">
    <xsl:choose>
      <!-- chapters and other book children should get <h1> -->
      <xsl:when test="$node/parent::d:book">0</xsl:when>
      <xsl:when test="ancestor::d:section">
        <xsl:value-of select="count(ancestor::d:section)+1"/>
      </xsl:when>
      <xsl:when test="ancestor::d:sect5">6</xsl:when>
      <xsl:when test="ancestor::d:sect4">5</xsl:when>
      <xsl:when test="ancestor::d:sect3">4</xsl:when>
      <xsl:when test="ancestor::d:sect2">3</xsl:when>
      <xsl:when test="ancestor::d:sect1">2</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="h{$level+1}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:attribute name="class">title</xsl:attribute>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates select="$node" mode="object.title.markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template name="component.subtitle">
  <xsl:param name="node" select="."/>
  <xsl:variable name="subtitle" select="($node/d:docinfo/d:subtitle                         |$node/d:info/d:subtitle                         |$node/d:prefaceinfo/d:subtitle                         |$node/d:chapterinfo/d:subtitle                         |$node/d:appendixinfo/d:subtitle                         |$node/d:articleinfo/d:subtitle                         |$node/d:artheader/d:subtitle                         |$node/d:subtitle)[1]"/>

  <xsl:if test="$subtitle">
    <h3 class="subtitle">
      <xsl:call-template name="id.attribute"/>
      <em>
        <xsl:apply-templates select="$node" mode="object.subtitle.markup"/>
      </em>
    </h3>
  </xsl:if>
</xsl:template>

<xsl:template name="component.separator">
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:dedication" mode="dedication">
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="dedication.titlepage"/>
    <xsl:apply-templates/>
    <xsl:call-template name="process.footnotes"/>
  </div>
</xsl:template>

<xsl:template match="d:dedication/d:title|d:dedication/d:info/d:title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::d:dedication[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:dedication/d:subtitle|d:dedication/d:info/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.subtitle">
    <xsl:with-param name="node" select="ancestor::d:dedication[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:dedication"/> <!-- see mode="dedication" -->
<xsl:template match="d:dedication/d:title"/>
<xsl:template match="d:dedication/d:subtitle"/>
<xsl:template match="d:dedication/d:titleabbrev"/>

<!-- ==================================================================== -->

<xsl:template match="d:acknowledgements" mode="acknowledgements">
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="acknowledgements.titlepage"/>
    <xsl:apply-templates/>
    <xsl:call-template name="process.footnotes"/>
  </div>
</xsl:template>

<xsl:template match="d:acknowledgements/d:title|d:acknowledgements/d:info/d:title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::d:acknowledgements[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:acknowledgements/d:subtitle|d:acknowledgements/d:info/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.subtitle">
    <xsl:with-param name="node" select="ancestor::d:acknowledgements[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:acknowledgements"/> <!-- see mode="acknowledgements" -->
<xsl:template match="d:acknowledgements/d:title"/>
<xsl:template match="d:acknowledgements/d:subtitle"/>
<xsl:template match="d:acknowledgements/d:titleabbrev"/>

<!-- ==================================================================== -->

<xsl:template match="d:colophon">
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="component.separator"/>
    <xsl:call-template name="component.title"/>
    <xsl:call-template name="component.subtitle"/>

    <xsl:apply-templates/>
    <xsl:call-template name="process.footnotes"/>
  </div>
</xsl:template>

<xsl:template match="d:colophon/d:title"/>
<xsl:template match="d:colophon/d:subtitle"/>
<xsl:template match="d:colophon/d:titleabbrev"/>

<!-- ==================================================================== -->

<xsl:template match="d:preface">
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="component.separator"/>
    <xsl:call-template name="preface.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')">
      <xsl:call-template name="component.toc">
        <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="component.toc.separator"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="process.footnotes"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:preface/d:title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::d:preface[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:preface/d:subtitle                      |d:preface/d:prefaceinfo/d:subtitle                      |d:preface/d:info/d:subtitle                      |d:preface/d:docinfo/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.subtitle">
    <xsl:with-param name="node" select="ancestor::d:preface[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:preface/d:docinfo|d:prefaceinfo"/>
<xsl:template match="d:preface/d:info"/>
<xsl:template match="d:preface/d:title"/>
<xsl:template match="d:preface/d:titleabbrev"/>
<xsl:template match="d:preface/d:subtitle"/>

<!-- ==================================================================== -->

<xsl:template match="d:chapter">
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="component.separator"/>
    <xsl:call-template name="chapter.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="contains($toc.params, 'toc')">
      <xsl:call-template name="component.toc">
        <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="component.toc.separator"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="process.footnotes"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:chapter/d:title|d:chapter/d:chapterinfo/d:title|d:chapter/d:info/d:title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::d:chapter[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:chapter/d:subtitle                      |d:chapter/d:chapterinfo/d:subtitle                      |d:chapter/d:info/d:subtitle                      |d:chapter/d:docinfo/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.subtitle">
    <xsl:with-param name="node" select="ancestor::d:chapter[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:chapter/d:docinfo|d:chapterinfo"/>
<xsl:template match="d:chapter/d:info"/>
<xsl:template match="d:chapter/d:title"/>
<xsl:template match="d:chapter/d:titleabbrev"/>
<xsl:template match="d:chapter/d:subtitle"/>

<!-- ==================================================================== -->

<xsl:template match="d:appendix">
  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk"/>
  </xsl:variable>

  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="parent::d:article and $ischunk = 0">
        <xsl:call-template name="section.heading">
          <xsl:with-param name="level" select="1"/>
          <xsl:with-param name="title">
            <xsl:apply-templates select="." mode="object.title.markup"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="component.separator"/>
        <xsl:call-template name="appendix.titlepage"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')">
      <xsl:call-template name="component.toc">
        <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="component.toc.separator"/>
    </xsl:if>

    <xsl:apply-templates/>

    <xsl:if test="not(parent::d:article) or $ischunk != 0">
      <xsl:call-template name="process.footnotes"/>
    </xsl:if>
  </xsl:element>
</xsl:template>

<xsl:template match="d:appendix/d:title|d:appendix/d:appendixinfo/d:title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::d:appendix[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:appendix/d:subtitle                      |d:appendix/d:appendixinfo/d:subtitle                      |d:appendix/d:info/d:subtitle                      |d:appendix/d:docinfo/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.subtitle">
    <xsl:with-param name="node" select="ancestor::d:appendix[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:appendix/d:docinfo|d:appendixinfo"/>
<xsl:template match="d:appendix/d:info"/>
<xsl:template match="d:appendix/d:title"/>
<xsl:template match="d:appendix/d:titleabbrev"/>
<xsl:template match="d:appendix/d:subtitle"/>

<!-- ==================================================================== -->

<xsl:template match="d:article">
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="article.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="make.lots">
      <xsl:with-param name="toc.params" select="$toc.params"/>
      <xsl:with-param name="toc">
        <xsl:call-template name="component.toc">
          <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates/>
    <xsl:call-template name="process.footnotes"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:article/d:title|d:article/d:articleinfo/d:title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::d:article[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:article/d:subtitle                      |d:article/d:articleinfo/d:subtitle                      |d:article/d:info/d:subtitle                      |d:article/d:artheader/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.subtitle">
    <xsl:with-param name="node" select="ancestor::d:article[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:article/d:artheader|d:article/d:articleinfo"/>
<xsl:template match="d:article/d:info"/>
<xsl:template match="d:article/d:title"/>
<xsl:template match="d:article/d:titleabbrev"/>
<xsl:template match="d:article/d:subtitle"/>

<!-- ==================================================================== -->

<xsl:template match="d:topic">
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="topic.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:apply-templates/>

    <xsl:call-template name="process.footnotes"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:topic/d:title|d:topic/d:info/d:title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::d:topic[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:topic/d:subtitle                      |d:topic/d:info/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.subtitle">
    <xsl:with-param name="node" select="ancestor::d:topic[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:topic/d:info"/>
<xsl:template match="d:topic/d:title"/>
<xsl:template match="d:topic/d:titleabbrev"/>
<xsl:template match="d:topic/d:subtitle"/>

</xsl:stylesheet>