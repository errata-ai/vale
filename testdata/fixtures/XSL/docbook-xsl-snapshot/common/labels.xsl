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

<!-- label markup -->

<doc:mode mode="label.markup" xmlns="">
<refpurpose>Provides access to element labels</refpurpose>
<refdescription id="label.markup-desc">
<para>Processing an element in the
<literal role="mode">label.markup</literal> mode produces the
element label.</para>
<para>Trailing punctuation is not added to the label.
</para>
</refdescription>
</doc:mode>

<!--
     Note that this template is applied to parent of the object being
     referenced, and that object is passed via parameter.
-->
<xsl:template match="*" mode="intralabel.punctuation">
  <xsl:param name="object" select="."/>

  <xsl:text>.</xsl:text>
</xsl:template>

<xsl:template match="*" mode="label.markup">
  <xsl:param name="verbose" select="1"/>
  <xsl:if test="$verbose">
    <xsl:message>
      <xsl:text>Request for label of unexpected element: </xsl:text>
      <xsl:value-of select="local-name(.)"/>
    </xsl:message>
  </xsl:if>
</xsl:template>

<xsl:template match="d:set|d:book" mode="label.markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:part" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="string($part.autolabel) != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$part.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:number from="d:book" count="d:part" format="{$format}"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:partintro" mode="label.markup">
  <!-- no label -->
</xsl:template>

<xsl:template match="d:preface" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="string($preface.autolabel) != 0">
      <xsl:if test="$component.label.includes.part.label != 0 and
                      ancestor::d:part">
        <xsl:variable name="part.label">
          <xsl:apply-templates select="ancestor::d:part"
                               mode="label.markup"/>
        </xsl:variable>
        <xsl:if test="$part.label != ''">
          <xsl:value-of select="$part.label"/>
          <xsl:apply-templates select="ancestor::d:part"
                               mode="intralabel.punctuation">
            <xsl:with-param name="object" select="."/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$preface.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$label.from.part != 0 and ancestor::d:part">
          <xsl:number from="d:part" count="d:preface" format="{$format}" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number from="d:book" count="d:preface" format="{$format}" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:chapter" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="string($chapter.autolabel) != 0">
      <xsl:if test="$component.label.includes.part.label != 0 and
                      ancestor::d:part">
        <xsl:variable name="part.label">
          <xsl:apply-templates select="ancestor::d:part"
                               mode="label.markup"/>
        </xsl:variable>
        <xsl:if test="$part.label != ''">
          <xsl:value-of select="$part.label"/>
          <xsl:apply-templates select="ancestor::d:part"
                               mode="intralabel.punctuation">
            <xsl:with-param name="object" select="."/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$chapter.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$label.from.part != 0 and ancestor::d:part">
          <xsl:number from="d:part" count="d:chapter" format="{$format}" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number from="d:book" count="d:chapter" format="{$format}" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:appendix" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="string($appendix.autolabel) != 0">
      <xsl:if test="$component.label.includes.part.label != 0 and
                      ancestor::d:part">
        <xsl:variable name="part.label">
          <xsl:apply-templates select="ancestor::d:part"
                               mode="label.markup"/>
        </xsl:variable>
        <xsl:if test="$part.label != ''">
          <xsl:value-of select="$part.label"/>
          <xsl:apply-templates select="ancestor::d:part"
                               mode="intralabel.punctuation">
            <xsl:with-param name="object" select="."/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$appendix.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$label.from.part != 0 and ancestor::d:part">
          <xsl:number from="d:part" count="d:appendix" format="{$format}" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number from="d:book|d:article"
                      count="d:appendix" format="{$format}" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:article" mode="label.markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:dedication|d:colophon" mode="label.markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:reference" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="string($reference.autolabel) != 0">
      <xsl:if test="$component.label.includes.part.label != 0 and
                      ancestor::d:part">
        <xsl:variable name="part.label">
          <xsl:apply-templates select="ancestor::d:part"
                               mode="label.markup"/>
        </xsl:variable>
        <xsl:if test="$part.label != ''">
          <xsl:value-of select="$part.label"/>
          <xsl:apply-templates select="ancestor::d:part"
                               mode="intralabel.punctuation">
            <xsl:with-param name="object" select="."/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$reference.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$label.from.part != 0 and ancestor::d:part">
          <xsl:number from="d:part" count="d:reference" format="{$format}" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number from="d:book" count="d:reference" format="{$format}" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:refentry" mode="label.markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:section" mode="label.markup">
  <!-- if this is a nested section, label the parent -->
  <xsl:if test="local-name(..) = 'section'">
    <xsl:variable name="parent.section.label">
      <xsl:call-template name="label.this.section">
        <xsl:with-param name="section" select=".."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$parent.section.label != '0'">
      <xsl:apply-templates select=".." mode="label.markup"/>
      <xsl:apply-templates select=".." mode="intralabel.punctuation">
        <xsl:with-param name="object" select="."/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:if>

  <!-- if the parent is a component, maybe label that too -->
  <xsl:variable name="parent.is.component">
    <xsl:call-template name="is.component">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <!-- does this section get labelled? -->
  <xsl:variable name="label">
    <xsl:call-template name="label.this.section">
      <xsl:with-param name="section" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$section.label.includes.component.label != 0
                and $parent.is.component != 0">
    <xsl:variable name="parent.label">
      <xsl:apply-templates select=".." mode="label.markup"/>
    </xsl:variable>
    <xsl:if test="$parent.label != ''">
      <xsl:apply-templates select=".." mode="label.markup"/>
      <xsl:apply-templates select=".." mode="intralabel.punctuation">
        <xsl:with-param name="object" select="."/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:if>

