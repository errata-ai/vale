<?xml version="1.0" encoding="ASCII"?><!--This file was created automatically by html2xhtml--><!--from the HTML stylesheets.--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="d" version="1.0">

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="d:set/d:toc | d:book/d:toc | d:part/d:toc">
  <xsl:variable name="toc.params">
    <xsl:call-template name="find.path.params">
      <xsl:with-param name="node" select="parent::*"/>
      <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Do not output the toc element if one is already generated
       by the use of $generate.toc parameter, or if
       generating a source toc is turned off -->
  <xsl:if test="not(contains($toc.params, 'toc')) and                 ($process.source.toc != 0 or $process.empty.source.toc != 0)">
    <xsl:variable name="content">
      <xsl:choose>
        <xsl:when test="* and $process.source.toc != 0">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="count(*) = 0 and $process.empty.source.toc != 0">
          <!-- trick to switch context node to parent element -->
          <xsl:for-each select="parent::*">
            <xsl:choose>
              <xsl:when test="self::d:set">
                <xsl:call-template name="set.toc">
                  <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="self::d:book">
                <xsl:call-template name="division.toc">
                  <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="self::d:part">
                <xsl:call-template name="division.toc">
                  <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="string-length(normalize-space($content)) != 0">
      <xsl:copy-of select="$content"/>
    </xsl:if>
  </xsl:if>
</xsl:template>
  
<xsl:template match="d:chapter/d:toc | d:appendix/d:toc | d:preface/d:toc | d:article/d:toc">
  <xsl:variable name="toc.params">
    <xsl:call-template name="find.path.params">
      <xsl:with-param name="node" select="parent::*"/>
      <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Do not output the toc element if one is already generated
       by the use of $generate.toc parameter, or if
       generating a source toc is turned off -->
  <xsl:if test="not(contains($toc.params, 'toc')) and                 ($process.source.toc != 0 or $process.empty.source.toc != 0)">
    <xsl:choose>
      <xsl:when test="* and $process.source.toc != 0">
        <div>
          <xsl:apply-templates select="." mode="common.html.attributes"/>
          <xsl:call-template name="id.attribute"/>
          <xsl:apply-templates select="d:title"/>
          <dl>
            <xsl:apply-templates select="." mode="common.html.attributes"/>
            <xsl:apply-templates select="*[not(self::d:title)]"/>
          </dl>
        </div>
        <xsl:call-template name="component.toc.separator"/>
      </xsl:when>
      <xsl:when test="count(*) = 0 and $process.empty.source.toc != 0">
        <!-- trick to switch context node to section element -->
        <xsl:for-each select="parent::*">
          <xsl:call-template name="component.toc">
            <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:call-template name="component.toc.separator"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="d:section/d:toc                     |d:sect1/d:toc                     |d:sect2/d:toc                     |d:sect3/d:toc                     |d:sect4/d:toc                     |d:sect5/d:toc">

  <xsl:variable name="toc.params">
    <xsl:call-template name="find.path.params">
      <xsl:with-param name="node" select="parent::*"/>
      <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Do not output the toc element if one is already generated
       by the use of $generate.toc parameter, or if
       generating a source toc is turned off -->
  <xsl:if test="not(contains($toc.params, 'toc')) and                 ($process.source.toc != 0 or $process.empty.source.toc != 0)">
    <xsl:choose>
      <xsl:when test="* and $process.source.toc != 0">
        <div>
          <xsl:apply-templates select="." mode="common.html.attributes"/>
          <xsl:call-template name="id.attribute"/>
          <xsl:apply-templates select="d:title"/>
          <dl>
            <xsl:apply-templates select="." mode="common.html.attributes"/>
            <xsl:apply-templates select="*[not(self::d:title)]"/>
          </dl>
        </div>
        <xsl:call-template name="section.toc.separator"/>
      </xsl:when>
      <xsl:when test="count(*) = 0 and $process.empty.source.toc != 0">
        <!-- trick to switch context node to section element -->
        <xsl:for-each select="parent::*">
          <xsl:call-template name="section.toc">
            <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:call-template name="section.toc.separator"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:tocpart|d:tocchap                      |d:toclevel1|d:toclevel2|d:toclevel3|d:toclevel4|d:toclevel5">
  <xsl:variable name="sub-toc">
    <xsl:if test="d:tocchap|d:toclevel1|d:toclevel2|d:toclevel3|d:toclevel4|d:toclevel5">
      <xsl:choose>
        <xsl:when test="$toc.list.type = 'dl'">
          <dd>
            <xsl:apply-templates select="." mode="common.html.attributes"/>
            <xsl:element name="{$toc.list.type}" namespace="http://www.w3.org/1999/xhtml">
              <xsl:apply-templates select="." mode="common.html.attributes"/>
              <xsl:apply-templates select="d:tocchap|d:toclevel1|d:toclevel2|                                            d:toclevel3|d:toclevel4|d:toclevel5"/>
            </xsl:element>
          </dd>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="{$toc.list.type}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="." mode="common.html.attributes"/>
            <xsl:apply-templates select="d:tocchap|d:toclevel1|d:toclevel2|                                          d:toclevel3|d:toclevel4|d:toclevel5"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <xsl:apply-templates select="d:tocentry[position() != last()]"/>

  <xsl:choose>
    <xsl:when test="$toc.list.type = 'dl'">
      <dt>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:apply-templates select="d:tocentry[position() = last()]"/>
      </dt>
      <xsl:copy-of select="$sub-toc"/>
    </xsl:when>
    <xsl:otherwise>
      <li>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:apply-templates select="d:tocentry[position() = last()]"/>
        <xsl:copy-of select="$sub-toc"/>
      </li>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:tocentry|d:tocdiv|d:lotentry|d:tocfront|d:tocback">
  <xsl:choose>
    <xsl:when test="$toc.list.type = 'dl'">
      <dt>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:call-template name="tocentry-content"/>
      </dt>
    </xsl:when>
    <xsl:otherwise>
      <li>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:call-template name="tocentry-content"/>
      </li>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:tocentry[position() = last()]" priority="2">
  <xsl:call-template name="tocentry-content"/>
