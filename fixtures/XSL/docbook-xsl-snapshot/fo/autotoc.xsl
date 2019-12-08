<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template name="set.toc">

  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes" select="d:book|d:set|d:setindex|d:article"/>

  <xsl:if test="$nodes">
    <fo:block id="toc...{$id}"
              xsl:use-attribute-sets="toc.margin.properties">
      <xsl:if test="$axf.extensions != 0 and 
                    $xsl1.1.bookmarks = 0 and 
                    $show.bookmarks != 0">
        <xsl:attribute name="axf:outline-level">1</xsl:attribute>
        <xsl:attribute name="axf:outline-expand">false</xsl:attribute>
        <xsl:attribute name="axf:outline-title">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'TableofContents'"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="table.of.contents.titlepage"/>
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="division.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes"
                select="$toc-context/d:part
                        |$toc-context/d:reference
                        |$toc-context/d:preface
                        |$toc-context/d:chapter
                        |$toc-context/d:appendix
                        |$toc-context/d:article
                        |$toc-context/d:topic
                        |$toc-context/d:bibliography
                        |$toc-context/d:glossary
                        |$toc-context/d:index"/>

  <xsl:if test="$nodes">
    <fo:block id="toc...{$cid}"
              xsl:use-attribute-sets="toc.margin.properties">
      <xsl:if test="$axf.extensions != 0 and 
                    $xsl1.1.bookmarks = 0 and 
                    $show.bookmarks != 0">
        <xsl:attribute name="axf:outline-level">1</xsl:attribute>
        <xsl:attribute name="axf:outline-expand">false</xsl:attribute>
        <xsl:attribute name="axf:outline-title">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'TableofContents'"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$toc.title.p">
        <xsl:call-template name="table.of.contents.titlepage"/>
      </xsl:if>
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="component.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes" select="d:section|d:sect1|d:refentry
                                     |d:article|d:topic|d:bibliography|d:glossary
                                     |d:qandaset[$qanda.in.toc != 0]
                                     |d:appendix|d:index"/>
  <xsl:if test="$nodes">
    <fo:block id="toc...{$id}"
              xsl:use-attribute-sets="toc.margin.properties">
      <xsl:if test="$toc.title.p">
        <xsl:call-template name="table.of.contents.titlepage"/>
      </xsl:if>
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="component.toc.separator">
  <!-- Customize to output something between
       component.toc and first output -->
</xsl:template>

<xsl:template name="section.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes"
                select="d:section|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:refentry
                        |d:qandaset[$qanda.in.toc != 0]
                        |d:bridgehead[$bridgehead.in.toc != 0]"/>

  <xsl:variable name="level">
    <xsl:call-template name="section.level"/>
  </xsl:variable>

  <xsl:if test="$nodes">
    <fo:block id="toc...{$id}"
              xsl:use-attribute-sets="toc.margin.properties">

      <xsl:if test="$toc.title.p">
        <xsl:call-template name="section.heading">
          <xsl:with-param name="level" select="$level + 1"/>
          <xsl:with-param name="title">
            <fo:block space-after="0.5em">
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'TableofContents'"/>
              </xsl:call-template>
            </fo:block>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="section.toc.separator">
  <!-- Customize to output something between
       section.toc and first output -->
</xsl:template>
<!-- ==================================================================== -->

<xsl:template name="toc.line">
  <xsl:param name="toc-context" select="NOTANODE"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>

  <fo:block xsl:use-attribute-sets="toc.line.properties">
    <fo:inline keep-with-next.within-line="always">
      <fo:basic-link internal-destination="{$id}">
        <xsl:if test="$label != ''">
          <xsl:copy-of select="$label"/>
          <xsl:value-of select="$autotoc.label.separator"/>
        </xsl:if>
        <xsl:apply-templates select="." mode="titleabbrev.markup"/>
      </fo:basic-link>
    </fo:inline>
    <fo:inline keep-together.within-line="always">
      <fo:leader xsl:use-attribute-sets="toc.leader.properties"/>
      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </fo:inline>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->
<xsl:template name="qandaset.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes" select="d:qandadiv|d:qandaentry"/>

  <xsl:if test="$nodes">
    <fo:block id="toc...{$id}"
              xsl:use-attribute-sets="toc.margin.properties">
      <xsl:if test="$toc.title.p">
        <xsl:call-template name="table.of.contents.titlepage"/>
      </xsl:if>
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="qandaset.toc.separator">
  <!-- Customize to output something between
       qandaset.toc and first output -->
