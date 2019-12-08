<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                version='1.0'>

<!-- ********************************************************************
     (c) Stephane Bline Peregrine Systems 2001
     Implementation of xep extensions:
       * Pdf bookmarks (based on the XEP 2.5 implementation)
       * Document information (XEP 2.5 meta information extensions)
     ******************************************************************** -->

<!-- FIXME: Norm, I changed things so that the top-level element (book or set)
     does not appear in the TOC. Is this the right thing? -->

<xsl:template name="xep-document-information">
  <rx:meta-info>
    <xsl:variable name="authors" 
                  select="(//d:author|//d:editor|//d:corpauthor|//d:authorgroup)[1]"/>
    <xsl:if test="$authors">
      <xsl:variable name="author">
        <xsl:choose>
          <xsl:when test="$authors[self::d:authorgroup]">
            <xsl:call-template name="person.name.list">
              <xsl:with-param name="person.list" 
                        select="$authors/*[self::d:author|self::d:corpauthor|
                               self::d:othercredit|self::d:editor]"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$authors[self::d:corpauthor]">
            <xsl:value-of select="$authors"/>
          </xsl:when>
          <xsl:when test="$authors[d:orgname]">
            <xsl:value-of select="$authors/d:orgname"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="person.name">
              <xsl:with-param name="node" select="$authors"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">author</xsl:attribute>
        <xsl:attribute name="value">
          <xsl:value-of select="normalize-space($author)"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>

    <xsl:variable name="title">
      <xsl:apply-templates select="/*[1]" mode="label.markup"/>
      <xsl:apply-templates select="/*[1]" mode="title.markup"/>
    </xsl:variable>

    <xsl:element name="rx:meta-field">
      <xsl:attribute name="name">creator</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:text>DocBook </xsl:text>
        <xsl:value-of select="$DistroTitle"/>
        <xsl:text> V</xsl:text>
        <xsl:value-of select="$VERSION"/>
      </xsl:attribute>
    </xsl:element>

    <xsl:element name="rx:meta-field">
      <xsl:attribute name="name">title</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="normalize-space($title)"/>
      </xsl:attribute>
    </xsl:element>

    <xsl:if test="//d:keyword">
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">keywords</xsl:attribute>
        <xsl:attribute name="value">
          <xsl:for-each select="//d:keyword">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>

    <xsl:if test="//d:subjectterm">
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">subject</xsl:attribute>
        <xsl:attribute name="value">
          <xsl:for-each select="//d:subjectterm">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
  </rx:meta-info>
</xsl:template>

<!-- ********************************************************************
     Pdf bookmarks
     ******************************************************************** -->

<xsl:template match="*" mode="xep.outline">
  <xsl:apply-templates select="*" mode="xep.outline"/>
</xsl:template>

<!-- to turn off any of these, add to your customization layer
     an empty template matching on that element and in this mode -->
<xsl:template match="d:appendix |
                     d:article |
                     d:bibliography |
                     d:book |
                     d:chapter |
                     d:glossary |
                     d:index |
                     d:part |
                     d:preface |
                     d:refentry |
                     d:reference |
                     d:refsect1 |
                     d:refsect2 |
                     d:refsect3 |
                     d:refsection |
                     d:refsynopsisdiv |
                     d:sect1 |
                     d:sect2 |
                     d:sect3 |
                     d:sect4 |
                     d:sect5 |
                     d:section |
                     d:set |
                     d:setindex |
                     d:topic"
              mode="xep.outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>

  <!-- Put the root element bookmark at the same level as its children -->
  <!-- If the object is a set or book, generate a bookmark for the toc -->
  <xsl:choose>
    <xsl:when test="self::d:index and $generate.index = 0"/>
    <xsl:when test="parent::*">
      <rx:bookmark internal-destination="{$id}">
        <xsl:attribute name="starting-state">
          <xsl:value-of select="$bookmarks.state"/>
        </xsl:attribute>
        <rx:bookmark-label>
          <xsl:value-of select="normalize-space($bookmark-label)"/>
        </rx:bookmark-label>
        <xsl:apply-templates select="*" mode="xep.outline"/>
      </rx:bookmark>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$bookmark-label != ''">
        <rx:bookmark internal-destination="{$id}">
          <xsl:attribute name="starting-state">
            <xsl:value-of select="$bookmarks.state"/>
          </xsl:attribute>
          <rx:bookmark-label>
            <xsl:value-of select="normalize-space($bookmark-label)"/>
          </rx:bookmark-label>
        </rx:bookmark>
      </xsl:if>

      <xsl:variable name="toc.params">
        <xsl:call-template name="find.path.params">
          <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="contains($toc.params, 'toc')
                    and d:set|d:book|d:part|d:reference|d:section|d:sect1|d:refentry
                        |d:article|d:topic|d:bibliography|d:glossary|d:chapter
                        |d:appendix">
        <rx:bookmark internal-destination="toc...{$id}">
          <rx:bookmark-label>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'TableofContents'"/>
            </xsl:call-template>
          </rx:bookmark-label>
        </rx:bookmark>
      </xsl:if>
      <xsl:apply-templates select="*" mode="xep.outline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="xep-pis">
  <xsl:if test="$crop.marks != 0">
    <xsl:processing-instruction name="xep-pdf-crop-mark-width"><xsl:value-of select="$crop.mark.width"/></xsl:processing-instruction>
    <xsl:processing-instruction name="xep-pdf-crop-offset"><xsl:value-of select="$crop.mark.offset"/></xsl:processing-instruction>
    <xsl:processing-instruction name="xep-pdf-bleed"><xsl:value-of select="$crop.mark.bleed"/></xsl:processing-instruction>
  </xsl:if>

  <xsl:call-template name="user-xep-pis"/>
</xsl:template>

<!-- Placeholder for user defined PIs -->
<xsl:template name="user-xep-pis"/>

</xsl:stylesheet>
