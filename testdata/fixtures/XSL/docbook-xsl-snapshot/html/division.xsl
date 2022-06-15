<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="d:set">
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}">
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="dir">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="language.attribute"/>
    <xsl:if test="$generate.id.attributes != 0">
      <xsl:attribute name="id">
        <xsl:call-template name="object.id"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:call-template name="set.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="make.lots">
      <xsl:with-param name="toc.params" select="$toc.params"/>
      <xsl:with-param name="toc">
        <xsl:call-template name="set.toc">
          <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:set/d:setinfo"></xsl:template>
<xsl:template match="d:set/d:title"></xsl:template>
<xsl:template match="d:set/d:titleabbrev"></xsl:template>
<xsl:template match="d:set/d:subtitle"></xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:book">
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="book.titlepage"/>

    <xsl:apply-templates select="d:dedication" mode="dedication"/>
    <xsl:apply-templates select="d:acknowledgements" mode="acknowledgements"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="make.lots">
      <xsl:with-param name="toc.params" select="$toc.params"/>
      <xsl:with-param name="toc">
        <xsl:call-template name="division.toc">
          <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:book/d:bookinfo"></xsl:template>
<xsl:template match="d:book/d:info"></xsl:template>
<xsl:template match="d:book/d:title"></xsl:template>
<xsl:template match="d:book/d:titleabbrev"></xsl:template>
<xsl:template match="d:book/d:subtitle"></xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:part">
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="part.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="not(d:partintro) and contains($toc.params, 'toc')">
      <xsl:call-template name="division.toc">
        <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:part" mode="make.part.toc">
  <xsl:param name="toc.title.p" select="true()"/>
  <xsl:call-template name="division.toc">
    <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:reference" mode="make.part.toc">
  <xsl:param name="toc.title.p" select="true()"/>
  <xsl:call-template name="division.toc">
    <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:part/d:docinfo"></xsl:template>
<xsl:template match="d:part/d:partinfo"></xsl:template>
<xsl:template match="d:part/d:info"></xsl:template>
<xsl:template match="d:part/d:title"></xsl:template>
<xsl:template match="d:part/d:titleabbrev"></xsl:template>
<xsl:template match="d:part/d:subtitle"></xsl:template>

<xsl:template match="d:partintro">
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="partintro.titlepage"/>
    <xsl:apply-templates/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="node" select="parent::*"/>
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="contains($toc.params, 'toc')">
      <!-- not ancestor::part because partintro appears in reference -->
      <xsl:apply-templates select="parent::*" mode="make.part.toc">
        <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
      </xsl:apply-templates>
    </xsl:if>
    <xsl:call-template name="process.footnotes"/>
  </div>
</xsl:template>

<xsl:template match="d:partintro/d:title"></xsl:template>
<xsl:template match="d:partintro/d:titleabbrev"></xsl:template>
<xsl:template match="d:partintro/d:subtitle"></xsl:template>

<xsl:template match="d:partintro/d:title" mode="partintro.title.mode">
  <h2>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="d:partintro/d:subtitle" mode="partintro.title.mode">
  <h3>
    <i><xsl:apply-templates/></i>
  </h3>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:book" mode="division.number">
  <xsl:number from="d:set" count="d:book" format="1."/>
</xsl:template>

<xsl:template match="d:part" mode="division.number">
  <xsl:number from="d:book" count="d:part" format="I."/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="division.title">
  <xsl:param name="node" select="."/>

  <h1>
    <xsl:attribute name="class">title</xsl:attribute>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates select="$node" mode="object.title.markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </h1>
</xsl:template>

</xsl:stylesheet>