<!--
  <xsl:message>
    test: <xsl:value-of select="$label"/>, <xsl:number count="d:section"/>
  </xsl:message>
-->

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$label != 0">      
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:number format="{$format}" count="d:section"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:sect1" mode="label.markup">
  <!-- if the parent is a component, maybe label that too -->
  <xsl:variable name="parent.is.component">
    <xsl:call-template name="is.component">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="component.label">
    <xsl:if test="$section.label.includes.component.label != 0
                  and $parent.is.component != 0">
      <xsl:variable name="parent.label">
        <xsl:apply-templates select=".." mode="label.markup"/>
      </xsl:variable>
      <xsl:if test="$parent.label != ''">
        <xsl:apply-templates select=".." mode="label.markup"/>
        <xsl:apply-templates select=".." mode="intralabel.punctuation">
          <xsl:with-param name="object" select="."/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:if>
  </xsl:variable>


  <xsl:variable name="is.numbered">
    <xsl:call-template name="label.this.section"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$is.numbered != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:copy-of select="$component.label"/>
      <xsl:number format="{$format}" count="d:sect1"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:sect2|d:sect3|d:sect4|d:sect5" mode="label.markup">
  <!-- label the parent -->
  <xsl:variable name="parent.section.label">
    <xsl:call-template name="label.this.section">
      <xsl:with-param name="section" select=".."/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$parent.section.label != '0'">
    <xsl:apply-templates select=".." mode="label.markup"/>
    <xsl:apply-templates select=".." mode="intralabel.punctuation">
      <xsl:with-param name="object" select="."/>
    </xsl:apply-templates>
  </xsl:if>

  <xsl:variable name="is.numbered">
    <xsl:call-template name="label.this.section"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$is.numbered != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="local-name(.) = 'sect2'">
          <xsl:number format="{$format}" count="d:sect2"/>
        </xsl:when>
        <xsl:when test="local-name(.) = 'sect3'">
          <xsl:number format="{$format}" count="d:sect3"/>
        </xsl:when>
        <xsl:when test="local-name(.) = 'sect4'">
          <xsl:number format="{$format}" count="d:sect4"/>
        </xsl:when>
        <xsl:when test="local-name(.) = 'sect5'">
          <xsl:number format="{$format}" count="d:sect5"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>label.markup: this can't happen!</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:bridgehead" mode="label.markup">
  <!-- bridgeheads are not normally numbered -->
</xsl:template>

