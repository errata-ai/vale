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

<xsl:template match="d:section">
  <xsl:variable name="depth" select="count(ancestor::d:section)+1"/>

  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="section.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')
                  and $depth &lt;= $generate.section.toc.level">
      <xsl:call-template name="section.toc">
        <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="process.chunk.footnotes"/>
  </xsl:element>
</xsl:template>

<xsl:template name="section.title">
  <!-- the context node should be the title of a section when called -->
  <xsl:variable name="section" select="(ancestor::d:section
                                        |ancestor::d:simplesect
                                        |ancestor::d:sect1
                                        |ancestor::d:sect2
                                        |ancestor::d:sect3
                                        |ancestor::d:sect4
                                        |ancestor::d:sect5)[last()]"/>

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

  <xsl:call-template name="section.heading">
    <xsl:with-param name="section" select="$section"/>
    <xsl:with-param name="level" select="$level"/>
    <xsl:with-param name="title">
      <xsl:apply-templates select="$section" mode="object.title.markup">
        <xsl:with-param name="allow-anchors" select="1"/>
      </xsl:apply-templates>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:section/d:title
                    |d:section/d:info/d:title
                    |d:sectioninfo/d:title"
              mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="d:sect1">
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="@renderas = 'sect2'">
        <xsl:call-template name="sect2.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect3'">
        <xsl:call-template name="sect3.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect4'">
        <xsl:call-template name="sect4.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect5'">
        <xsl:call-template name="sect5.titlepage"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="sect1.titlepage"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')
                  and $generate.section.toc.level &gt;= 1">
      <xsl:call-template name="section.toc">
        <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="process.chunk.footnotes"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:sect1/d:title
                    |d:sect1/d:info/d:title
                    |d:sect1info/d:title"
              mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="d:sect2">
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="@renderas = 'sect1'">
        <xsl:call-template name="sect1.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect3'">
        <xsl:call-template name="sect3.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect4'">
        <xsl:call-template name="sect4.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect5'">
        <xsl:call-template name="sect5.titlepage"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="sect2.titlepage"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')
                  and $generate.section.toc.level &gt;= 2">
      <xsl:call-template name="section.toc">
        <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="process.chunk.footnotes"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:sect2/d:title
                    |d:sect2/d:info/d:title
                    |d:sect2info/d:title"
              mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="d:sect3">
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="@renderas = 'sect1'">
        <xsl:call-template name="sect1.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect2'">
        <xsl:call-template name="sect2.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect4'">
        <xsl:call-template name="sect4.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect5'">
        <xsl:call-template name="sect5.titlepage"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="sect3.titlepage"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')
                  and $generate.section.toc.level &gt;= 3">
      <xsl:call-template name="section.toc">
        <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="process.chunk.footnotes"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:sect3/d:title
                    |d:sect3/d:info/d:title
                    |d:sect3info/d:title"
              mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="d:sect4">
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="@renderas = 'sect1'">
        <xsl:call-template name="sect1.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect2'">
        <xsl:call-template name="sect2.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect3'">
        <xsl:call-template name="sect3.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect5'">
        <xsl:call-template name="sect5.titlepage"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="sect4.titlepage"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')
                  and $generate.section.toc.level &gt;= 4">
      <xsl:call-template name="section.toc">
        <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="process.chunk.footnotes"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:sect4/d:title
                    |d:sect4/d:info/d:title
                    |d:sect4info/d:title"
              mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="d:sect5">
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="@renderas = 'sect1'">
        <xsl:call-template name="sect1.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect2'">
        <xsl:call-template name="sect2.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect3'">
        <xsl:call-template name="sect3.titlepage"/>
      </xsl:when>
      <xsl:when test="@renderas = 'sect4'">
        <xsl:call-template name="sect4.titlepage"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="sect5.titlepage"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="contains($toc.params, 'toc')
                  and $generate.section.toc.level &gt;= 5">
      <xsl:call-template name="section.toc">
        <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
      </xsl:call-template>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="process.chunk.footnotes"/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:sect5/d:title
                    |d:sect5/d:info/d:title
                    |d:sect5info/d:title"
              mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="d:simplesect">
  <xsl:call-template name="id.warning"/>

  <xsl:element name="{$div.element}">
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="simplesect.titlepage"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:simplesect/d:title|d:simplesect/d:info/d:title"
              mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="d:section/d:title"></xsl:template>
<xsl:template match="d:section/d:titleabbrev"></xsl:template>
<xsl:template match="d:section/d:subtitle"></xsl:template>
<xsl:template match="d:sectioninfo"></xsl:template>
<xsl:template match="d:section/d:info"></xsl:template>

<xsl:template match="d:sect1/d:title"></xsl:template>
<xsl:template match="d:sect1/d:titleabbrev"></xsl:template>
<xsl:template match="d:sect1/d:subtitle"></xsl:template>
<xsl:template match="d:sect1info"></xsl:template>
<xsl:template match="d:sect1/d:info"></xsl:template>

<xsl:template match="d:sect2/d:title"></xsl:template>
<xsl:template match="d:sect2/d:subtitle"></xsl:template>
<xsl:template match="d:sect2/d:titleabbrev"></xsl:template>
<xsl:template match="d:sect2info"></xsl:template>
<xsl:template match="d:sect2/d:info"></xsl:template>

