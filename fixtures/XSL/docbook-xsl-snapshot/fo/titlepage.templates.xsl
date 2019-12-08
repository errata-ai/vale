<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook" xmlns:exsl="http://exslt.org/common" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0" exclude-result-prefixes="exsl d">

<!-- This stylesheet was created by template/titlepage.xsl-->

<xsl:template name="article.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:articleinfo/d:title">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:artheader/d:title">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:articleinfo/d:subtitle">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:artheader/d:subtitle">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:corpauthor"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:corpauthor"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:authorgroup"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:authorgroup"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:author"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:author"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:othercredit"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:othercredit"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:releaseinfo"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:copyright"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:copyright"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:legalnotice"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:legalnotice"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:pubdate"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:pubdate"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:revision"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:revision"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:revhistory"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:revhistory"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:abstract"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:abstract"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:articleinfo/d:itermset"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:artheader/d:itermset"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="article.titlepage.verso">
</xsl:template>

<xsl:template name="article.titlepage.separator">
</xsl:template>

<xsl:template name="article.titlepage.before.recto">
</xsl:template>

<xsl:template name="article.titlepage.before.verso">
</xsl:template>

<xsl:template name="article.titlepage">
  <fo:block font-family="{$title.fontset}">
    <xsl:variable name="recto.content">
      <xsl:call-template name="article.titlepage.before.recto"/>
      <xsl:call-template name="article.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block start-indent="0pt" text-align="center"><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="article.titlepage.before.verso"/>
      <xsl:call-template name="article.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="article.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="article.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="article.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" keep-with-next.within-column="always" font-size="24.8832pt" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:article[1]"/>
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" space-before="0.5em" font-size="14.4pt">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" space-before="0.5em" font-size="14.4pt">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" space-before="0.5em" font-size="14.4pt">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" text-align="start" margin-left="0.5in" margin-right="0.5in" font-family="{$body.fontset}">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style" space-before="0.5em" text-align="start" margin-left="0.5in" margin-right="0.5in" font-family="{$body.fontset}">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="article.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="set.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:setinfo/d:title">
      <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:setinfo/d:subtitle">
      <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:corpauthor"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:authorgroup"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:author"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:othercredit"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:copyright"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:legalnotice"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:pubdate"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:revision"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:revhistory"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:abstract"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:setinfo/d:itermset"/>
  <xsl:apply-templates mode="set.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="set.titlepage.verso">
</xsl:template>

<xsl:template name="set.titlepage.separator">
</xsl:template>

<xsl:template name="set.titlepage.before.recto">
</xsl:template>

<xsl:template name="set.titlepage.before.verso">
</xsl:template>

<xsl:template name="set.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="set.titlepage.before.recto"/>
      <xsl:call-template name="set.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="set.titlepage.before.verso"/>
      <xsl:call-template name="set.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="set.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="set.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="set.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style" text-align="center" font-size="24.8832pt" space-before="18.6624pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="division.title">
<xsl:with-param name="node" select="ancestor-or-self::d:set[1]"/>
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style" font-family="{$title.fontset}" text-align="center">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="set.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="book.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:bookinfo/d:title">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:bookinfo/d:subtitle">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:corpauthor"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:authorgroup"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:author"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:itermset"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="book.titlepage.verso">
  <xsl:choose>
    <xsl:when test="d:bookinfo/d:title">
      <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:corpauthor"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:authorgroup"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:author"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:othercredit"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:pubdate"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:copyright"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:abstract"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:legalnotice"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:legalnotice"/>
</xsl:template>

<xsl:template name="book.titlepage.separator"><fo:block break-after="page"/>
</xsl:template>

<xsl:template name="book.titlepage.before.recto">
</xsl:template>

<xsl:template name="book.titlepage.before.verso"><fo:block break-after="page"/>
</xsl:template>

<xsl:template name="book.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="book.titlepage.before.recto"/>
      <xsl:call-template name="book.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="book.titlepage.before.verso"/>
      <xsl:call-template name="book.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="book.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="book.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="book.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="book.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.recto.style" text-align="center" font-size="24.8832pt" space-before="18.6624pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="division.title">
<xsl:with-param name="node" select="ancestor-or-self::d:book[1]"/>
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="book.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.recto.style" text-align="center" font-size="20.736pt" space-before="15.552pt" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="book.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.recto.style" font-size="17.28pt" keep-with-next.within-column="always" space-before="2in">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="book.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.recto.style" space-before="2in">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="book.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.recto.style" font-size="17.28pt" space-before="10.8pt" keep-with-next.within-column="always">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="book.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:title" mode="book.titlepage.verso.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.verso.style" font-size="14.4pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="book.verso.title">
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="book.titlepage.verso.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.verso.style">
<xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="book.titlepage.verso.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.verso.style">
<xsl:call-template name="verso.authorgroup">
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="book.titlepage.verso.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.verso.style">
<xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="book.titlepage.verso.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.verso.style">
<xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="book.titlepage.verso.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.verso.style" space-before="0.5em">
<xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="book.titlepage.verso.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.verso.style" space-before="1em">
<xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="book.titlepage.verso.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.verso.style">
<xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="book.titlepage.verso.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.verso.style">
<xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="book.titlepage.verso.auto.mode">
<fo:block xsl:use-attribute-sets="book.titlepage.verso.style" font-size="8pt">
<xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="part.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:partinfo/d:title">
      <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:partinfo/d:subtitle">
      <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:itermset"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="part.titlepage.verso">
</xsl:template>

<xsl:template name="part.titlepage.separator">
</xsl:template>

<xsl:template name="part.titlepage.before.recto">
</xsl:template>

<xsl:template name="part.titlepage.before.verso">
</xsl:template>

<xsl:template name="part.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="part.titlepage.before.recto"/>
      <xsl:call-template name="part.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="part.titlepage.before.verso"/>
      <xsl:call-template name="part.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="part.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="part.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="part.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="part.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="part.titlepage.recto.style" text-align="center" font-size="24.8832pt" space-before="18.6624pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="division.title">
<xsl:with-param name="node" select="ancestor-or-self::d:part[1]"/>
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="part.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="part.titlepage.recto.style" text-align="center" font-size="20.736pt" space-before="15.552pt" font-weight="bold" font-style="italic" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="part.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="partintro.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:partintroinfo/d:title">
      <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:partintroinfo/d:subtitle">
      <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:corpauthor"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:corpauthor"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:authorgroup"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:authorgroup"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:author"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:author"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:othercredit"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:othercredit"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:copyright"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:copyright"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:legalnotice"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:legalnotice"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:pubdate"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:pubdate"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:revision"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:revision"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:revhistory"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:revhistory"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:abstract"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:abstract"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:partintroinfo/d:itermset"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="partintro.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="partintro.titlepage.verso">
</xsl:template>

<xsl:template name="partintro.titlepage.separator">
</xsl:template>

<xsl:template name="partintro.titlepage.before.recto">
</xsl:template>

<xsl:template name="partintro.titlepage.before.verso">
</xsl:template>

