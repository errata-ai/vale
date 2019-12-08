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

<xsl:template match="d:reference">
   <!-- If there is a partintro, it triggers the page  sequence -->
   <xsl:if test="not(d:partintro)">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="master-reference">
      <xsl:call-template name="select.pagemaster"/>
    </xsl:variable>

    <fo:page-sequence hyphenate="{$hyphenate}"
                      master-reference="{$master-reference}">
      <xsl:attribute name="language">
        <xsl:call-template name="l10n.language"/>
      </xsl:attribute>
      <xsl:attribute name="format">
        <xsl:call-template name="page.number.format">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="initial-page-number">
        <xsl:call-template name="initial.page.number">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="force-page-count">
        <xsl:call-template name="force.page.count">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="hyphenation-character">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-character'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="hyphenation-push-character-count">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="hyphenation-remain-character-count">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="running.head.mode">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="running.foot.mode">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:apply-templates>

      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="set.flow.properties">
          <xsl:with-param name="element" select="local-name(.)"/>
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:call-template>

        <fo:block id="{$id}">
          <xsl:call-template name="reference.titlepage"/>
        </fo:block>

        <xsl:variable name="toc.params">
          <xsl:call-template name="find.path.params">
            <xsl:with-param name="table" 
                            select="normalize-space($generate.toc)"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="contains($toc.params, 'toc')">
          <xsl:call-template name="component.toc">
            <xsl:with-param name="toc.title.p" 
                            select="contains($toc.params, 'title')"/>
          </xsl:call-template>
          <xsl:call-template name="component.toc.separator"/>
        </xsl:if>

        <!-- Create one page sequence if no pagebreaks needed -->
        <xsl:if test="$refentry.pagebreak = 0">
          <xsl:apply-templates select="d:refentry"/>
        </xsl:if>
      </fo:flow>
    </fo:page-sequence>
  </xsl:if>
  <xsl:apply-templates select="d:partintro"/>
  <xsl:if test="$refentry.pagebreak != 0">
    <xsl:apply-templates select="d:refentry"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:reference" mode="reference.titlepage.mode">
  <xsl:call-template name="reference.titlepage"/>
</xsl:template>

<xsl:template match="d:reference/d:partintro">
  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="ancestor::d:reference"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="master-reference">
    <xsl:call-template name="select.pagemaster"/>
  </xsl:variable>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-reference="{$master-reference}">
    <xsl:attribute name="language">
      <xsl:call-template name="l10n.language"/>
    </xsl:attribute>
    <xsl:attribute name="format">
      <xsl:call-template name="page.number.format">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="initial-page-number">
      <xsl:call-template name="initial.page.number">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="force-page-count">
      <xsl:call-template name="force.page.count">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="hyphenation-character">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-character'"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="hyphenation-push-character-count">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="hyphenation-remain-character-count">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:apply-templates select="." mode="running.head.mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="running.foot.mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>

    <fo:flow flow-name="xsl-region-body">
      <xsl:call-template name="set.flow.properties">
        <xsl:with-param name="element" select="local-name(.)"/>
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>
      <fo:block id="{$id}">
        <xsl:apply-templates select=".." mode="reference.titlepage.mode"/>
      </fo:block>
      <xsl:if test="d:title">
        <xsl:call-template name="partintro.titlepage"/>
      </xsl:if>
      <xsl:apply-templates/>

      <!-- switch contexts to generate any toc -->
      <xsl:for-each select="..">
        <xsl:variable name="toc.params">
          <xsl:call-template name="find.path.params">
            <xsl:with-param name="table" 
                            select="normalize-space($generate.toc)"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="contains($toc.params, 'toc')">
          <xsl:call-template name="component.toc">
            <xsl:with-param name="toc.title.p" 
                            select="contains($toc.params, 'title')"/>
          </xsl:call-template>
          <xsl:call-template name="component.toc.separator"/>
        </xsl:if>
      </xsl:for-each>

      <!-- Create one page sequence if no pagebreaks needed -->
      <xsl:if test="$refentry.pagebreak = 0">
        <xsl:apply-templates select="../d:refentry"/>
      </xsl:if>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="d:reference/d:docinfo|d:refentry/d:refentryinfo"></xsl:template>