</xsl:template>

<xsl:template name="tocentry-content">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <xsl:choose>
    <xsl:when test="@linkend">
      <xsl:call-template name="check.id.unique">
        <xsl:with-param name="linkend" select="@linkend"/>
      </xsl:call-template>
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:toc/d:title | d:tocdiv/d:title">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:toc/d:subtitle | d:tocdiv/d:subtitle">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:toc/d:titleabbrev | d:tocdiv/d:titleabbrev">
</xsl:template>

<!-- ==================================================================== -->

<!-- A lot element must have content, because there is no attribute
     to select what kind of list should be generated -->
<xsl:template match="d:book/d:lot | d:part/d:lot">
  <!-- Don't generate a page sequence unless there is content -->
  <xsl:variable name="content">
    <xsl:choose>
      <xsl:when test="* and $process.source.toc != 0">
        <div>
          <xsl:apply-templates select="." mode="common.html.attributes"/>
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:when test="not(child::*) and $process.empty.source.toc != 0">
        <xsl:call-template name="process.empty.lot"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="string-length(normalize-space($content)) != 0">
    <xsl:copy-of select="$content"/>
  </xsl:if>
</xsl:template>
  
<xsl:template match="d:chapter/d:lot | d:appendix/d:lot | d:preface/d:lot | d:article/d:lot">
  <xsl:choose>
    <xsl:when test="* and $process.source.toc != 0">
      <div>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:apply-templates/>
      </div>
      <xsl:call-template name="component.toc.separator"/>
    </xsl:when>
    <xsl:when test="not(child::*) and $process.empty.source.toc != 0">
      <xsl:call-template name="process.empty.lot"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:section/d:lot                     |d:sect1/d:lot                     |d:sect2/d:lot                     |d:sect3/d:lot                     |d:sect4/d:lot                     |d:sect5/d:lot">
  <xsl:choose>
    <xsl:when test="* and $process.source.toc != 0">
      <div>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:apply-templates/>
      </div>
      <xsl:call-template name="section.toc.separator"/>
    </xsl:when>
    <xsl:when test="not(child::*) and $process.empty.source.toc != 0">
      <xsl:call-template name="process.empty.lot"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="process.empty.lot">
  <!-- An empty lot element does not provide any information to indicate
       what should be included in it.  You can customize this
       template to generate a lot based on @role or something -->
  <xsl:message>
    <xsl:text>Warning: don't know what to generate for </xsl:text>
    <xsl:text>lot that has no children.</xsl:text>
  </xsl:message>
</xsl:template>

<xsl:template match="d:lot/d:title">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:lot/d:subtitle">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:lot/d:titleabbrev">
</xsl:template>

</xsl:stylesheet>