<xsl:template name="partintro.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="partintro.titlepage.before.recto"/>
      <xsl:call-template name="partintro.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="partintro.titlepage.before.verso"/>
      <xsl:call-template name="partintro.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="partintro.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="partintro.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="partintro.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style" text-align="center" font-size="24.8832pt" font-weight="bold" space-before="1em" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style" text-align="center" font-size="14.4pt" font-weight="bold" font-style="italic" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="partintro.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="reference.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:referenceinfo/d:title">
      <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:referenceinfo/d:subtitle">
      <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:corpauthor"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:corpauthor"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:authorgroup"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:authorgroup"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:author"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:author"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:othercredit"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:othercredit"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:copyright"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:copyright"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:legalnotice"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:legalnotice"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:pubdate"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:pubdate"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:revision"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:revision"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:revhistory"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:revhistory"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:abstract"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:abstract"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:referenceinfo/d:itermset"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="reference.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="reference.titlepage.verso">
</xsl:template>

<xsl:template name="reference.titlepage.separator">
</xsl:template>

<xsl:template name="reference.titlepage.before.recto">
</xsl:template>

<xsl:template name="reference.titlepage.before.verso">
</xsl:template>

<xsl:template name="reference.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="reference.titlepage.before.recto"/>
      <xsl:call-template name="reference.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="reference.titlepage.before.verso"/>
      <xsl:call-template name="reference.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="reference.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="reference.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="reference.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style" text-align="center" font-size="24.8832pt" space-before="18.6624pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="division.title">
<xsl:with-param name="node" select="ancestor-or-self::d:reference[1]"/>
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style" font-family="{$title.fontset}" text-align="center">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="reference.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="refsynopsisdiv.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:refsynopsisdivinfo/d:title">
      <xsl:apply-templates mode="refsynopsisdiv.titlepage.recto.auto.mode" select="d:refsynopsisdivinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="refsynopsisdiv.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="refsynopsisdiv.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="refsynopsisdiv.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="refsynopsisdiv.titlepage.recto.auto.mode" select="d:refsynopsisdivinfo/d:itermset"/>
  <xsl:apply-templates mode="refsynopsisdiv.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="refsynopsisdiv.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="refsynopsisdiv.titlepage.verso">
</xsl:template>

<xsl:template name="refsynopsisdiv.titlepage.separator">
</xsl:template>

<xsl:template name="refsynopsisdiv.titlepage.before.recto">
</xsl:template>

<xsl:template name="refsynopsisdiv.titlepage.before.verso">
</xsl:template>

<xsl:template name="refsynopsisdiv.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="refsynopsisdiv.titlepage.before.recto"/>
      <xsl:call-template name="refsynopsisdiv.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="refsynopsisdiv.titlepage.before.verso"/>
      <xsl:call-template name="refsynopsisdiv.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="refsynopsisdiv.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="refsynopsisdiv.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="refsynopsisdiv.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="refsynopsisdiv.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="refsynopsisdiv.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="refsynopsisdiv.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="refsynopsisdiv.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="refsynopsisdiv.titlepage.recto.style">
<xsl:apply-templates select="." mode="refsynopsisdiv.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="refsection.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:refsectioninfo/d:title">
      <xsl:apply-templates mode="refsection.titlepage.recto.auto.mode" select="d:refsectioninfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="refsection.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="refsection.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="refsection.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="refsection.titlepage.recto.auto.mode" select="d:refsectioninfo/d:itermset"/>
  <xsl:apply-templates mode="refsection.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="refsection.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="refsection.titlepage.verso">
</xsl:template>

<xsl:template name="refsection.titlepage.separator">
</xsl:template>

<xsl:template name="refsection.titlepage.before.recto">
</xsl:template>

<xsl:template name="refsection.titlepage.before.verso">
</xsl:template>

<xsl:template name="refsection.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="refsection.titlepage.before.recto"/>
      <xsl:call-template name="refsection.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="refsection.titlepage.before.verso"/>
      <xsl:call-template name="refsection.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="refsection.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="refsection.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="refsection.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="refsection.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="refsection.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="refsection.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="refsection.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="refsection.titlepage.recto.style">
<xsl:apply-templates select="." mode="refsection.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="refsect1.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:refsect1info/d:title">
      <xsl:apply-templates mode="refsect1.titlepage.recto.auto.mode" select="d:refsect1info/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="refsect1.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="refsect1.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="refsect1.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="refsect1.titlepage.recto.auto.mode" select="d:refsect1info/d:itermset"/>
  <xsl:apply-templates mode="refsect1.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="refsect1.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="refsect1.titlepage.verso">
</xsl:template>

<xsl:template name="refsect1.titlepage.separator">
</xsl:template>

<xsl:template name="refsect1.titlepage.before.recto">
</xsl:template>

<xsl:template name="refsect1.titlepage.before.verso">
</xsl:template>

<xsl:template name="refsect1.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="refsect1.titlepage.before.recto"/>
      <xsl:call-template name="refsect1.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="refsect1.titlepage.before.verso"/>
      <xsl:call-template name="refsect1.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="refsect1.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="refsect1.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="refsect1.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="refsect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="refsect1.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="refsect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="refsect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="refsect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="refsect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="refsect2.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:refsect2info/d:title">
      <xsl:apply-templates mode="refsect2.titlepage.recto.auto.mode" select="d:refsect2info/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="refsect2.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="refsect2.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="refsect2.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="refsect2.titlepage.recto.auto.mode" select="d:refsect2info/d:itermset"/>
  <xsl:apply-templates mode="refsect2.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="refsect2.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="refsect2.titlepage.verso">
</xsl:template>

<xsl:template name="refsect2.titlepage.separator">
</xsl:template>

<xsl:template name="refsect2.titlepage.before.recto">
</xsl:template>

<xsl:template name="refsect2.titlepage.before.verso">
</xsl:template>

<xsl:template name="refsect2.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="refsect2.titlepage.before.recto"/>
      <xsl:call-template name="refsect2.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="refsect2.titlepage.before.verso"/>
      <xsl:call-template name="refsect2.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="refsect2.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="refsect2.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="refsect2.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="refsect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="refsect2.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="refsect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="refsect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="refsect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="refsect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="refsect3.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:refsect3info/d:title">
      <xsl:apply-templates mode="refsect3.titlepage.recto.auto.mode" select="d:refsect3info/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="refsect3.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="refsect3.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="refsect3.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="refsect3.titlepage.recto.auto.mode" select="d:refsect3info/d:itermset"/>
  <xsl:apply-templates mode="refsect3.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="refsect3.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="refsect3.titlepage.verso">
</xsl:template>

<xsl:template name="refsect3.titlepage.separator">
</xsl:template>

<xsl:template name="refsect3.titlepage.before.recto">
</xsl:template>

<xsl:template name="refsect3.titlepage.before.verso">
</xsl:template>

<xsl:template name="refsect3.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="refsect3.titlepage.before.recto"/>
      <xsl:call-template name="refsect3.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="refsect3.titlepage.before.verso"/>
      <xsl:call-template name="refsect3.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="refsect3.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="refsect3.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="refsect3.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="refsect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="refsect3.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="refsect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="refsect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="refsect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="refsect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="dedication.titlepage.recto">
  <fo:block xsl:use-attribute-sets="dedication.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="24.8832pt" font-family="{$title.fontset}" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:dedication[1]"/>
</xsl:call-template></fo:block>
  <xsl:choose>
    <xsl:when test="d:dedicationinfo/d:subtitle">
      <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="d:dedicationinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="d:dedicationinfo/d:itermset"/>
  <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="dedication.titlepage.verso">