<xsl:template match="d:refsect1" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$section.autolabel != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:number count="d:refsect1" format="{$format}"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:refsect2|d:refsect3" mode="label.markup">
  <!-- label the parent -->
  <xsl:variable name="parent.label">
    <xsl:apply-templates select=".." mode="label.markup"/>
  </xsl:variable>
  <xsl:if test="$parent.label != ''">
    <xsl:apply-templates select=".." mode="label.markup"/>
    <xsl:apply-templates select=".." mode="intralabel.punctuation">
      <xsl:with-param name="object" select="."/>
    </xsl:apply-templates>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$section.autolabel != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="local-name(.) = 'refsect2'">
          <xsl:number count="d:refsect2" format="{$format}"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number count="d:refsect3" format="{$format}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:simplesect" mode="label.markup">
  <!-- if this is a nested section, label the parent -->
  <xsl:if test="local-name(..) = 'section'
                or local-name(..) = 'sect1'
                or local-name(..) = 'sect2'
                or local-name(..) = 'sect3'
                or local-name(..) = 'sect4'
                or local-name(..) = 'sect5'">
    <xsl:variable name="parent.section.label">
      <xsl:apply-templates select=".." mode="label.markup"/>
    </xsl:variable>
    <xsl:if test="$parent.section.label != ''">
      <xsl:apply-templates select=".." mode="label.markup"/>
      <xsl:apply-templates select=".." mode="intralabel.punctuation">
        <xsl:with-param name="object" select="."/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:if>

  <!-- if the parent is a component, maybe label that too -->
  <xsl:variable name="parent.is.component">
    <xsl:call-template name="is.component">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <!-- does this section get labelled? -->
  <xsl:variable name="label">
    <xsl:call-template name="label.this.section">
      <xsl:with-param name="section" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$section.label.includes.component.label != 0
                and $parent.is.component != 0">
    <xsl:variable name="parent.label">
      <xsl:apply-templates select=".." mode="label.markup"/>
    </xsl:variable>
    <xsl:if test="$parent.label != ''">
      <xsl:apply-templates select=".." mode="label.markup"/>
      <xsl:apply-templates select=".." mode="intralabel.punctuation">
        <xsl:with-param name="object" select="."/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$label != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:number format="{$format}" count="d:simplesect"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:topic" mode="label.markup">
  <!-- topics are not numbered by default -->
</xsl:template>