<xsl:template match="d:sect3/d:title"></xsl:template>
<xsl:template match="d:sect3/d:subtitle"></xsl:template>
<xsl:template match="d:sect3/d:titleabbrev"></xsl:template>
<xsl:template match="d:sect3info"></xsl:template>
<xsl:template match="d:sect3/d:info"></xsl:template>

<xsl:template match="d:sect4/d:title"></xsl:template>
<xsl:template match="d:sect4/d:subtitle"></xsl:template>
<xsl:template match="d:sect4/d:titleabbrev"></xsl:template>
<xsl:template match="d:sect4info"></xsl:template>
<xsl:template match="d:sect4/d:info"></xsl:template>

<xsl:template match="d:sect5/d:title"></xsl:template>
<xsl:template match="d:sect5/d:subtitle"></xsl:template>
<xsl:template match="d:sect5/d:titleabbrev"></xsl:template>
<xsl:template match="d:sect5info"></xsl:template>
<xsl:template match="d:sect5/d:info"></xsl:template>

<xsl:template match="d:simplesect/d:title"></xsl:template>
<xsl:template match="d:simplesect/d:subtitle"></xsl:template>
<xsl:template match="d:simplesect/d:titleabbrev"></xsl:template>
<xsl:template match="d:simplesect/d:info"></xsl:template>

<!-- ==================================================================== -->

<xsl:template name="section.heading">
  <xsl:param name="section" select="."/>
  <xsl:param name="level" select="1"/>
  <xsl:param name="allow-anchors" select="1"/>
  <xsl:param name="title"/>
  <xsl:param name="class" select="'title'"/>

  <xsl:variable name="id">
    <xsl:choose>
      <!-- Make sure the subtitle doesn't get the same id as the title -->
      <xsl:when test="self::d:subtitle">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="."/>
        </xsl:call-template>
      </xsl:when>
      <!-- if title is in an *info wrapper, get the grandparent -->
      <xsl:when test="contains(local-name(..), 'info')">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="../.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- HTML H level is one higher than section level -->
  <xsl:variable name="hlevel">
    <xsl:choose>
      <!-- highest valid HTML H level is H6; so anything nested deeper
           than 5 levels down just becomes H6 -->
      <xsl:when test="$level &gt; 5">6</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$level + 1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:element name="h{$hlevel}">
    <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
    <xsl:if test="$css.decoration != '0'">
      <xsl:if test="$hlevel&lt;3">
        <xsl:attribute name="style">clear: both</xsl:attribute>
      </xsl:if>
    </xsl:if>
    <xsl:if test="$allow-anchors != 0">
      <xsl:call-template name="anchor">
        <xsl:with-param name="node" select="$section"/>
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:copy-of select="$title"/>
  </xsl:element>
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
                      or local-name($container) = 'setindex'">1</xsl:when>
      <xsl:when test="local-name($container) = 'glossdiv'">
        <xsl:value-of select="count(ancestor::d:glossdiv)+1"/>
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
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- HTML H level is one higher than section level -->
  <xsl:variable name="hlevel">
    <xsl:choose>
      <xsl:when test="@renderas = 'sect1'">2</xsl:when>
      <xsl:when test="@renderas = 'sect2'">3</xsl:when>
      <xsl:when test="@renderas = 'sect3'">4</xsl:when>
      <xsl:when test="@renderas = 'sect4'">5</xsl:when>
      <xsl:when test="@renderas = 'sect5'">6</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$clevel + 1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="h{$hlevel}">
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:section/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.subtitle"/>
</xsl:template>

<xsl:template match="d:simplesect/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.subtitle"/>
</xsl:template>

<xsl:template match="d:sect1/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.subtitle"/>
</xsl:template>

<xsl:template match="d:sect2/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.subtitle"/>
</xsl:template>

<xsl:template match="d:sect3/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.subtitle"/>
</xsl:template>

<xsl:template match="d:sect4/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.subtitle"/>
</xsl:template>

<xsl:template match="d:sect5/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.subtitle"/>
</xsl:template>

<xsl:template name="section.subtitle">
  <!-- the context node should be the subtitle of a section when called -->
  <xsl:variable name="section" select="(ancestor::d:section
                                        |ancestor::d:simplesect
                                        |ancestor::d:sect1
                                        |ancestor::d:sect2
                                        |ancestor::d:sect3
                                        |ancestor::d:sect4
                                        |ancestor::d:sect5)[last()]"/>

  <xsl:variable name="level">
    <xsl:call-template name="section.level">
      <xsl:with-param name="node" select="$section"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="section.heading">
    <xsl:with-param name="section" select=".."/>
    <xsl:with-param name="allow-anchors" select="0"/>
    <!-- subtitle heading level one higher than section level -->
    <xsl:with-param name="level" select="$level + 1"/>
    <xsl:with-param name="class" select="'subtitle'"/>
    <xsl:with-param name="title">
      <xsl:apply-templates select="$section" mode="object.subtitle.markup">
        <xsl:with-param name="allow-anchors" select="0"/>
      </xsl:apply-templates>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>