</xsl:template>

<xsl:template name="dedication.titlepage.separator">
</xsl:template>

<xsl:template name="dedication.titlepage.before.recto">
</xsl:template>

<xsl:template name="dedication.titlepage.before.verso">
</xsl:template>

<xsl:template name="dedication.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="dedication.titlepage.before.recto"/>
      <xsl:call-template name="dedication.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="dedication.titlepage.before.verso"/>
      <xsl:call-template name="dedication.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="dedication.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="dedication.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="dedication.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:subtitle" mode="dedication.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dedication.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="dedication.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="dedication.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dedication.titlepage.recto.style">
<xsl:apply-templates select="." mode="dedication.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="acknowledgements.titlepage.recto">
  <fo:block xsl:use-attribute-sets="acknowledgements.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="24.8832pt" font-family="{$title.fontset}" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:acknowledgements[1]"/>
</xsl:call-template></fo:block>
  <xsl:choose>
    <xsl:when test="d:acknowledgementsinfo/d:subtitle">
      <xsl:apply-templates mode="acknowledgements.titlepage.recto.auto.mode" select="d:acknowledgementsinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="acknowledgements.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="acknowledgements.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="acknowledgements.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="acknowledgements.titlepage.recto.auto.mode" select="d:acknowledgementsinfo/d:itermset"/>
  <xsl:apply-templates mode="acknowledgements.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="acknowledgements.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="acknowledgements.titlepage.verso">
</xsl:template>

<xsl:template name="acknowledgements.titlepage.separator">
</xsl:template>

<xsl:template name="acknowledgements.titlepage.before.recto">
</xsl:template>

<xsl:template name="acknowledgements.titlepage.before.verso">
</xsl:template>

<xsl:template name="acknowledgements.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="acknowledgements.titlepage.before.recto"/>
      <xsl:call-template name="acknowledgements.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="acknowledgements.titlepage.before.verso"/>
      <xsl:call-template name="acknowledgements.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="acknowledgements.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="acknowledgements.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="acknowledgements.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:subtitle" mode="acknowledgements.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="acknowledgements.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="acknowledgements.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="acknowledgements.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="acknowledgements.titlepage.recto.style">
<xsl:apply-templates select="." mode="acknowledgements.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="preface.titlepage.recto">
  <fo:block xsl:use-attribute-sets="preface.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="24.8832pt" font-family="{$title.fontset}" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:preface[1]"/>
</xsl:call-template></fo:block>
  <xsl:choose>
    <xsl:when test="d:prefaceinfo/d:subtitle">
      <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:corpauthor"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:corpauthor"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:authorgroup"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:authorgroup"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:author"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:author"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:othercredit"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:othercredit"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:copyright"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:copyright"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:legalnotice"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:legalnotice"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:pubdate"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:pubdate"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:revision"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:revision"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:revhistory"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:revhistory"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:abstract"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:abstract"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:itermset"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="preface.titlepage.verso">
</xsl:template>

<xsl:template name="preface.titlepage.separator">
</xsl:template>

<xsl:template name="preface.titlepage.before.recto">
</xsl:template>

<xsl:template name="preface.titlepage.before.verso">
</xsl:template>

<xsl:template name="preface.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="preface.titlepage.before.recto"/>
      <xsl:call-template name="preface.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="preface.titlepage.before.verso"/>
      <xsl:call-template name="preface.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="preface.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="preface.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="preface.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:subtitle" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="preface.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="chapter.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:chapterinfo/d:title">
      <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:chapterinfo/d:subtitle">
      <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:corpauthor"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:corpauthor"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:authorgroup"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:authorgroup"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:author"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:author"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:othercredit"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:othercredit"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:copyright"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:copyright"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:legalnotice"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:legalnotice"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:pubdate"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:pubdate"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:revision"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:revision"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:revhistory"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:revhistory"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:abstract"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:abstract"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:chapterinfo/d:itermset"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="chapter.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="chapter.titlepage.verso">
</xsl:template>

<xsl:template name="chapter.titlepage.separator">
</xsl:template>

<xsl:template name="chapter.titlepage.before.recto">
</xsl:template>

<xsl:template name="chapter.titlepage.before.verso">
</xsl:template>

<xsl:template name="chapter.titlepage">
  <fo:block font-family="{$title.fontset}">
    <xsl:variable name="recto.content">
      <xsl:call-template name="chapter.titlepage.before.recto"/>
      <xsl:call-template name="chapter.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block margin-left="{$title.margin.left}"><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="chapter.titlepage.before.verso"/>
      <xsl:call-template name="chapter.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="chapter.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="chapter.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="chapter.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style" font-size="24.8832pt" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:chapter[1]"/>
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style" space-before="0.5em" font-style="italic" font-size="14.4pt" font-weight="bold">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style" space-before="0.5em" space-after="0.5em" font-size="14.4pt">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style" space-before="0.5em" space-after="0.5em" font-size="14.4pt">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style" space-before="0.5em" space-after="0.5em" font-size="14.4pt">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="chapter.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="appendix.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:appendixinfo/d:title">
      <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:appendixinfo/d:subtitle">
      <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:corpauthor"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:corpauthor"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:authorgroup"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:authorgroup"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:author"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:author"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:othercredit"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:othercredit"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:copyright"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:copyright"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:legalnotice"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:legalnotice"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:pubdate"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:pubdate"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:revision"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:revision"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:revhistory"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:revhistory"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:abstract"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:abstract"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:appendixinfo/d:itermset"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="appendix.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="appendix.titlepage.verso">
</xsl:template>

<xsl:template name="appendix.titlepage.separator">
</xsl:template>

<xsl:template name="appendix.titlepage.before.recto">
</xsl:template>

<xsl:template name="appendix.titlepage.before.verso">
</xsl:template>

<xsl:template name="appendix.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="appendix.titlepage.before.recto"/>
      <xsl:call-template name="appendix.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="appendix.titlepage.before.verso"/>
      <xsl:call-template name="appendix.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="appendix.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="appendix.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="appendix.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="24.8832pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:appendix[1]"/>
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="appendix.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="section.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:sectioninfo/d:title">
      <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:sectioninfo/d:subtitle">
      <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:corpauthor"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:authorgroup"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:author"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:othercredit"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:releaseinfo"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:copyright"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:legalnotice"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:pubdate"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:revision"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:revhistory"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:abstract"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:sectioninfo/d:itermset"/>
  <xsl:apply-templates mode="section.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="section.titlepage.verso">
</xsl:template>

<xsl:template name="section.titlepage.separator">
</xsl:template>

<xsl:template name="section.titlepage.before.recto">
</xsl:template>

<xsl:template name="section.titlepage.before.verso">
</xsl:template>

<xsl:template name="section.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="section.titlepage.before.recto"/>
      <xsl:call-template name="section.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="section.titlepage.before.verso"/>
      <xsl:call-template name="section.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="section.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="section.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="section.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style" margin-left="{$title.margin.left}" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="section.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="sect1.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:sect1info/d:title">
      <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:sect1info/d:subtitle">
      <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:corpauthor"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:authorgroup"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:author"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:othercredit"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:releaseinfo"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:copyright"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:legalnotice"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:pubdate"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:revision"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:revhistory"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:abstract"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:sect1info/d:itermset"/>
  <xsl:apply-templates mode="sect1.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="sect1.titlepage.verso">
