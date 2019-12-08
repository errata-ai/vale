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

<xsl:template match="d:section">
  <xsl:choose>
    <xsl:when test="$rootid = @id or $rootid = @xml:id">
      <xsl:call-template name="section.page.sequence"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="id">
        <xsl:call-template name="object.id"/>
      </xsl:variable>

      <xsl:variable name="renderas">
        <xsl:choose>
          <xsl:when test="@renderas = 'sect1'">1</xsl:when>
          <xsl:when test="@renderas = 'sect2'">2</xsl:when>
          <xsl:when test="@renderas = 'sect3'">3</xsl:when>
          <xsl:when test="@renderas = 'sect4'">4</xsl:when>
          <xsl:when test="@renderas = 'sect5'">5</xsl:when>
          <xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="level">
        <xsl:choose>
          <xsl:when test="$renderas != ''">
            <xsl:value-of select="$renderas"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="section.level"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- xsl:use-attribute-sets takes only a Qname, not a variable -->
      <xsl:choose>
        <xsl:when test="$level = 1">
          <xsl:element name="fo:{$section.container.element}"
		       use-attribute-sets="section.level1.properties">
            <xsl:attribute name="id"><xsl:value-of 
                                select="$id"/></xsl:attribute>
            <xsl:call-template name="section.content"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$level = 2">
          <xsl:element name="fo:{$section.container.element}"
		       use-attribute-sets="section.level2.properties">
            <xsl:attribute name="id"><xsl:value-of 
                                select="$id"/></xsl:attribute>
            <xsl:call-template name="section.content"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$level = 3">
          <xsl:element name="fo:{$section.container.element}"
                       use-attribute-sets="section.level3.properties">
            <xsl:attribute name="id"><xsl:value-of 
                                select="$id"/></xsl:attribute>
            <xsl:call-template name="section.content"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$level = 4">
          <xsl:element name="fo:{$section.container.element}"
                       use-attribute-sets="section.level4.properties">
            <xsl:attribute name="id"><xsl:value-of 
                                select="$id"/></xsl:attribute>
            <xsl:call-template name="section.content"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$level = 5">
          <xsl:element name="fo:{$section.container.element}"
		       use-attribute-sets="section.level5.properties">
            <xsl:attribute name="id"><xsl:value-of 
                                select="$id"/></xsl:attribute>
            <xsl:call-template name="section.content"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="fo:{$section.container.element}"
		       use-attribute-sets="section.level6.properties">
            <xsl:attribute name="id"><xsl:value-of 
                                select="$id"/></xsl:attribute>
            <xsl:call-template name="section.content"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="section.content">
  <xsl:call-template name="section.titlepage"/>

  <xsl:variable name="toc.params">
    <xsl:call-template name="find.path.params">
      <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="contains($toc.params, 'toc')
                and (count(ancestor::d:section)+1) &lt;=
		$generate.section.toc.level">
    <xsl:call-template name="section.toc">
      <xsl:with-param name="toc.title.p" 
                      select="contains($toc.params, 'title')"/>
    </xsl:call-template>
   <xsl:call-template name="section.toc.separator"/>
  </xsl:if>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="/d:section" name="section.page.sequence">
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

      <fo:block id="{$id}" 
            xsl:use-attribute-sets="section.level1.properties">
        <xsl:call-template name="section.titlepage"/>
      </fo:block>

      <xsl:variable name="toc.params">
        <xsl:call-template name="find.path.params">
          <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:if test="contains($toc.params, 'toc')
                    and (count(ancestor::d:section)+1) &lt;=
		    $generate.section.toc.level">
        <xsl:call-template name="section.toc">
          <xsl:with-param name="toc.title.p" 
                          select="contains($toc.params, 'title')"/>
        </xsl:call-template>
        <xsl:call-template name="section.toc.separator"/>
      </xsl:if>

      <xsl:apply-templates/>
   </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="d:section/d:title
                     |d:simplesect/d:title
                     |d:sect1/d:title
                     |d:sect2/d:title
                     |d:sect3/d:title
                     |d:sect4/d:title
                     |d:sect5/d:title
                     |d:section/d:info/d:title
                     |d:simplesect/d:info/d:title
                     |d:sect1/d:info/d:title
                     |d:sect2/d:info/d:title
                     |d:sect3/d:info/d:title
                     |d:sect4/d:info/d:title
                     |d:sect5/d:info/d:title
                     |d:section/d:sectioninfo/d:title
                     |d:sect1/d:sect1info/d:title
                     |d:sect2/d:sect2info/d:title
                     |d:sect3/d:sect3info/d:title
                     |d:sect4/d:sect4info/d:title
                     |d:sect5/d:sect5info/d:title"
              mode="titlepage.mode"
              priority="2">

  <xsl:variable name="section" 
                select="(ancestor::d:section |
                        ancestor::d:simplesect |
                        ancestor::d:sect1 |
                        ancestor::d:sect2 |
                        ancestor::d:sect3 |
                        ancestor::d:sect4 |
                        ancestor::d:sect5)[position() = last()]"/>

  <fo:block keep-with-next.within-column="always">
    <xsl:variable name="id">
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$section"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="renderas">
      <xsl:choose>
        <xsl:when test="$section/@renderas = 'sect1'">1</xsl:when>
        <xsl:when test="$section/@renderas = 'sect2'">2</xsl:when>
        <xsl:when test="$section/@renderas = 'sect3'">3</xsl:when>
        <xsl:when test="$section/@renderas = 'sect4'">4</xsl:when>
        <xsl:when test="$section/@renderas = 'sect5'">5</xsl:when>
        <xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  
    <xsl:variable name="level">
      <xsl:choose>
        <xsl:when test="$renderas != ''">
          <xsl:value-of select="$renderas"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="section.level">
            <xsl:with-param name="node" select="$section"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="marker">
      <xsl:choose>
        <xsl:when test="$level &lt;= $marker.section.level">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="title">
      <xsl:apply-templates select="$section" mode="object.title.markup">
        <xsl:with-param name="allow-anchors" select="1"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="marker.title">
      <xsl:apply-templates select="$section" mode="titleabbrev.markup">
        <xsl:with-param name="allow-anchors" select="0"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:if test="$axf.extensions != 0 and 
                  $xsl1.1.bookmarks = 0 and 
                  $show.bookmarks != 0">
      <xsl:attribute name="axf:outline-level">
        <xsl:value-of select="count(ancestor::*)-1"/>
      </xsl:attribute>
      <xsl:attribute name="axf:outline-expand">false</xsl:attribute>
      <xsl:attribute name="axf:outline-title">
        <xsl:value-of select="normalize-space($title)"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:call-template name="section.heading">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="marker" select="$marker"/>
      <xsl:with-param name="marker.title" select="$marker.title"/>
    </xsl:call-template>
  </fo:block>