<xsl:template match="d:reference/d:info"></xsl:template>
<xsl:template match="d:reference/d:title"></xsl:template>
<xsl:template match="d:reference/d:subtitle"></xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:refentry">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="master-reference">
    <xsl:call-template name="select.pagemaster"/>
  </xsl:variable>

  <xsl:variable name="refentry.content">
    <fo:block id="{$id}">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="not(parent::*) or 
                    (parent::d:reference and $refentry.pagebreak != 0) or
                    parent::d:part">
      <!-- make a page sequence -->
      <fo:page-sequence hyphenate="{$hyphenate}"
                        master-reference="{$master-reference}">
        <xsl:attribute name="language">
          <xsl:call-template name="l10n.language"/>
        </xsl:attribute>
        <xsl:attribute name="format">
          <xsl:call-template name="page.number.format">
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="initial-page-number">
          <xsl:call-template name="initial.page.number">
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="force-page-count">
          <xsl:call-template name="force.page.count">
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="hyphenation-character">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'hyphenation-character'"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="hyphenation-push-character-count">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="hyphenation-remain-character-count">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:apply-templates select="." mode="running.head.mode">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="running.foot.mode">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:apply-templates>

        <fo:flow flow-name="xsl-region-body">
          <xsl:call-template name="set.flow.properties">
            <xsl:with-param name="element" select="local-name(.)"/>
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>

          <xsl:copy-of select="$refentry.content"/>
        </fo:flow>
      </fo:page-sequence>
    </xsl:when>
    <xsl:otherwise>
      <fo:block>
        <xsl:if test="$refentry.pagebreak != 0">
          <xsl:attribute name="break-before">page</xsl:attribute>
        </xsl:if>
        <xsl:copy-of select="$refentry.content"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:refmeta">
  <xsl:apply-templates select=".//d:indexterm"/>
</xsl:template>

<xsl:template match="d:manvolnum">
  <xsl:if test="$refentry.xref.manvolnum != 0">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:refmiscinfo">
</xsl:template>