</xsl:template>

<xsl:template name="sect1.titlepage.separator">
</xsl:template>

<xsl:template name="sect1.titlepage.before.recto">
</xsl:template>

<xsl:template name="sect1.titlepage.before.verso">
</xsl:template>

<xsl:template name="sect1.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="sect1.titlepage.before.recto"/>
      <xsl:call-template name="sect1.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="sect1.titlepage.before.verso"/>
      <xsl:call-template name="sect1.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="sect1.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="sect1.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="sect1.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style" margin-left="{$title.margin.left}" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="sect1.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="sect2.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:sect2info/d:title">
      <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:sect2info/d:subtitle">
      <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:corpauthor"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:authorgroup"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:author"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:othercredit"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:releaseinfo"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:copyright"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:legalnotice"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:pubdate"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:revision"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:revhistory"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:abstract"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:sect2info/d:itermset"/>
  <xsl:apply-templates mode="sect2.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="sect2.titlepage.verso">
</xsl:template>

<xsl:template name="sect2.titlepage.separator">
</xsl:template>

<xsl:template name="sect2.titlepage.before.recto">
</xsl:template>

<xsl:template name="sect2.titlepage.before.verso">
</xsl:template>

<xsl:template name="sect2.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="sect2.titlepage.before.recto"/>
      <xsl:call-template name="sect2.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="sect2.titlepage.before.verso"/>
      <xsl:call-template name="sect2.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="sect2.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="sect2.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="sect2.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style" margin-left="{$title.margin.left}" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="sect2.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="sect3.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:sect3info/d:title">
      <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:sect3info/d:subtitle">
      <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:corpauthor"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:authorgroup"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:author"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:othercredit"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:releaseinfo"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:copyright"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:legalnotice"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:pubdate"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:revision"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:revhistory"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:abstract"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:sect3info/d:itermset"/>
  <xsl:apply-templates mode="sect3.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="sect3.titlepage.verso">
</xsl:template>

<xsl:template name="sect3.titlepage.separator">
</xsl:template>

<xsl:template name="sect3.titlepage.before.recto">
</xsl:template>

<xsl:template name="sect3.titlepage.before.verso">
</xsl:template>

<xsl:template name="sect3.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="sect3.titlepage.before.recto"/>
      <xsl:call-template name="sect3.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="sect3.titlepage.before.verso"/>
      <xsl:call-template name="sect3.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="sect3.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="sect3.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="sect3.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style" margin-left="{$title.margin.left}" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="sect3.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="sect4.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:sect4info/d:title">
      <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:sect4info/d:subtitle">
      <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:corpauthor"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:authorgroup"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:author"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:othercredit"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:releaseinfo"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:copyright"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:legalnotice"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:pubdate"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:revision"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:revhistory"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:abstract"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:sect4info/d:itermset"/>
  <xsl:apply-templates mode="sect4.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="sect4.titlepage.verso">
</xsl:template>

<xsl:template name="sect4.titlepage.separator">
</xsl:template>

<xsl:template name="sect4.titlepage.before.recto">
</xsl:template>

<xsl:template name="sect4.titlepage.before.verso">
</xsl:template>

<xsl:template name="sect4.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="sect4.titlepage.before.recto"/>
      <xsl:call-template name="sect4.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="sect4.titlepage.before.verso"/>
      <xsl:call-template name="sect4.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="sect4.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="sect4.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="sect4.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style" margin-left="{$title.margin.left}" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="sect4.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="sect5.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:sect5info/d:title">
      <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:sect5info/d:subtitle">
      <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:corpauthor"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:authorgroup"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:author"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:othercredit"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:releaseinfo"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:copyright"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:legalnotice"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:pubdate"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:revision"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:revhistory"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:abstract"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:sect5info/d:itermset"/>
  <xsl:apply-templates mode="sect5.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="sect5.titlepage.verso">
</xsl:template>

<xsl:template name="sect5.titlepage.separator">
</xsl:template>

<xsl:template name="sect5.titlepage.before.recto">
</xsl:template>

<xsl:template name="sect5.titlepage.before.verso">
</xsl:template>

<xsl:template name="sect5.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="sect5.titlepage.before.recto"/>
      <xsl:call-template name="sect5.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="sect5.titlepage.before.verso"/>
      <xsl:call-template name="sect5.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="sect5.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="sect5.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="sect5.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style" margin-left="{$title.margin.left}" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="sect5.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="simplesect.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:simplesectinfo/d:title">
      <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:simplesectinfo/d:subtitle">
      <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:corpauthor"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:corpauthor"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:authorgroup"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:authorgroup"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:author"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:author"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:othercredit"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:othercredit"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:copyright"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:copyright"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:legalnotice"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:legalnotice"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:pubdate"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:pubdate"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:revision"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:revision"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:revhistory"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:revhistory"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:abstract"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:abstract"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:simplesectinfo/d:itermset"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="simplesect.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="simplesect.titlepage.verso">
</xsl:template>

<xsl:template name="simplesect.titlepage.separator">
</xsl:template>

<xsl:template name="simplesect.titlepage.before.recto">
</xsl:template>

<xsl:template name="simplesect.titlepage.before.verso">
</xsl:template>

<xsl:template name="simplesect.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="simplesect.titlepage.before.recto"/>
      <xsl:call-template name="simplesect.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="simplesect.titlepage.before.verso"/>
      <xsl:call-template name="simplesect.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="simplesect.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="simplesect.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="simplesect.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style" margin-left="{$title.margin.left}" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="simplesect.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="dialogue.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:dialogueinfo/d:title">
      <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:dialogueinfo/d:subtitle">
      <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:corpauthor"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:corpauthor"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:authorgroup"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:authorgroup"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:author"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:author"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:othercredit"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:othercredit"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:copyright"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:copyright"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:legalnotice"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:legalnotice"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:pubdate"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:pubdate"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:revision"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:revision"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:revhistory"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:revhistory"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:abstract"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:abstract"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:dialogueinfo/d:itermset"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="dialogue.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="dialogue.titlepage.verso">
</xsl:template>

<xsl:template name="dialogue.titlepage.separator">
</xsl:template>

<xsl:template name="dialogue.titlepage.before.recto">
</xsl:template>

<xsl:template name="dialogue.titlepage.before.verso">
</xsl:template>

<xsl:template name="dialogue.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="dialogue.titlepage.before.recto"/>
      <xsl:call-template name="dialogue.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="dialogue.titlepage.before.verso"/>
      <xsl:call-template name="dialogue.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="dialogue.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="dialogue.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="dialogue.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style" margin-left="{$title.margin.left}" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="dialogue.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="drama.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:dramainfo/d:title">
      <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:dramainfo/d:subtitle">
      <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:corpauthor"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:corpauthor"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:authorgroup"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:authorgroup"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:author"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:author"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:othercredit"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:othercredit"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:releaseinfo"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:copyright"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:copyright"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:legalnotice"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:legalnotice"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:pubdate"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:pubdate"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:revision"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:revision"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:revhistory"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:revhistory"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:abstract"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:abstract"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:dramainfo/d:itermset"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="drama.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="drama.titlepage.verso">
</xsl:template>

<xsl:template name="drama.titlepage.separator">
</xsl:template>

<xsl:template name="drama.titlepage.before.recto">
</xsl:template>