</xsl:template>

<xsl:template match="d:sect1">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:element name="fo:{$section.container.element}"
               use-attribute-sets="section.level1.properties">
    <xsl:attribute name="id"><xsl:value-of 
                        select="$id"/></xsl:attribute>
    <xsl:call-template name="sect1.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')
                  and $generate.section.toc.level &gt;= 1">
      <xsl:call-template name="section.toc">
        <xsl:with-param name="toc.title.p" 
                        select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:if>

    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="/d:sect1">
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

      <fo:block id="{$id}" 
                xsl:use-attribute-sets="section.level1.properties">
        <xsl:call-template name="sect1.titlepage"/>
      </fo:block>

      <xsl:variable name="toc.params">
        <xsl:call-template name="find.path.params">
          <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:if test="contains($toc.params, 'toc')
                    and $generate.section.toc.level &gt;= 1">
        <xsl:call-template name="section.toc">
          <xsl:with-param name="toc.title.p" 
                          select="contains($toc.params, 'title')"/>
        </xsl:call-template>
        <xsl:call-template name="section.toc.separator"/>
      </xsl:if>

      <xsl:apply-templates/>
   </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="d:sect2">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:element name="fo:{$section.container.element}"
	       use-attribute-sets="section.level2.properties">
    <xsl:attribute name="id"><xsl:value-of 
                        select="$id"/></xsl:attribute>
    <xsl:call-template name="sect2.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')
                   and $generate.section.toc.level &gt;= 2">
      <xsl:call-template name="section.toc">
        <xsl:with-param name="toc.title.p" 
                        select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:if>

    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:sect3">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:element name="fo:{$section.container.element}"
	       use-attribute-sets="section.level3.properties">
    <xsl:attribute name="id"><xsl:value-of 
                        select="$id"/></xsl:attribute>
    <xsl:call-template name="sect3.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')
                  and $generate.section.toc.level &gt;= 3">
      <xsl:call-template name="section.toc">
        <xsl:with-param name="toc.title.p" 
                        select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:if>

    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:sect4">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:element name="fo:{$section.container.element}"
	       use-attribute-sets="section.level4.properties">
    <xsl:attribute name="id"><xsl:value-of 
                        select="$id"/></xsl:attribute>
    <xsl:call-template name="sect4.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')
                  and $generate.section.toc.level &gt;= 4">
      <xsl:call-template name="section.toc">
        <xsl:with-param name="toc.title.p" 
                        select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:if>

    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:sect5">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:element name="fo:{$section.container.element}"
	       use-attribute-sets="section.level5.properties">
    <xsl:attribute name="id"><xsl:value-of 
                        select="$id"/></xsl:attribute>
    <xsl:call-template name="sect5.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')
                  and $generate.section.toc.level &gt;= 5">
      <xsl:call-template name="section.toc">
        <xsl:with-param name="toc.title.p" 
                        select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:if>

    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:simplesect">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:element name="fo:{$section.container.element}">
    <xsl:attribute name="id"><xsl:value-of 
                        select="$id"/></xsl:attribute>
    <xsl:call-template name="simplesect.titlepage"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:sectioninfo"></xsl:template>
