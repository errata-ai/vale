<?xml version="1.0" encoding="ASCII"?><!--This file was created automatically by html2xhtml--><!--from the HTML stylesheets.--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook" xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="mml d" version="1.0">

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:template match="d:inlineequation">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:alt">
</xsl:template>

<xsl:template match="d:mathphrase">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- "Support" for MathML -->

<xsl:template match="mml:*">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!-- Support for TeX math in alt -->

<xsl:template match="*" mode="collect.tex.math">
  <xsl:call-template name="write.text.chunk">
    <xsl:with-param name="filename" select="$tex.math.file"/>
    <xsl:with-param name="method" select="'text'"/>
    <xsl:with-param name="content">
      <xsl:choose>
        <xsl:when test="$tex.math.in.alt = 'plain'">
          <xsl:call-template name="tex.math.plain.head"/>
          <xsl:apply-templates select="." mode="collect.tex.math.plain"/>
          <xsl:call-template name="tex.math.plain.tail"/>
        </xsl:when>
        <xsl:when test="$tex.math.in.alt = 'latex'">
          <xsl:call-template name="tex.math.latex.head"/>
          <xsl:apply-templates select="." mode="collect.tex.math.latex"/>
          <xsl:call-template name="tex.math.latex.tail"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            Unsupported TeX math notation: 
            <xsl:value-of select="$tex.math.in.alt"/>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
    <xsl:with-param name="encoding" select="$chunker.output.encoding"/>
  </xsl:call-template>
</xsl:template>

<!-- PlainTeX -->

<xsl:template name="tex.math.plain.head">
  <xsl:text>\nopagenumbers 
</xsl:text>
</xsl:template>

<xsl:template name="tex.math.plain.tail">
  <xsl:text>\bye 
</xsl:text>
</xsl:template>

<xsl:template match="d:inlineequation" mode="collect.tex.math.plain">
  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="d:graphic">
        <xsl:call-template name="mediaobject.filename">
          <xsl:with-param name="object" select="d:graphic"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="select.mediaobject.filename">
          <xsl:with-param name="olist" select="d:inlinemediaobject/*"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="output.delims">
    <xsl:call-template name="tex.math.output.delims"/>
  </xsl:variable>
  <xsl:variable name="tex" select="d:alt[@role='tex'] | d:inlinemediaobject/d:textobject[@role='tex']"/>
  <xsl:if test="$tex">
    <xsl:text>\special{dvi2bitmap outputfile </xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:text>} 
</xsl:text>
    <xsl:if test="$output.delims != 0">
      <xsl:text>$</xsl:text>
    </xsl:if>
    <xsl:value-of select="$tex"/>
    <xsl:if test="$output.delims != 0">
      <xsl:text>$ 
</xsl:text>
    </xsl:if>
    <xsl:text>\vfill\eject 
</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:equation|d:informalequation" mode="collect.tex.math.plain">
  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="d:graphic">
        <xsl:call-template name="mediaobject.filename">
          <xsl:with-param name="object" select="d:graphic"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="select.mediaobject.filename">
          <xsl:with-param name="olist" select="d:mediaobject/*"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="output.delims">
    <xsl:call-template name="tex.math.output.delims"/>
  </xsl:variable>
  <xsl:variable name="tex" select="d:alt[@role='tex'] | d:mediaobject/d:textobject[@role='tex']"/>
  <xsl:if test="$tex">
    <xsl:text>\special{dvi2bitmap outputfile </xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:text>} 
</xsl:text>
    <xsl:if test="$output.delims != 0">
      <xsl:text>$$</xsl:text>
    </xsl:if>
    <xsl:value-of select="$tex"/>
    <xsl:if test="$output.delims != 0">
      <xsl:text>$$ 
</xsl:text>
    </xsl:if>
    <xsl:text>\vfill\eject 
</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="text()" mode="collect.tex.math.plain"/>

<!-- LaTeX -->

<xsl:template name="tex.math.latex.head">
  <xsl:text>\documentclass{article} 
</xsl:text>
  <xsl:text>\pagestyle{empty} 
</xsl:text>
  <xsl:text>\begin{document} 
</xsl:text>
</xsl:template>

<xsl:template name="tex.math.latex.tail">
  <xsl:text>\end{document} 
</xsl:text>
</xsl:template>

<xsl:template match="d:inlineequation" mode="collect.tex.math.latex">
  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="d:graphic">
        <xsl:call-template name="mediaobject.filename">
          <xsl:with-param name="object" select="d:graphic"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="select.mediaobject.filename">
          <xsl:with-param name="olist" select="d:inlinemediaobject/*"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="output.delims">
    <xsl:call-template name="tex.math.output.delims"/>
  </xsl:variable>
  <xsl:variable name="tex" select="d:alt[@role='tex'] | d:inlinemediaobject/d:textobject[@role='tex']"/>
  <xsl:if test="$tex">
    <xsl:text>\special{dvi2bitmap outputfile </xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:text>} 
</xsl:text>
    <xsl:if test="$output.delims != 0">  
      <xsl:text>$</xsl:text>
    </xsl:if>
    <xsl:value-of select="$tex"/>
    <xsl:if test="$output.delims != 0">  
      <xsl:text>$ 
</xsl:text>
    </xsl:if>
    <xsl:text>\newpage 
</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:equation|d:informalequation" mode="collect.tex.math.latex">
  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="d:graphic">
        <xsl:call-template name="mediaobject.filename">
          <xsl:with-param name="object" select="d:graphic"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="select.mediaobject.filename">
          <xsl:with-param name="olist" select="d:mediaobject/*"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="output.delims">
    <xsl:call-template name="tex.math.output.delims"/>
  </xsl:variable>
  <xsl:variable name="tex" select="d:alt[@role='tex'] | d:mediaobject/d:textobject[@role='tex']"/>
  <xsl:if test="$tex">
    <xsl:text>\special{dvi2bitmap outputfile </xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:text>} 
</xsl:text>
    <xsl:if test="$output.delims != 0">
      <xsl:text>$$</xsl:text>
    </xsl:if>
    <xsl:value-of select="$tex"/>
    <xsl:if test="$output.delims != 0">
      <xsl:text>$$ 
</xsl:text>
    </xsl:if>
    <xsl:text>\newpage 
</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="text()" mode="collect.tex.math.latex"/>

<!-- Extracting image filename from mediaobject and graphic elements -->

<xsl:template name="select.mediaobject.filename">
  <xsl:param name="olist" select="d:imageobject|d:imageobjectco                      |d:videoobject|d:audioobject|d:textobject"/>

  <xsl:variable name="mediaobject.index">
    <xsl:call-template name="select.mediaobject.index">
      <xsl:with-param name="olist" select="$olist"/>
      <xsl:with-param name="count" select="1"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$mediaobject.index != ''">
    <xsl:call-template name="mediaobject.filename">
      <xsl:with-param name="object" select="$olist[position() = $mediaobject.index]"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="tex.math.output.delims">
  <xsl:variable name="pi.delims">
    <xsl:call-template name="pi.dbtex_delims">
      <xsl:with-param name="node" select="descendant-or-self::*"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="result">
    <xsl:choose>
      <xsl:when test="$pi.delims = 'no'">0</xsl:when>
      <xsl:when test="$pi.delims = '' and $tex.math.delims = 0">0</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$result"/>
</xsl:template>

</xsl:stylesheet>