<xsl:template name="drama.titlepage.before.verso">
</xsl:template>

<xsl:template name="drama.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="drama.titlepage.before.recto"/>
      <xsl:call-template name="drama.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="drama.titlepage.before.verso"/>
      <xsl:call-template name="drama.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="drama.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="drama.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="drama.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style" margin-left="{$title.margin.left}" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="drama.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="poetry.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:poetryinfo/d:title">
      <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:poetryinfo/d:subtitle">
      <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:corpauthor"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:corpauthor"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:authorgroup"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:authorgroup"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:author"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:author"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:othercredit"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:othercredit"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:copyright"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:copyright"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:legalnotice"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:legalnotice"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:pubdate"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:pubdate"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:revision"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:revision"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:revhistory"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:revhistory"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:abstract"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:abstract"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:poetryinfo/d:itermset"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="poetry.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="poetry.titlepage.verso">
</xsl:template>

<xsl:template name="poetry.titlepage.separator">
</xsl:template>

<xsl:template name="poetry.titlepage.before.recto">
</xsl:template>

<xsl:template name="poetry.titlepage.before.verso">
</xsl:template>

<xsl:template name="poetry.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="poetry.titlepage.before.recto"/>
      <xsl:call-template name="poetry.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="poetry.titlepage.before.verso"/>
      <xsl:call-template name="poetry.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="poetry.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="poetry.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="poetry.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style" margin-left="{$title.margin.left}" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="poetry.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="topic.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:topicinfo/d:title">
      <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:topicinfo/d:subtitle">
      <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

</xsl:template>

<xsl:template name="topic.titlepage.verso">
</xsl:template>

<xsl:template name="topic.titlepage.separator">
</xsl:template>

<xsl:template name="topic.titlepage.before.recto">
</xsl:template>

<xsl:template name="topic.titlepage.before.verso">
</xsl:template>

<xsl:template name="topic.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="topic.titlepage.before.recto"/>
      <xsl:call-template name="topic.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="topic.titlepage.before.verso"/>
      <xsl:call-template name="topic.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="topic.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="topic.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="topic.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="topic.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="topic.titlepage.recto.style" font-weight="bold" font-size="17.28pt" space-before="1em" space-after="1em" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="topic.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="topic.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="bibliography.titlepage.recto">
  <fo:block xsl:use-attribute-sets="bibliography.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="24.8832pt" font-family="{$title.fontset}" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:bibliography[1]"/>
</xsl:call-template></fo:block>
  <xsl:choose>
    <xsl:when test="d:bibliographyinfo/d:subtitle">
      <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="d:bibliographyinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="d:bibliographyinfo/d:itermset"/>
  <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="bibliography.titlepage.verso">
</xsl:template>

<xsl:template name="bibliography.titlepage.separator">
</xsl:template>

<xsl:template name="bibliography.titlepage.before.recto">
</xsl:template>

<xsl:template name="bibliography.titlepage.before.verso">
</xsl:template>

<xsl:template name="bibliography.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="bibliography.titlepage.before.recto"/>
      <xsl:call-template name="bibliography.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="bibliography.titlepage.before.verso"/>
      <xsl:call-template name="bibliography.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="bibliography.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="bibliography.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="bibliography.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:subtitle" mode="bibliography.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="bibliography.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="bibliography.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="bibliography.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="bibliography.titlepage.recto.style">
<xsl:apply-templates select="." mode="bibliography.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="bibliodiv.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:bibliodivinfo/d:title">
      <xsl:apply-templates mode="bibliodiv.titlepage.recto.auto.mode" select="d:bibliodivinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="bibliodiv.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="bibliodiv.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="bibliodiv.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:bibliodivinfo/d:subtitle">
      <xsl:apply-templates mode="bibliodiv.titlepage.recto.auto.mode" select="d:bibliodivinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="bibliodiv.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="bibliodiv.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="bibliodiv.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="bibliodiv.titlepage.recto.auto.mode" select="d:bibliodivinfo/d:itermset"/>
  <xsl:apply-templates mode="bibliodiv.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="bibliodiv.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="bibliodiv.titlepage.verso">
</xsl:template>

<xsl:template name="bibliodiv.titlepage.separator">
</xsl:template>

<xsl:template name="bibliodiv.titlepage.before.recto">
</xsl:template>

<xsl:template name="bibliodiv.titlepage.before.verso">
</xsl:template>

<xsl:template name="bibliodiv.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="bibliodiv.titlepage.before.recto"/>
      <xsl:call-template name="bibliodiv.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="bibliodiv.titlepage.before.verso"/>
      <xsl:call-template name="bibliodiv.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="bibliodiv.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="bibliodiv.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="bibliodiv.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="bibliodiv.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="bibliodiv.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="20.736pt" font-family="{$title.fontset}" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:bibliodiv[1]"/>
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="bibliodiv.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="bibliodiv.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="bibliodiv.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="bibliodiv.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="bibliodiv.titlepage.recto.style">
<xsl:apply-templates select="." mode="bibliodiv.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="glossary.titlepage.recto">
  <fo:block xsl:use-attribute-sets="glossary.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="24.8832pt" font-family="{$title.fontset}" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:glossary[1]"/>
</xsl:call-template></fo:block>
  <xsl:choose>
    <xsl:when test="d:glossaryinfo/d:subtitle">
      <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="d:glossaryinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="d:glossaryinfo/d:itermset"/>
  <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="glossary.titlepage.verso">
</xsl:template>

<xsl:template name="glossary.titlepage.separator">
</xsl:template>

<xsl:template name="glossary.titlepage.before.recto">
</xsl:template>

<xsl:template name="glossary.titlepage.before.verso">
</xsl:template>

<xsl:template name="glossary.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="glossary.titlepage.before.recto"/>
      <xsl:call-template name="glossary.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="glossary.titlepage.before.verso"/>
      <xsl:call-template name="glossary.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="glossary.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="glossary.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="glossary.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:subtitle" mode="glossary.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="glossary.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="glossary.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="glossary.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="glossary.titlepage.recto.style">
<xsl:apply-templates select="." mode="glossary.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="glossdiv.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:glossdivinfo/d:title">
      <xsl:apply-templates mode="glossdiv.titlepage.recto.auto.mode" select="d:glossdivinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="glossdiv.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="glossdiv.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="glossdiv.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:glossdivinfo/d:subtitle">
      <xsl:apply-templates mode="glossdiv.titlepage.recto.auto.mode" select="d:glossdivinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="glossdiv.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="glossdiv.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="glossdiv.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="glossdiv.titlepage.recto.auto.mode" select="d:glossdivinfo/d:itermset"/>
  <xsl:apply-templates mode="glossdiv.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="glossdiv.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="glossdiv.titlepage.verso">
</xsl:template>

<xsl:template name="glossdiv.titlepage.separator">
</xsl:template>

<xsl:template name="glossdiv.titlepage.before.recto">
</xsl:template>

<xsl:template name="glossdiv.titlepage.before.verso">
</xsl:template>