<xsl:template match="d:section/d:info"></xsl:template>
<xsl:template match="d:section/d:title"></xsl:template>
<xsl:template match="d:section/d:titleabbrev"></xsl:template>
<xsl:template match="d:section/d:subtitle"></xsl:template>

<xsl:template match="d:sect1info"></xsl:template>
<xsl:template match="d:sect1/d:info"></xsl:template>
<xsl:template match="d:sect1/d:title"></xsl:template>
<xsl:template match="d:sect1/d:titleabbrev"></xsl:template>
<xsl:template match="d:sect1/d:subtitle"></xsl:template>

<xsl:template match="d:sect2info"></xsl:template>
<xsl:template match="d:sect2/d:info"></xsl:template>
<xsl:template match="d:sect2/d:title"></xsl:template>
<xsl:template match="d:sect2/d:titleabbrev"></xsl:template>
<xsl:template match="d:sect2/d:subtitle"></xsl:template>

<xsl:template match="d:sect3info"></xsl:template>
<xsl:template match="d:sect3/d:info"></xsl:template>
<xsl:template match="d:sect3/d:title"></xsl:template>
<xsl:template match="d:sect3/d:titleabbrev"></xsl:template>
<xsl:template match="d:sect3/d:subtitle"></xsl:template>

<xsl:template match="d:sect4info"></xsl:template>
<xsl:template match="d:sect4/d:info"></xsl:template>
<xsl:template match="d:sect4/d:title"></xsl:template>
<xsl:template match="d:sect4/d:titleabbrev"></xsl:template>
<xsl:template match="d:sect4/d:subtitle"></xsl:template>

<xsl:template match="d:sect5info"></xsl:template>
<xsl:template match="d:sect5/d:info"></xsl:template>
<xsl:template match="d:sect5/d:title"></xsl:template>
<xsl:template match="d:sect5/d:titleabbrev"></xsl:template>
<xsl:template match="d:sect5/d:subtitle"></xsl:template>