<xsl:template match="d:refentrytitle">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:refnamediv">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}">

    <!-- if refentry.generate.name is non-zero, then we need to generate a -->
    <!-- localized "Name" subheading for this refnamdiv (unless it has a -->
    <!-- preceding sibling that is a refnamediv, in which case we have already -->
    <!-- generated a "Name" subheading, so we don't need to do it again -->
    <xsl:if test="$refentry.generate.name != 0">
        <xsl:choose>
          <xsl:when test="preceding-sibling::d:refnamediv">
            <!-- no generated title on secondary refnamedivs! -->
          </xsl:when>
          <xsl:otherwise>
            <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
                      xsl:use-attribute-sets="refnamediv.titlepage.recto.style"
                      font-family="{$title.fontset}">
              <!-- Contents of what is now the format.refentry.subheading -->
              <!-- template were formerly intended to be used only to -->
              <!-- process those subsections of Refentry that have "real" -->
              <!-- title children. So as a kludge to get around the fact -->
              <!-- that the template still basically "expects" to be -->
              <!-- processing that kind of a node, when we call the -->
              <!-- template to process generated titles, we must call it -->
              <!-- with values for the "offset" and "section" parameters -->
              <!-- that are different from the default values in the -->
              <!-- format.refentry.subheading template itself. Because -->
              <!-- those defaults are the values appropriate for processing -->
              <!-- "real" title nodes. -->
              <xsl:call-template name="format.refentry.subheading">
                <xsl:with-param name="section" select="self::*"/>
                <xsl:with-param name="offset" select="1"/>
                <xsl:with-param name="gentext.key" select="'RefName'"/>
              </xsl:call-template>
            </fo:block>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <xsl:if test="$refentry.generate.title != 0">
  <xsl:variable name="section.level">
    <xsl:call-template name="refentry.level">
      <xsl:with-param name="node" select="ancestor::d:refentry"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="reftitle">
        <xsl:choose>
          <xsl:when test="../d:refmeta/d:refentrytitle">
            <xsl:apply-templates select="../d:refmeta/d:refentrytitle"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="d:refname[1]"/>
          </xsl:otherwise>
        </xsl:choose>
  </xsl:variable>

  <!-- xsl:use-attribute-sets takes only a Qname, not a variable -->
    <xsl:choose>
      <xsl:when test="preceding-sibling::d:refnamediv">
	<!-- no title on secondary refnamedivs! -->
      </xsl:when>
      <xsl:when test="$section.level = 1">
        <fo:block xsl:use-attribute-sets="refentry.title.properties">
          <fo:block xsl:use-attribute-sets="section.title.level1.properties">
            <xsl:value-of select="$reftitle"/>
          </fo:block>
        </fo:block>
      </xsl:when>
      <xsl:when test="$section.level = 2">
        <fo:block xsl:use-attribute-sets="refentry.title.properties">
          <fo:block xsl:use-attribute-sets="section.title.level2.properties">
            <xsl:value-of select="$reftitle"/>
          </fo:block>
        </fo:block>
      </xsl:when>
      <xsl:when test="$section.level = 3">
        <fo:block xsl:use-attribute-sets="refentry.title.properties">
          <fo:block xsl:use-attribute-sets="section.title.level3.properties">
            <xsl:value-of select="$reftitle"/>
          </fo:block>
        </fo:block>
      </xsl:when>
      <xsl:when test="$section.level = 4">
        <fo:block xsl:use-attribute-sets="refentry.title.properties">
          <fo:block xsl:use-attribute-sets="section.title.level4.properties">
            <xsl:value-of select="$reftitle"/>
          </fo:block>
        </fo:block>
      </xsl:when>
      <xsl:when test="$section.level = 5">
        <fo:block xsl:use-attribute-sets="refentry.title.properties">
          <fo:block xsl:use-attribute-sets="section.title.level5.properties">
            <xsl:value-of select="$reftitle"/>
          </fo:block>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="refentry.title.properties">
          <fo:block xsl:use-attribute-sets="section.title.level6.properties">
            <xsl:value-of select="$reftitle"/>
          </fo:block>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:if>

    <fo:block>
      <xsl:if test="not(following-sibling::d:refnamediv)">
	<xsl:attribute name="space-after">1em</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="d:refname">
  <xsl:if test="not(preceding-sibling::d:refdescriptor)">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::d:refname">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="d:refpurpose">
  <xsl:if test="node()">
    <xsl:text> </xsl:text>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">em-dash</xsl:with-param>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:refdescriptor">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refclass">
  <xsl:if test="$refclass.suppress = 0">
  <fo:block font-weight="bold">
    <xsl:if test="@role">
      <xsl:value-of select="@role"/>
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:refsynopsisdiv">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}">
    <xsl:if test="not(d:refsynopsisdivinfo/d:title|d:docinfo/d:title|d:info/d:title|d:title)">
      <!-- * if we there is no appropriate title for this Refsynopsisdiv, -->
      <!-- * then we need to call format.refentry.subheading to generate one -->
      <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xsl:use-attribute-sets="refsynopsisdiv.titlepage.recto.style"
                font-family="{$title.fontset}">
        <!-- Contents of what is now the format.refentry.subheading -->
        <!-- template were formerly intended to be used only to -->
        <!-- process those subsections of Refentry that have "real" -->
        <!-- title children. So as a kludge to get around the fact -->
        <!-- that the template still basically "expects" to be -->
        <!-- processing that kind of a node, when we call the -->
        <!-- template to process generated titles, we must call it -->
        <!-- with values for the "offset" and "section" parameters -->
        <!-- that are different from the default values in the -->
        <!-- format.refentry.subheading template itself. Because -->
        <!-- those defaults are the values appropriate for processing -->
        <!-- "real" title nodes. -->
        <xsl:call-template name="format.refentry.subheading">
          <xsl:with-param name="section" select="parent::*"/>
          <xsl:with-param name="offset" select="1"/>
          <xsl:with-param name="gentext.key" select="'RefSynopsisDiv'"/>
        </xsl:call-template>
      </fo:block>
    </xsl:if>
    <xsl:call-template name="refsynopsisdiv.titlepage"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:refsection">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}">
    <xsl:call-template name="refsection.titlepage"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:refsect1">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}">
    <xsl:call-template name="refsect1.titlepage"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:refsect2">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}">
    <xsl:call-template name="refsect2.titlepage"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:refsect3">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}">
    <xsl:call-template name="refsect3.titlepage"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:refsynopsisdiv/d:title
                     |d:refsection/d:title
                     |d:refsect1/d:title
                     |d:refsect2/d:title
                     |d:refsect3/d:title">
  <!-- nop; titlepage.mode instead -->
</xsl:template>

<xsl:template match="d:refsynopsisdiv/d:title
                     |d:refsection/d:title
                     |d:refsect1/d:title
                     |d:refsect2/d:title
                     |d:refsect3/d:title
                     |d:refsynopsisdiv/d:info/d:title
                     |d:refsection/d:info/d:title
                     |d:refsect1/d:info/d:title
                     |d:refsect2/d:info/d:title
                     |d:refsect3/d:info/d:title"
              mode="titlepage.mode"
              priority="2">
  <xsl:call-template name="format.refentry.subheading"/>
</xsl:template>

<xsl:template name="format.refentry.subheading">
<!-- This template is now called to process generated titles for -->
<!-- Refnamediv and Refsynopsisdiv, as well as "real" titles for -->
<!-- Refsynopsisdiv, Refsection, and Refsect[1-3]. -->
<!-- -->
<!-- But the contents of this template were formerly intended to be used -->
<!-- only to process those subsections of Refentry that have "real" title -->
<!-- children. So as a kludge to get around the fact that the template -->
<!-- still basically "expects" to be processing that kind of a node, the -->
<!-- "offset" parameter was added and the "section" variable was changed to -->
<!-- a parameter so that when called for a generated title on a Refnamediv -->
<!-- or Refsynopsisdiv, we can call it like this: -->
<!-- -->
<!--     <xsl:call-template name="format.refentry.subheading"> -->
<!--       <xsl:with-param name="section" select="self::*"/> -->
<!--       <xsl:with-param name="offset" select="1"/> -->
<!--       <xsl:with-param name="gentext.key" select="'RefName'"/> -->
<!--     </xsl:call-template> -->
<!-- -->
  <xsl:param name="section" 
             select="(ancestor::d:refsynopsisdiv
                     |ancestor::d:refsection
                     |ancestor::d:refsect1
                     |ancestor::d:refsect2
                     |ancestor::d:refsect3)[last()]"/>
  <xsl:param name="offset" select="0"/>
  <xsl:param name="gentext.key"/>

  <fo:block keep-with-next.within-column="always">
    <xsl:variable name="id">
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$section"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="level">
      <xsl:call-template name="section.level">
        <xsl:with-param name="node" select="$section"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="title">
      <!-- If we have a non-empty value for the $gentext.key param, then we -->
      <!-- generate an appropriate title here. Otherwise, we have a real -->
      <!-- title child, so we copy contents of that to the result tree. -->
      <xsl:choose>
        <xsl:when test="$gentext.key != ''">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="$gentext.key"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$section" mode="object.title.markup">
            <xsl:with-param name="allow-anchors" select="1"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$axf.extensions != 0 and 
                  $xsl1.1.bookmarks = 0 and 
                  $show.bookmarks != 0">
      <xsl:attribute name="axf:outline-level">
        <xsl:value-of select="count(ancestor::*)-1 + $offset"/>
      </xsl:attribute>
      <xsl:attribute name="axf:outline-expand">false</xsl:attribute>
      <xsl:attribute name="axf:outline-title">
        <xsl:value-of select="$title"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:call-template name="section.heading">
      <xsl:with-param name="level" select="$level + $offset"/>
      <xsl:with-param name="title" select="$title"/>
    </xsl:call-template>
  </fo:block>
</xsl:template>

<xsl:template match="d:refsectioninfo|d:refsection/d:info"></xsl:template>
<xsl:template match="d:refsect1info|d:refsect1/d:info"></xsl:template>
<xsl:template match="d:refsect2info|d:refsect2/d:info"></xsl:template>
<xsl:template match="d:refsect3info|d:refsect3/d:info"></xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