</xsl:template>

<xsl:template match="d:qandadiv" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="nodes" select="d:qandadiv|d:qandaentry"/>

  <xsl:if test="$nodes">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>

      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:qandaentry" mode="toc">
  <xsl:apply-templates select="d:question" mode="toc"/>
</xsl:template>

<xsl:template match="d:question" mode="toc">
  <xsl:variable name="firstchunk">
    <!-- Use a titleabbrev or title if available -->
    <xsl:choose>
      <xsl:when test="../d:blockinfo/d:titleabbrev">
        <xsl:apply-templates select="../d:blockinfo/d:titleabbrev[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:blockinfo/d:title">
        <xsl:apply-templates select="../d:blockinfo/d:title[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:info/d:titleabbrev">
        <xsl:apply-templates select="../d:info/d:titleabbrev[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:titleabbrev">
        <xsl:apply-templates select="../d:titleabbrev[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:info/d:title">
        <xsl:apply-templates select="../d:info/d:title[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:title">
        <xsl:apply-templates select="../d:title[1]/node()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="(*[local-name(.)!='label'])[1]/node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="deflabel">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*[@defaultlabel]">
        <xsl:value-of select="(ancestor-or-self::*[@defaultlabel])[last()]
                              /@defaultlabel"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$qanda.defaultlabel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>

  <fo:block xsl:use-attribute-sets="toc.line.properties"
            end-indent="{$toc.indent.width}pt"
            last-line-end-indent="-{$toc.indent.width}pt">
    <xsl:attribute name="margin-{$direction.align.start}">3em</xsl:attribute>
    <xsl:attribute name="text-indent">-3em</xsl:attribute>
    <fo:inline keep-with-next.within-line="always">
      <fo:basic-link internal-destination="{$id}">
        <xsl:if test="$label != ''">
          <xsl:copy-of select="$label"/>
          <xsl:if test="$deflabel = 'number' and not(d:label)">
            <xsl:value-of select="$autotoc.label.separator"/>
          </xsl:if>
	  <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:copy-of select="$firstchunk"/>
      </fo:basic-link>
    </fo:inline>
    <fo:inline keep-together.within-line="always">
      <fo:leader xsl:use-attribute-sets="toc.leader.properties"/>
      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </fo:inline>
  </fo:block>