<xsl:template match="d:simplesect/d:info"></xsl:template>
<xsl:template match="d:simplesect/d:title"></xsl:template>
<xsl:template match="d:simplesect/d:titleabbrev"></xsl:template>
<xsl:template match="d:simplesect/d:subtitle"></xsl:template>

<!-- ==================================================================== -->

<xsl:template name="section.heading">
  <xsl:param name="level" select="1"/>
  <xsl:param name="marker" select="1"/>
  <xsl:param name="title"/>
  <xsl:param name="marker.title"/>

  <fo:block xsl:use-attribute-sets="section.title.properties">
    <xsl:if test="$marker != 0">
      <fo:marker marker-class-name="section.head.marker">
        <xsl:copy-of select="$marker.title"/>
      </fo:marker>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$level=1">
        <fo:block xsl:use-attribute-sets="section.title.level1.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=2">
        <fo:block xsl:use-attribute-sets="section.title.level2.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=3">
        <fo:block xsl:use-attribute-sets="section.title.level3.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=4">
        <fo:block xsl:use-attribute-sets="section.title.level4.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=5">
        <fo:block xsl:use-attribute-sets="section.title.level5.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="section.title.level6.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:bridgehead">
  <xsl:variable name="container"
                select="(ancestor::d:appendix
                        |ancestor::d:article
                        |ancestor::d:bibliography
                        |ancestor::d:chapter
                        |ancestor::d:glossary
                        |ancestor::d:glossdiv
                        |ancestor::d:index
                        |ancestor::d:partintro
                        |ancestor::d:preface
                        |ancestor::d:refsect1
                        |ancestor::d:refsect2
                        |ancestor::d:refsect3
                        |ancestor::d:sect1
                        |ancestor::d:sect2
                        |ancestor::d:sect3
                        |ancestor::d:sect4
                        |ancestor::d:sect5
                        |ancestor::d:section
                        |ancestor::d:setindex
                        |ancestor::d:simplesect)[last()]"/>

  <xsl:variable name="clevel">
    <xsl:choose>
      <xsl:when test="local-name($container) = 'appendix'
                      or local-name($container) = 'chapter'
                      or local-name($container) = 'article'
                      or local-name($container) = 'bibliography'
                      or local-name($container) = 'glossary'
                      or local-name($container) = 'index'
                      or local-name($container) = 'partintro'
                      or local-name($container) = 'preface'
                      or local-name($container) = 'setindex'">2</xsl:when>
      <xsl:when test="local-name($container) = 'glossdiv'">
        <xsl:value-of select="count(ancestor::d:glossdiv)+2"/>
      </xsl:when>
      <xsl:when test="local-name($container) = 'sect1'
                      or local-name($container) = 'sect2'
                      or local-name($container) = 'sect3'
                      or local-name($container) = 'sect4'
                      or local-name($container) = 'sect5'
                      or local-name($container) = 'refsect1'
                      or local-name($container) = 'refsect2'
                      or local-name($container) = 'refsect3'
                      or local-name($container) = 'section'
                      or local-name($container) = 'simplesect'">
        <xsl:variable name="slevel">
          <xsl:call-template name="section.level">
            <xsl:with-param name="node" select="$container"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$slevel + 1"/>
      </xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="level">
    <xsl:choose>
      <xsl:when test="@renderas = 'sect1'">1</xsl:when>
      <xsl:when test="@renderas = 'sect2'">2</xsl:when>
      <xsl:when test="@renderas = 'sect3'">3</xsl:when>
      <xsl:when test="@renderas = 'sect4'">4</xsl:when>
      <xsl:when test="@renderas = 'sect5'">5</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$clevel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="marker">
    <xsl:choose>
      <xsl:when test="$level &lt;= $marker.section.level">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="marker.title">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}">
    <xsl:call-template name="section.heading">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title">
        <xsl:apply-templates/>
      </xsl:with-param>
      <xsl:with-param name="marker" select="$marker"/>
      <xsl:with-param name="marker.title" select="$marker.title"/>
    </xsl:call-template>
  </fo:block>
</xsl:template>

</xsl:stylesheet>