<xsl:template match="d:qandadiv" mode="label.markup">
  <xsl:variable name="lparent" select="(ancestor::d:set
                                       |ancestor::d:book
                                       |ancestor::d:chapter
                                       |ancestor::d:appendix
                                       |ancestor::d:preface
                                       |ancestor::d:section
                                       |ancestor::d:simplesect
                                       |ancestor::d:sect1
                                       |ancestor::d:sect2
                                       |ancestor::d:sect3
                                       |ancestor::d:sect4
                                       |ancestor::d:sect5
                                       |ancestor::d:refsect1
                                       |ancestor::d:refsect2
                                       |ancestor::d:refsect3)[last()]"/>

  <xsl:variable name="lparent.prefix">
    <xsl:apply-templates select="$lparent" mode="label.markup"/>
  </xsl:variable>

  <xsl:variable name="prefix">
    <xsl:if test="$qanda.inherit.numeration != 0">
      <xsl:if test="$lparent.prefix != ''">
        <xsl:apply-templates select="$lparent" mode="label.markup"/>
        <xsl:apply-templates select="$lparent" mode="intralabel.punctuation">
          <xsl:with-param name="object" select="."/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$qandadiv.autolabel != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$qandadiv.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$prefix"/>
      <xsl:number level="multiple" count="d:qandadiv" format="{$format}"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:question|d:answer" mode="label.markup">
  <xsl:variable name="lparent" select="(ancestor::d:set
                                       |ancestor::d:book
                                       |ancestor::d:chapter
                                       |ancestor::d:appendix
                                       |ancestor::d:preface
                                       |ancestor::d:section
                                       |ancestor::d:simplesect
                                       |ancestor::d:sect1
                                       |ancestor::d:sect2
                                       |ancestor::d:sect3
                                       |ancestor::d:sect4
                                       |ancestor::d:sect5
                                       |ancestor::d:refsect1
                                       |ancestor::d:refsect2
                                       |ancestor::d:refsect3)[last()]"/>

  <xsl:variable name="lparent.prefix">
    <xsl:apply-templates select="$lparent" mode="label.markup"/>
  </xsl:variable>

  <xsl:variable name="prefix">
    <xsl:if test="$qanda.inherit.numeration != 0">
      <xsl:choose>
        <xsl:when test="ancestor::d:qandadiv">
          <xsl:variable name="div.label">
            <xsl:apply-templates select="ancestor::d:qandadiv[1]" mode="label.markup"/>
          </xsl:variable>
          <xsl:if test="string-length($div.label) != 0">
            <xsl:copy-of select="$div.label"/>
            <xsl:apply-templates select="ancestor::d:qandadiv[1]"
                                 mode="intralabel.punctuation">
              <xsl:with-param name="object" select="."/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$lparent.prefix != ''">
          <xsl:apply-templates select="$lparent" mode="label.markup"/>
          <xsl:apply-templates select="$lparent" mode="intralabel.punctuation">
            <xsl:with-param name="object" select="."/>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="inhlabel"
                select="ancestor-or-self::d:qandaset/@defaultlabel[1]"/>

  <xsl:variable name="deflabel">
    <xsl:choose>
      <xsl:when test="$inhlabel != ''">
        <xsl:value-of select="$inhlabel"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$qanda.defaultlabel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="label" select="d:label"/>

  <xsl:choose>
    <xsl:when test="count($label)>0">
      <xsl:apply-templates select="$label"/>
    </xsl:when>

    <xsl:when test="$deflabel = 'qanda' and self::d:question">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Question'"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="$deflabel = 'qanda' and self::d:answer">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Answer'"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="($deflabel = 'qnumber' or
                     $deflabel = 'qnumberanda') and self::d:question">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Question'"/>
      </xsl:call-template>
      <xsl:text>&#xA0;</xsl:text>
      <xsl:value-of select="$prefix"/>
      <xsl:number level="multiple" count="d:qandaentry" format="1"/>
    </xsl:when>

    <xsl:when test="$deflabel = 'qnumberanda' and self::d:answer">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Answer'"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="$deflabel = 'number' and self::d:question">
      <xsl:value-of select="$prefix"/>
      <xsl:number level="multiple" count="d:qandaentry" format="1"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:bibliography|d:glossary|
                     d:qandaset|d:index|d:setindex" mode="label.markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:figure|d:table|d:example" mode="label.markup">
  <xsl:variable name="pchap"
                select="(ancestor::d:chapter
                        |ancestor::d:appendix
                        |ancestor::d:article[ancestor::d:book])[last()]"/>

  <xsl:variable name="prefix">
    <xsl:if test="count($pchap) &gt; 0">
      <xsl:apply-templates select="$pchap" mode="label.markup"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$prefix != ''">
            <xsl:apply-templates select="$pchap" mode="label.markup"/>
            <xsl:apply-templates select="$pchap" mode="intralabel.punctuation">
              <xsl:with-param name="object" select="."/>
            </xsl:apply-templates>
          <xsl:number format="1" from="d:chapter|d:appendix" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number format="1" from="d:book|d:article" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:procedure" mode="label.markup">
  <xsl:variable name="pchap"
                select="ancestor::d:chapter
                        |ancestor::d:appendix
                        |ancestor::d:article[ancestor::d:book]"/>

  <xsl:variable name="prefix">
    <xsl:if test="count($pchap) &gt; 0">
      <xsl:apply-templates select="$pchap" mode="label.markup"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$formal.procedures = 0">
      <!-- No label -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="count($pchap)>0">
          <xsl:if test="$prefix != ''">
            <xsl:apply-templates select="$pchap" mode="label.markup"/>
            <xsl:apply-templates select="$pchap" mode="intralabel.punctuation">
              <xsl:with-param name="object" select="."/>
            </xsl:apply-templates>
          </xsl:if>
          <xsl:number count="d:procedure[d:title|d:blockinfo/d:title|d:info/d:title]" format="1"
                      from="d:chapter|d:appendix" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number count="d:procedure[d:title|d:blockinfo/d:title|d:info/d:title]" format="1"
                      from="d:book|d:article" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:equation" mode="label.markup">
  <xsl:variable name="pchap"
                select="ancestor::d:chapter
                        |ancestor::d:appendix
                        |ancestor::d:article[ancestor::d:book]"/>

  <xsl:variable name="prefix">
    <xsl:if test="count($pchap) &gt; 0">
      <xsl:apply-templates select="$pchap" mode="label.markup"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="count($pchap)>0">
          <xsl:if test="$prefix != ''">
            <xsl:apply-templates select="$pchap" mode="label.markup"/>
            <xsl:apply-templates select="$pchap" mode="intralabel.punctuation">
              <xsl:with-param name="object" select="."/>
            </xsl:apply-templates>
          </xsl:if>
          <xsl:number format="1" count="d:equation"
                      from="d:chapter|d:appendix" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number format="1" count="d:equation"
                      from="d:book|d:article" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:orderedlist/d:listitem" mode="label.markup">
  <xsl:variable name="numeration">
    <xsl:call-template name="list.numeration">
      <xsl:with-param name="node" select="parent::d:orderedlist"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="$numeration='arabic'">1</xsl:when>
      <xsl:when test="$numeration='loweralpha'">a</xsl:when>
      <xsl:when test="$numeration='lowerroman'">i</xsl:when>
      <xsl:when test="$numeration='upperalpha'">A</xsl:when>
      <xsl:when test="$numeration='upperroman'">I</xsl:when>
      <!-- What!? This should never happen -->
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Unexpected numeration: </xsl:text>
          <xsl:value-of select="$numeration"/>
        </xsl:message>
        <xsl:value-of select="1."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="item-number">
    <xsl:call-template name="orderedlist-item-number"/>
  </xsl:variable>

  <xsl:number value="$item-number" format="{$type}"/>