<xsl:template name="glossdiv.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="glossdiv.titlepage.before.recto"/>
      <xsl:call-template name="glossdiv.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="glossdiv.titlepage.before.verso"/>
      <xsl:call-template name="glossdiv.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="glossdiv.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="glossdiv.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="glossdiv.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="glossdiv.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="glossdiv.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="20.736pt" font-family="{$title.fontset}" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:glossdiv[1]"/>
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="glossdiv.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="glossdiv.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="glossdiv.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="glossdiv.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="glossdiv.titlepage.recto.style">
<xsl:apply-templates select="." mode="glossdiv.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="index.titlepage.recto">
  <fo:block xsl:use-attribute-sets="index.titlepage.recto.style" margin-left="0pt" font-size="24.8832pt" font-family="{$title.fontset}" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:index[1]"/>
<xsl:with-param name="pagewide" select="1"/>
</xsl:call-template></fo:block>
  <xsl:choose>
    <xsl:when test="d:indexinfo/d:subtitle">
      <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="d:indexinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="d:indexinfo/d:itermset"/>
  <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="index.titlepage.verso">
</xsl:template>

<xsl:template name="index.titlepage.separator">
</xsl:template>

<xsl:template name="index.titlepage.before.recto">
</xsl:template>

<xsl:template name="index.titlepage.before.verso">
</xsl:template>

<xsl:template name="index.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="index.titlepage.before.recto"/>
      <xsl:call-template name="index.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="index.titlepage.before.verso"/>
      <xsl:call-template name="index.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="index.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="index.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="index.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:subtitle" mode="index.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="index.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="index.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="index.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="index.titlepage.recto.style">
<xsl:apply-templates select="." mode="index.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="indexdiv.titlepage.recto">
  <fo:block xsl:use-attribute-sets="indexdiv.titlepage.recto.style">
<xsl:call-template name="indexdiv.title">
<xsl:with-param name="title" select="title"/>
</xsl:call-template></fo:block>
  <xsl:choose>
    <xsl:when test="d:indexdivinfo/d:subtitle">
      <xsl:apply-templates mode="indexdiv.titlepage.recto.auto.mode" select="d:indexdivinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="indexdiv.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="indexdiv.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="indexdiv.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="indexdiv.titlepage.recto.auto.mode" select="d:indexdivinfo/d:itermset"/>
  <xsl:apply-templates mode="indexdiv.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="indexdiv.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="indexdiv.titlepage.verso">
</xsl:template>

<xsl:template name="indexdiv.titlepage.separator">
</xsl:template>

<xsl:template name="indexdiv.titlepage.before.recto">
</xsl:template>

<xsl:template name="indexdiv.titlepage.before.verso">
</xsl:template>

<xsl:template name="indexdiv.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="indexdiv.titlepage.before.recto"/>
      <xsl:call-template name="indexdiv.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="indexdiv.titlepage.before.verso"/>
      <xsl:call-template name="indexdiv.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="indexdiv.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="indexdiv.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="indexdiv.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:subtitle" mode="indexdiv.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="indexdiv.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="indexdiv.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="indexdiv.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="indexdiv.titlepage.recto.style">
<xsl:apply-templates select="." mode="indexdiv.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="setindex.titlepage.recto">
  <fo:block xsl:use-attribute-sets="setindex.titlepage.recto.style" margin-left="0pt" font-size="24.8832pt" font-family="{$title.fontset}" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:setindex[1]"/>
<xsl:with-param name="pagewide" select="1"/>
</xsl:call-template></fo:block>
  <xsl:choose>
    <xsl:when test="d:setindexinfo/d:subtitle">
      <xsl:apply-templates mode="setindex.titlepage.recto.auto.mode" select="d:setindexinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="setindex.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="setindex.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="setindex.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="setindex.titlepage.recto.auto.mode" select="d:setindexinfo/d:itermset"/>
  <xsl:apply-templates mode="setindex.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="setindex.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="setindex.titlepage.verso">
</xsl:template>

<xsl:template name="setindex.titlepage.separator">
</xsl:template>

<xsl:template name="setindex.titlepage.before.recto">
</xsl:template>

<xsl:template name="setindex.titlepage.before.verso">
</xsl:template>

<xsl:template name="setindex.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="setindex.titlepage.before.recto"/>
      <xsl:call-template name="setindex.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="setindex.titlepage.before.verso"/>
      <xsl:call-template name="setindex.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="setindex.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="setindex.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="setindex.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:subtitle" mode="setindex.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="setindex.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="setindex.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="setindex.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="setindex.titlepage.recto.style">
<xsl:apply-templates select="." mode="setindex.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="colophon.titlepage.recto">
  <fo:block xsl:use-attribute-sets="colophon.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="24.8832pt" font-family="{$title.fontset}" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:colophon[1]"/>
</xsl:call-template></fo:block>
  <xsl:choose>
    <xsl:when test="d:colophoninfo/d:subtitle">
      <xsl:apply-templates mode="colophon.titlepage.recto.auto.mode" select="d:colophoninfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="colophon.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="colophon.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="colophon.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="colophon.titlepage.recto.auto.mode" select="d:colophoninfo/d:itermset"/>
  <xsl:apply-templates mode="colophon.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="colophon.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="colophon.titlepage.verso">
</xsl:template>

<xsl:template name="colophon.titlepage.separator">
</xsl:template>

<xsl:template name="colophon.titlepage.before.recto">
</xsl:template>

<xsl:template name="colophon.titlepage.before.verso">
</xsl:template>

<xsl:template name="colophon.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="colophon.titlepage.before.recto"/>
      <xsl:call-template name="colophon.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="colophon.titlepage.before.verso"/>
      <xsl:call-template name="colophon.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="colophon.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="colophon.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="colophon.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:subtitle" mode="colophon.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="colophon.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="colophon.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="colophon.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="colophon.titlepage.recto.style">
<xsl:apply-templates select="." mode="colophon.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="sidebar.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:sidebarinfo/d:title">
      <xsl:apply-templates mode="sidebar.titlepage.recto.auto.mode" select="d:sidebarinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="sidebar.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="sidebar.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="sidebar.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:sidebarinfo/d:subtitle">
      <xsl:apply-templates mode="sidebar.titlepage.recto.auto.mode" select="d:sidebarinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="sidebar.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="sidebar.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="sidebar.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="sidebar.titlepage.recto.auto.mode" select="d:sidebarinfo/d:itermset"/>
  <xsl:apply-templates mode="sidebar.titlepage.recto.auto.mode" select="d:docinfo/d:itermset"/>
  <xsl:apply-templates mode="sidebar.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="sidebar.titlepage.verso">
</xsl:template>

<xsl:template name="sidebar.titlepage.separator">
</xsl:template>

<xsl:template name="sidebar.titlepage.before.recto">
</xsl:template>

<xsl:template name="sidebar.titlepage.before.verso">
</xsl:template>

<xsl:template name="sidebar.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="sidebar.titlepage.before.recto"/>
      <xsl:call-template name="sidebar.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="sidebar.titlepage.before.verso"/>
      <xsl:call-template name="sidebar.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="sidebar.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="sidebar.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="sidebar.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="sidebar.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sidebar.titlepage.recto.style" font-family="{$title.fontset}" font-weight="bold">