</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:book|d:setindex" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="nodes" select="d:glossary|d:bibliography|d:preface|d:chapter
                                     |d:reference|d:part|d:article|d:topic|d:appendix|d:index"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.max.depth > $depth.from.context
                and $nodes">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>

      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:set" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="nodes" select="d:set|d:book|d:setindex|d:article"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.max.depth > $depth.from.context
                and $nodes">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>
      
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:part" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="nodes" select="d:chapter|d:appendix|d:preface|d:reference|
                                     d:refentry|d:article|d:topic|d:index|d:glossary|
                                     d:bibliography"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.max.depth > $depth.from.context
                and $nodes">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>
      
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:reference" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:if test="$toc.section.depth > 0
                and $toc.max.depth > $depth.from.context
                and d:refentry">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>
              
      <xsl:apply-templates select="d:refentry" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:refentry" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:preface|d:chapter|d:appendix|d:article"
              mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="nodes" select="d:section|d:sect1
                                     |d:qandaset[$qanda.in.toc != 0]
                                     |d:simplesect[$simplesect.in.toc != 0]
                                     |d:topic
                                     |d:refentry|d:appendix"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 0 
                and $toc.max.depth > $depth.from.context
                and $nodes">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>
              
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:sect1" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 1 
                and $toc.max.depth > $depth.from.context
                and d:sect2">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>
              
      <xsl:apply-templates select="d:sect2|d:qandaset[$qanda.in.toc != 0]"
                           mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:sect2" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="reldepth"
                select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 2 
                and $toc.max.depth > $depth.from.context
                and d:sect3">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:call-template name="set.toc.indent">
          <xsl:with-param name="reldepth" select="$reldepth"/>
        </xsl:call-template>
      </xsl:attribute>
              
      <xsl:apply-templates select="d:sect3|d:qandaset[$qanda.in.toc != 0]"
                           mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:sect3" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="reldepth"
                select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 3 
                and $toc.max.depth > $depth.from.context
                and d:sect4">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:call-template name="set.toc.indent">
          <xsl:with-param name="reldepth" select="$reldepth"/>
        </xsl:call-template>
      </xsl:attribute>
              
      <xsl:apply-templates select="d:sect4|d:qandaset[$qanda.in.toc != 0]"
                           mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:sect4" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="reldepth"
                select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 4 
                and $toc.max.depth > $depth.from.context
                and d:sect5">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:call-template name="set.toc.indent">
          <xsl:with-param name="reldepth" select="$reldepth"/>
        </xsl:call-template>
      </xsl:attribute>
              
      <xsl:apply-templates select="d:sect5|d:qandaset[$qanda.in.toc != 0]"
                           mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:sect5|d:simplesect" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:topic" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="set.toc.indent">
  <xsl:param name="reldepth"/>

  <xsl:variable name="depth">
    <xsl:choose>
      <xsl:when test="$reldepth != ''">
        <xsl:value-of select="$reldepth"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(ancestor::*)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$fop.extensions != 0">
       <xsl:value-of select="concat($depth*$toc.indent.width, 'pt')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($toc.indent.width, 'pt')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="d:section" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="depth" select="count(ancestor::d:section) + 1"/>
  <xsl:variable name="reldepth"
                select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth &gt;= $depth">
    <xsl:call-template name="toc.line">
      <xsl:with-param name="toc-context" select="$toc-context"/>
    </xsl:call-template>

    <xsl:if test="$toc.section.depth > $depth 
                  and $toc.max.depth > $depth.from.context
                  and d:section">
      <fo:block id="toc.{$cid}.{$id}">
        <xsl:attribute name="margin-{$direction.align.start}">
          <xsl:call-template name="set.toc.indent">
            <xsl:with-param name="reldepth" select="$reldepth"/>
          </xsl:call-template>
        </xsl:attribute>
                
        <xsl:apply-templates select="d:section|d:qandaset[$qanda.in.toc != 0]"
                           mode="toc">
          <xsl:with-param name="toc-context" select="$toc-context"/>
        </xsl:apply-templates>
      </fo:block>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="d:bibliography|d:glossary"
              mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:index" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:if test="* or $generate.index != 0">
    <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="d:title" mode="toc">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="list.of.titles">
  <xsl:param name="titles" select="'table'"/>
  <xsl:param name="nodes" select=".//d:table"/>
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:if test="$nodes">
    <fo:block id="lot...{$titles}...{$id}"
        xsl:use-attribute-sets="toc.margin.properties">
      <xsl:choose>
        <xsl:when test="$titles='table'">
          <xsl:call-template name="list.of.tables.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='figure'">
          <xsl:call-template name="list.of.figures.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='equation'">
          <xsl:call-template name="list.of.equations.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='example'">
          <xsl:call-template name="list.of.examples.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='procedure'">
          <xsl:call-template name="list.of.procedures.titlepage"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.unknowns.titlepage"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="component.list.of.titles">
  <xsl:param name="titles" select="'table'"/>
  <xsl:param name="nodes" select=".//d:table"/>
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:if test="$nodes">
    <fo:block id="lot...{$titles}...{$id}">
      <xsl:choose>
        <xsl:when test="$titles='table'">
          <xsl:call-template name="component.list.of.tables.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='figure'">
          <xsl:call-template name="component.list.of.figures.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='equation'">
          <xsl:call-template name="component.list.of.equations.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='example'">
          <xsl:call-template name="component.list.of.examples.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='procedure'">
          <xsl:call-template name="component.list.of.procedures.titlepage"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="component.list.of.unknowns.titlepage"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:figure|d:table|d:example|d:equation|d:procedure" mode="toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<!-- qandaset handled like a section when qanda.in.toc is set -->
<xsl:template match="d:qandaset" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="depth" select="count(ancestor::d:section) + 1"/>
  <xsl:variable name="reldepth"
                select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth &gt;= $depth">
    <xsl:call-template name="toc.line">
      <xsl:with-param name="toc-context" select="$toc-context"/>
    </xsl:call-template>

    <xsl:if test="$toc.section.depth > $depth 
                  and $toc.max.depth > $depth.from.context
                  and (child::d:qandadiv or child::d:qandaentry)">
      <fo:block id="toc.{$cid}.{$id}">
        <xsl:attribute name="margin-{$direction.align.start}">
          <xsl:call-template name="set.toc.indent">
            <xsl:with-param name="reldepth" select="$reldepth"/>
          </xsl:call-template>
        </xsl:attribute>
                
        <xsl:apply-templates select="d:qandadiv|d:qandaentry" mode="toc">
          <xsl:with-param name="toc-context" select="$toc-context"/>
        </xsl:apply-templates>
      </fo:block>
    </xsl:if>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