</xsl:template>

<xsl:template match="d:production" mode="label.markup">
  <xsl:number count="d:production" level="any"/>
</xsl:template>

<xsl:template match="d:abstract" mode="label.markup">
  <!-- nop -->
</xsl:template>

<xsl:template match="d:sidebar" mode="label.markup">
  <!-- nop -->
</xsl:template>

<xsl:template match="d:glossdiv|d:glosslist" mode="label.markup">
  <!-- nop -->
</xsl:template>

<xsl:template match="d:glossentry" mode="label.markup">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="label.this.section">
  <xsl:param name="section" select="."/>

  <xsl:variable name="level">
    <xsl:call-template name="section.level"/>
  </xsl:variable>

  <xsl:choose>
    <!-- bridgeheads are not numbered -->
    <xsl:when test="$section/self::d:bridgehead">0</xsl:when>
    <xsl:when test="$level &lt;= $section.autolabel.max.depth">      
      <xsl:value-of select="$section.autolabel"/>
    </xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<doc:template name="label.this.section" xmlns="">
<refpurpose>Returns true if $section should be labelled</refpurpose>
<refdescription id="label.this.section-desc">
<para>Returns true if the specified section should be labelled.
By default, this template returns zero unless 
the section level is less than or equal to the value of the
<literal>$section.autolabel.max.depth</literal> parameter, in
which case it returns
<literal>$section.autolabel</literal>.
Custom stylesheets may override it to get more selective behavior.</para>
</refdescription>
</doc:template>

<!-- ============================================================ -->

<xsl:template name="default.autolabel.format">
  <xsl:param name="context" select="."/>
  <xsl:choose>
    <xsl:when test="local-name($context) = 'appendix'">
      <xsl:value-of select="'A'"/>
    </xsl:when>
    <xsl:when test="local-name($context) = 'part'">
      <xsl:value-of select="'I'"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>  
</xsl:template>
  
<xsl:template name="autolabel.format">
  <xsl:param name="context" select="."/>
  <xsl:param name="format"/>

  <xsl:choose>
    <xsl:when test="string($format) != 0">
      <xsl:choose>
        <xsl:when test="string($format)='arabic' or $format='1'">1</xsl:when>
        <xsl:when test="$format='loweralpha' or $format='a'">
          <xsl:value-of select="'a'"/>
        </xsl:when>
        <xsl:when test="$format='lowerroman' or $format='i'">
          <xsl:value-of select="'i'"/>
        </xsl:when>
        <xsl:when test="$format='upperalpha' or $format='A'">
          <xsl:value-of select="'A'"/>
        </xsl:when>
        <xsl:when test="$format='upperroman' or $format='I'">
          <xsl:value-of select="'I'"/>
        </xsl:when>      
        <xsl:when test="$format='arabicindic' or $format='&#x661;'">
          <xsl:value-of select="'&#x661;'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Unexpected </xsl:text><xsl:value-of select="local-name(.)"/><xsl:text>.autolabel value: </xsl:text>
            <xsl:value-of select="$format"/><xsl:text>; using default.</xsl:text>
          </xsl:message>
          <xsl:call-template name="default.autolabel.format"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<doc:template name="autolabel.format" xmlns="">
<refpurpose>Returns format for autolabel parameters</refpurpose>
<refdescription id="autolabel.format-desc">
<para>Returns format passed as parameter if non zero. Supported
  format are 'arabic' or '1', 'loweralpha' or 'a', 'lowerroman' or 'i', 
  'upperlapha' or 'A', 'upperroman' or 'I', 'arabicindic' or '&#x661;'.
  If its not one of these then 
  returns the default format.</para>
</refdescription>
</doc:template>

<!-- ============================================================ -->

</xsl:stylesheet>