<xsl:apply-templates select="." mode="sidebar.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="sidebar.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sidebar.titlepage.recto.style" font-family="{$title.fontset}">
<xsl:apply-templates select="." mode="sidebar.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="sidebar.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="sidebar.titlepage.recto.style">
<xsl:apply-templates select="." mode="sidebar.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="qandaset.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:qandasetinfo/d:title">
      <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:blockinfo/d:title">
      <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="d:qandasetinfo/d:subtitle">
      <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:blockinfo/d:subtitle">
      <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:corpauthor"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:corpauthor"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:authorgroup"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:authorgroup"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:author"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:author"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:othercredit"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:othercredit"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:copyright"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:copyright"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:legalnotice"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:legalnotice"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:pubdate"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:pubdate"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:revision"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:revision"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:revhistory"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:revhistory"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:abstract"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:abstract"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:qandasetinfo/d:itermset"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:blockinfo/d:itermset"/>
  <xsl:apply-templates mode="qandaset.titlepage.recto.auto.mode" select="d:info/d:itermset"/>
</xsl:template>

<xsl:template name="qandaset.titlepage.verso">
</xsl:template>

<xsl:template name="qandaset.titlepage.separator">
</xsl:template>

<xsl:template name="qandaset.titlepage.before.recto">
</xsl:template>

<xsl:template name="qandaset.titlepage.before.verso">
</xsl:template>

<xsl:template name="qandaset.titlepage">
  <fo:block font-family="{$title.fontset}">
    <xsl:variable name="recto.content">
      <xsl:call-template name="qandaset.titlepage.before.recto"/>
      <xsl:call-template name="qandaset.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block start-indent="0pt" text-align="center"><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="qandaset.titlepage.before.verso"/>
      <xsl:call-template name="qandaset.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="qandaset.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="qandaset.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="qandaset.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" keep-with-next.within-column="always" font-size="24.8832pt" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:qandaset[1]"/>
</xsl:call-template>
</fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:corpauthor" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" space-before="0.5em" font-size="14.4pt">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:authorgroup" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" space-before="0.5em" font-size="14.4pt">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:author" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" space-before="0.5em" font-size="14.4pt">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:othercredit" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:legalnotice" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" text-align="start" margin-left="0.5in" margin-right="0.5in" font-family="{$body.fontset}">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revision" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:revhistory" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" space-before="0.5em">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:abstract" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style" space-before="0.5em" text-align="start" margin-left="0.5in" margin-right="0.5in" font-family="{$body.fontset}">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template match="d:itermset" mode="qandaset.titlepage.recto.auto.mode">
<fo:block xsl:use-attribute-sets="qandaset.titlepage.recto.style">
<xsl:apply-templates select="." mode="qandaset.titlepage.recto.mode"/>
</fo:block>
</xsl:template>

<xsl:template name="table.of.contents.titlepage.recto">
  <fo:block xsl:use-attribute-sets="table.of.contents.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1.5em" space-before.maximum="2em" space-after="0.5em" start-indent="0pt" font-size="17.28pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'TableofContents'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="table.of.contents.titlepage.verso">
</xsl:template>

<xsl:template name="table.of.contents.titlepage.separator">
</xsl:template>

<xsl:template name="table.of.contents.titlepage.before.recto">
</xsl:template>

<xsl:template name="table.of.contents.titlepage.before.verso">
</xsl:template>

<xsl:template name="table.of.contents.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="table.of.contents.titlepage.before.recto"/>
      <xsl:call-template name="table.of.contents.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="table.of.contents.titlepage.before.verso"/>
      <xsl:call-template name="table.of.contents.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="table.of.contents.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="table.of.contents.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="table.of.contents.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="list.of.tables.titlepage.recto">
  <fo:block xsl:use-attribute-sets="list.of.tables.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1.5em" space-before.maximum="2em" space-after="0.5em" start-indent="0pt" font-size="17.28pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofTables'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="list.of.tables.titlepage.verso">
</xsl:template>

<xsl:template name="list.of.tables.titlepage.separator">
</xsl:template>

<xsl:template name="list.of.tables.titlepage.before.recto">
</xsl:template>

<xsl:template name="list.of.tables.titlepage.before.verso">
</xsl:template>

<xsl:template name="list.of.tables.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="list.of.tables.titlepage.before.recto"/>
      <xsl:call-template name="list.of.tables.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="list.of.tables.titlepage.before.verso"/>
      <xsl:call-template name="list.of.tables.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="list.of.tables.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="list.of.tables.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="list.of.tables.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="list.of.figures.titlepage.recto">
  <fo:block xsl:use-attribute-sets="list.of.figures.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1.5em" space-before.maximum="2em" space-after="0.5em" start-indent="0pt" font-size="17.28pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofFigures'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="list.of.figures.titlepage.verso">
</xsl:template>

<xsl:template name="list.of.figures.titlepage.separator">
</xsl:template>

<xsl:template name="list.of.figures.titlepage.before.recto">
</xsl:template>

<xsl:template name="list.of.figures.titlepage.before.verso">
</xsl:template>

<xsl:template name="list.of.figures.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="list.of.figures.titlepage.before.recto"/>
      <xsl:call-template name="list.of.figures.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="list.of.figures.titlepage.before.verso"/>
      <xsl:call-template name="list.of.figures.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="list.of.figures.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="list.of.figures.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="list.of.figures.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="list.of.examples.titlepage.recto">
  <fo:block xsl:use-attribute-sets="list.of.examples.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1.5em" space-before.maximum="2em" space-after="0.5em" start-indent="0pt" font-size="17.28pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofExamples'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="list.of.examples.titlepage.verso">
</xsl:template>

<xsl:template name="list.of.examples.titlepage.separator">
</xsl:template>

<xsl:template name="list.of.examples.titlepage.before.recto">
</xsl:template>

<xsl:template name="list.of.examples.titlepage.before.verso">
</xsl:template>

<xsl:template name="list.of.examples.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="list.of.examples.titlepage.before.recto"/>
      <xsl:call-template name="list.of.examples.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="list.of.examples.titlepage.before.verso"/>
      <xsl:call-template name="list.of.examples.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="list.of.examples.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="list.of.examples.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="list.of.examples.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="list.of.equations.titlepage.recto">
  <fo:block xsl:use-attribute-sets="list.of.equations.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1.5em" space-before.maximum="2em" space-after="0.5em" start-indent="0pt" font-size="17.28pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofEquations'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="list.of.equations.titlepage.verso">
</xsl:template>

<xsl:template name="list.of.equations.titlepage.separator">
</xsl:template>

<xsl:template name="list.of.equations.titlepage.before.recto">
</xsl:template>

<xsl:template name="list.of.equations.titlepage.before.verso">
</xsl:template>

<xsl:template name="list.of.equations.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="list.of.equations.titlepage.before.recto"/>
      <xsl:call-template name="list.of.equations.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="list.of.equations.titlepage.before.verso"/>
      <xsl:call-template name="list.of.equations.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="list.of.equations.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="list.of.equations.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="list.of.equations.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="list.of.procedures.titlepage.recto">
  <fo:block xsl:use-attribute-sets="list.of.procedures.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1.5em" space-before.maximum="2em" space-after="0.5em" start-indent="0pt" font-size="17.28pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofProcedures'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="list.of.procedures.titlepage.verso">
</xsl:template>

<xsl:template name="list.of.procedures.titlepage.separator">
</xsl:template>

<xsl:template name="list.of.procedures.titlepage.before.recto">
</xsl:template>

<xsl:template name="list.of.procedures.titlepage.before.verso">
</xsl:template>

<xsl:template name="list.of.procedures.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="list.of.procedures.titlepage.before.recto"/>
      <xsl:call-template name="list.of.procedures.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="list.of.procedures.titlepage.before.verso"/>
      <xsl:call-template name="list.of.procedures.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="list.of.procedures.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="list.of.procedures.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="list.of.procedures.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="list.of.unknowns.titlepage.recto">
  <fo:block xsl:use-attribute-sets="list.of.unknowns.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1.5em" space-before.maximum="2em" space-after="0.5em" start-indent="0pt" font-size="17.28pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofUnknown'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="list.of.unknowns.titlepage.verso">
</xsl:template>

<xsl:template name="list.of.unknowns.titlepage.separator">
</xsl:template>

<xsl:template name="list.of.unknowns.titlepage.before.recto">
</xsl:template>

<xsl:template name="list.of.unknowns.titlepage.before.verso">
</xsl:template>

<xsl:template name="list.of.unknowns.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="list.of.unknowns.titlepage.before.recto"/>
      <xsl:call-template name="list.of.unknowns.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="list.of.unknowns.titlepage.before.verso"/>
      <xsl:call-template name="list.of.unknowns.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="list.of.unknowns.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="list.of.unknowns.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="list.of.unknowns.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="component.list.of.tables.titlepage.recto">
  <fo:block xsl:use-attribute-sets="component.list.of.tables.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1em" space-before.maximum="1em" space-after="0.5em" margin-left="{$title.margin.left}" font-size="12pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofTables'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="component.list.of.tables.titlepage.verso">
</xsl:template>

<xsl:template name="component.list.of.tables.titlepage.separator">
</xsl:template>

<xsl:template name="component.list.of.tables.titlepage.before.recto">
</xsl:template>

<xsl:template name="component.list.of.tables.titlepage.before.verso">
</xsl:template>

<xsl:template name="component.list.of.tables.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="component.list.of.tables.titlepage.before.recto"/>
      <xsl:call-template name="component.list.of.tables.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="component.list.of.tables.titlepage.before.verso"/>
      <xsl:call-template name="component.list.of.tables.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="component.list.of.tables.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="component.list.of.tables.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="component.list.of.tables.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="component.list.of.figures.titlepage.recto">
  <fo:block xsl:use-attribute-sets="component.list.of.figures.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1em" space-before.maximum="1em" space-after="0.5em" margin-left="{$title.margin.left}" font-size="12pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofFigures'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="component.list.of.figures.titlepage.verso">
</xsl:template>

<xsl:template name="component.list.of.figures.titlepage.separator">
</xsl:template>

<xsl:template name="component.list.of.figures.titlepage.before.recto">
</xsl:template>

<xsl:template name="component.list.of.figures.titlepage.before.verso">
</xsl:template>

<xsl:template name="component.list.of.figures.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="component.list.of.figures.titlepage.before.recto"/>
      <xsl:call-template name="component.list.of.figures.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="component.list.of.figures.titlepage.before.verso"/>
      <xsl:call-template name="component.list.of.figures.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="component.list.of.figures.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="component.list.of.figures.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="component.list.of.figures.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="component.list.of.examples.titlepage.recto">
  <fo:block xsl:use-attribute-sets="component.list.of.examples.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1em" space-before.maximum="1em" space-after="0.5em" margin-left="{$title.margin.left}" font-size="12pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofExamples'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="component.list.of.examples.titlepage.verso">
</xsl:template>

<xsl:template name="component.list.of.examples.titlepage.separator">
</xsl:template>

<xsl:template name="component.list.of.examples.titlepage.before.recto">
</xsl:template>

<xsl:template name="component.list.of.examples.titlepage.before.verso">
</xsl:template>

<xsl:template name="component.list.of.examples.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="component.list.of.examples.titlepage.before.recto"/>
      <xsl:call-template name="component.list.of.examples.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="component.list.of.examples.titlepage.before.verso"/>
      <xsl:call-template name="component.list.of.examples.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="component.list.of.examples.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="component.list.of.examples.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="component.list.of.examples.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="component.list.of.equations.titlepage.recto">
  <fo:block xsl:use-attribute-sets="component.list.of.equations.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1em" space-before.maximum="1em" space-after="0.5em" margin-left="{$title.margin.left}" font-size="12pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofEquations'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="component.list.of.equations.titlepage.verso">
</xsl:template>

<xsl:template name="component.list.of.equations.titlepage.separator">
</xsl:template>

<xsl:template name="component.list.of.equations.titlepage.before.recto">
</xsl:template>

<xsl:template name="component.list.of.equations.titlepage.before.verso">
</xsl:template>

<xsl:template name="component.list.of.equations.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="component.list.of.equations.titlepage.before.recto"/>
      <xsl:call-template name="component.list.of.equations.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="component.list.of.equations.titlepage.before.verso"/>
      <xsl:call-template name="component.list.of.equations.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="component.list.of.equations.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="component.list.of.equations.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="component.list.of.equations.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="component.list.of.procedures.titlepage.recto">
  <fo:block xsl:use-attribute-sets="component.list.of.procedures.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1em" space-before.maximum="1em" space-after="0.5em" margin-left="{$title.margin.left}" font-size="12pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofProcedures'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="component.list.of.procedures.titlepage.verso">
</xsl:template>

<xsl:template name="component.list.of.procedures.titlepage.separator">
</xsl:template>

<xsl:template name="component.list.of.procedures.titlepage.before.recto">
</xsl:template>

<xsl:template name="component.list.of.procedures.titlepage.before.verso">
</xsl:template>

<xsl:template name="component.list.of.procedures.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="component.list.of.procedures.titlepage.before.recto"/>
      <xsl:call-template name="component.list.of.procedures.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="component.list.of.procedures.titlepage.before.verso"/>
      <xsl:call-template name="component.list.of.procedures.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="component.list.of.procedures.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="component.list.of.procedures.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="component.list.of.procedures.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="component.list.of.unknowns.titlepage.recto">
  <fo:block xsl:use-attribute-sets="component.list.of.unknowns.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1em" space-before.maximum="1em" space-after="0.5em" margin-left="{$title.margin.left}" font-size="12pt" font-weight="bold" font-family="{$title.fontset}">
<xsl:call-template name="gentext">
<xsl:with-param name="key" select="'ListofUnknown'"/>
</xsl:call-template></fo:block>
</xsl:template>

<xsl:template name="component.list.of.unknowns.titlepage.verso">
</xsl:template>

<xsl:template name="component.list.of.unknowns.titlepage.separator">
</xsl:template>

<xsl:template name="component.list.of.unknowns.titlepage.before.recto">
</xsl:template>

<xsl:template name="component.list.of.unknowns.titlepage.before.verso">
</xsl:template>

<xsl:template name="component.list.of.unknowns.titlepage">
  <fo:block>
    <xsl:variable name="recto.content">
      <xsl:call-template name="component.list.of.unknowns.titlepage.before.recto"/>
      <xsl:call-template name="component.list.of.unknowns.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$recto.content"/></fo:block>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="component.list.of.unknowns.titlepage.before.verso"/>
      <xsl:call-template name="component.list.of.unknowns.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <fo:block><xsl:copy-of select="$verso.content"/></fo:block>
    </xsl:if>
    <xsl:call-template name="component.list.of.unknowns.titlepage.separator"/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="component.list.of.unknowns.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="component.list.of.unknowns.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

</xsl:stylesheet>
