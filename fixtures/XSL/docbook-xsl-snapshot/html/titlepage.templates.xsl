<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook" xmlns:exsl="http://exslt.org/common" version="1.0" exclude-result-prefixes="exsl d">

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
</xsl:template>

<xsl:template name="article.titlepage.verso">
</xsl:template>

<xsl:template name="article.titlepage.separator"><hr/>
</xsl:template>

<xsl:template name="article.titlepage.before.recto">
</xsl:template>

<xsl:template name="article.titlepage.before.verso">
</xsl:template>

<xsl:template name="article.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="article.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
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
</xsl:template>

<xsl:template name="set.titlepage.verso">
</xsl:template>

<xsl:template name="set.titlepage.separator"><hr/>
</xsl:template>

<xsl:template name="set.titlepage.before.recto">
</xsl:template>

<xsl:template name="set.titlepage.before.verso">
</xsl:template>

<xsl:template name="set.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="set.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="set.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="set.titlepage.recto.style">
<xsl:apply-templates select="." mode="set.titlepage.recto.mode"/>
</div>
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
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:othercredit"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:copyright"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:legalnotice"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:pubdate"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:revision"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:revhistory"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:bookinfo/d:abstract"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
</xsl:template>

<xsl:template name="book.titlepage.verso">
</xsl:template>

<xsl:template name="book.titlepage.separator"><hr/>
</xsl:template>

<xsl:template name="book.titlepage.before.recto">
</xsl:template>

<xsl:template name="book.titlepage.before.verso">
</xsl:template>

<xsl:template name="book.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="book.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="book.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="book.titlepage.recto.style">
<xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template name="part.titlepage.recto">
  <div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:call-template name="division.title">
<xsl:with-param name="node" select="ancestor-or-self::d:part[1]"/>
</xsl:call-template></div>
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

  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:corpauthor"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:corpauthor"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:authorgroup"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:authorgroup"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:author"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:author"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:othercredit"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:othercredit"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:copyright"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:copyright"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:legalnotice"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:legalnotice"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:pubdate"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:pubdate"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:revision"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:revision"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:revhistory"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:revhistory"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:partinfo/d:abstract"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:docinfo/d:abstract"/>
  <xsl:apply-templates mode="part.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="part.titlepage.separator"/>
  </div>
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

<xsl:template match="d:subtitle" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="part.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="part.titlepage.recto.style">
<xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
</div>
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
  <div>
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="partintro.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="partintro.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="partintro.titlepage.recto.style">
<xsl:apply-templates select="." mode="partintro.titlepage.recto.mode"/>
</div>
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
</xsl:template>

<xsl:template name="reference.titlepage.verso">
</xsl:template>

<xsl:template name="reference.titlepage.separator"><hr/>
</xsl:template>

<xsl:template name="reference.titlepage.before.recto">
</xsl:template>

<xsl:template name="reference.titlepage.before.verso">
</xsl:template>

<xsl:template name="reference.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="reference.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="reference.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="reference.titlepage.recto.style">
<xsl:apply-templates select="." mode="reference.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template name="refentry.titlepage.recto">
</xsl:template>

<xsl:template name="refentry.titlepage.verso">
</xsl:template>

<xsl:template name="refentry.titlepage.separator">
</xsl:template>

<xsl:template name="refentry.titlepage.before.recto">
</xsl:template>

<xsl:template name="refentry.titlepage.before.verso">
</xsl:template>

<xsl:template name="refentry.titlepage">
  <div class="titlepage">
    <xsl:variable name="recto.content">
      <xsl:call-template name="refentry.titlepage.before.recto"/>
      <xsl:call-template name="refentry.titlepage.recto"/>
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
      <div><xsl:copy-of select="$recto.content"/></div>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="refentry.titlepage.before.verso"/>
      <xsl:call-template name="refentry.titlepage.verso"/>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="refentry.titlepage.separator"/>
  </div>
</xsl:template>

<xsl:template match="*" mode="refentry.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="refentry.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template name="dedication.titlepage.recto">
  <div xsl:use-attribute-sets="dedication.titlepage.recto.style">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:dedication[1]"/>
</xsl:call-template></div>
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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="dedication.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="dedication.titlepage.recto.style">
<xsl:apply-templates select="." mode="dedication.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template name="acknowledgements.titlepage.recto">
  <div xsl:use-attribute-sets="acknowledgements.titlepage.recto.style">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:acknowledgements[1]"/>
</xsl:call-template></div>
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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="acknowledgements.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="acknowledgements.titlepage.recto.style">
<xsl:apply-templates select="." mode="acknowledgements.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template name="preface.titlepage.recto">
  <xsl:choose>
    <xsl:when test="d:prefaceinfo/d:title">
      <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:prefaceinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:title">
      <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:docinfo/d:title"/>
    </xsl:when>
    <xsl:when test="d:info/d:title">
      <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:info/d:title"/>
    </xsl:when>
    <xsl:when test="d:title">
      <xsl:apply-templates mode="preface.titlepage.recto.auto.mode" select="d:title"/>
    </xsl:when>
  </xsl:choose>

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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="preface.titlepage.separator"/>
  </div>
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

<xsl:template match="d:title" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="preface.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preface.titlepage.recto.style">
<xsl:apply-templates select="." mode="preface.titlepage.recto.mode"/>
</div>
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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="chapter.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="chapter.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="chapter.titlepage.recto.style">
<xsl:apply-templates select="." mode="chapter.titlepage.recto.mode"/>
</div>
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

  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:corpauthor"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:corpauthor"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:authorgroup"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:authorgroup"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:author"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:author"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:othercredit"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:othercredit"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:releaseinfo"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:releaseinfo"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:copyright"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:legalnotice"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:legalnotice"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:pubdate"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:pubdate"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:revision"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:revision"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:revhistory"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:revhistory"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:topicinfo/d:abstract"/>
  <xsl:apply-templates mode="topic.titlepage.recto.auto.mode" select="d:info/d:abstract"/>
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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="topic.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="topic.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="topic.titlepage.recto.style">
<xsl:apply-templates select="." mode="topic.titlepage.recto.mode"/>
</div>
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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="appendix.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="appendix.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="appendix.titlepage.recto.style">
<xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
</div>
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
</xsl:template>

<xsl:template name="section.titlepage.verso">
</xsl:template>

<xsl:template name="section.titlepage.separator"><xsl:if test="count(parent::*)='0'"><hr/></xsl:if>
</xsl:template>

<xsl:template name="section.titlepage.before.recto">
</xsl:template>

<xsl:template name="section.titlepage.before.verso">
</xsl:template>

<xsl:template name="section.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="section.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="section.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="section.titlepage.recto.style">
<xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
</div>
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
</xsl:template>

<xsl:template name="sect1.titlepage.verso">
</xsl:template>

<xsl:template name="sect1.titlepage.separator"><xsl:if test="count(parent::*)='0'"><hr/></xsl:if>
</xsl:template>

<xsl:template name="sect1.titlepage.before.recto">
</xsl:template>

<xsl:template name="sect1.titlepage.before.verso">
</xsl:template>

<xsl:template name="sect1.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="sect1.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="sect1.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect1.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect1.titlepage.recto.mode"/>
</div>
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
</xsl:template>

<xsl:template name="sect2.titlepage.verso">
</xsl:template>

<xsl:template name="sect2.titlepage.separator"><xsl:if test="count(parent::*)='0'"><hr/></xsl:if>
</xsl:template>

<xsl:template name="sect2.titlepage.before.recto">
</xsl:template>

<xsl:template name="sect2.titlepage.before.verso">
</xsl:template>

<xsl:template name="sect2.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="sect2.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="sect2.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect2.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect2.titlepage.recto.mode"/>
</div>
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
</xsl:template>

<xsl:template name="sect3.titlepage.verso">
</xsl:template>

<xsl:template name="sect3.titlepage.separator"><xsl:if test="count(parent::*)='0'"><hr/></xsl:if>
</xsl:template>

<xsl:template name="sect3.titlepage.before.recto">
</xsl:template>

<xsl:template name="sect3.titlepage.before.verso">
</xsl:template>

<xsl:template name="sect3.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="sect3.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="sect3.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect3.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect3.titlepage.recto.mode"/>
</div>
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
</xsl:template>

<xsl:template name="sect4.titlepage.verso">
</xsl:template>

<xsl:template name="sect4.titlepage.separator"><xsl:if test="count(parent::*)='0'"><hr/></xsl:if>
</xsl:template>

<xsl:template name="sect4.titlepage.before.recto">
</xsl:template>

<xsl:template name="sect4.titlepage.before.verso">
</xsl:template>

<xsl:template name="sect4.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="sect4.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="sect4.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect4.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect4.titlepage.recto.mode"/>
</div>
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
</xsl:template>

<xsl:template name="sect5.titlepage.verso">
</xsl:template>

<xsl:template name="sect5.titlepage.separator"><xsl:if test="count(parent::*)='0'"><hr/></xsl:if>
</xsl:template>

<xsl:template name="sect5.titlepage.before.recto">
</xsl:template>

<xsl:template name="sect5.titlepage.before.verso">
</xsl:template>

<xsl:template name="sect5.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="sect5.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="sect5.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sect5.titlepage.recto.style">
<xsl:apply-templates select="." mode="sect5.titlepage.recto.mode"/>
</div>
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
</xsl:template>

<xsl:template name="simplesect.titlepage.verso">
</xsl:template>

<xsl:template name="simplesect.titlepage.separator"><xsl:if test="count(parent::*)='0'"><hr/></xsl:if>
</xsl:template>

<xsl:template name="simplesect.titlepage.before.recto">
</xsl:template>

<xsl:template name="simplesect.titlepage.before.verso">
</xsl:template>

<xsl:template name="simplesect.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="simplesect.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:corpauthor" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:author" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:othercredit" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:copyright" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:legalnotice" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:pubdate" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revision" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:revhistory" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:abstract" mode="simplesect.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="simplesect.titlepage.recto.style">
<xsl:apply-templates select="." mode="simplesect.titlepage.recto.mode"/>
</div>
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

</xsl:template>

<xsl:template name="dialogue.titlepage.verso">
</xsl:template>

<xsl:template name="dialogue.titlepage.separator"><xsl:if test="count(parent::*)='0'"><hr/></xsl:if>
</xsl:template>

<xsl:template name="dialogue.titlepage.before.recto">
</xsl:template>

<xsl:template name="dialogue.titlepage.before.verso">
</xsl:template>

<xsl:template name="dialogue.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="dialogue.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="dialogue.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="dialogue.titlepage.recto.style">
<xsl:apply-templates select="." mode="dialogue.titlepage.recto.mode"/>
</div>
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

</xsl:template>

<xsl:template name="drama.titlepage.verso">
</xsl:template>

<xsl:template name="drama.titlepage.separator"><xsl:if test="count(parent::*)='0'"><hr/></xsl:if>
</xsl:template>

<xsl:template name="drama.titlepage.before.recto">
</xsl:template>

<xsl:template name="drama.titlepage.before.verso">
</xsl:template>

<xsl:template name="drama.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="drama.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="drama.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="drama.titlepage.recto.style">
<xsl:apply-templates select="." mode="drama.titlepage.recto.mode"/>
</div>
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

</xsl:template>

<xsl:template name="poetry.titlepage.verso">
</xsl:template>

<xsl:template name="poetry.titlepage.separator"><xsl:if test="count(parent::*)='0'"><hr/></xsl:if>
</xsl:template>

<xsl:template name="poetry.titlepage.before.recto">
</xsl:template>

<xsl:template name="poetry.titlepage.before.verso">
</xsl:template>

<xsl:template name="poetry.titlepage">
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="poetry.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="d:subtitle" mode="poetry.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="poetry.titlepage.recto.style">
<xsl:apply-templates select="." mode="poetry.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template name="bibliography.titlepage.recto">
  <div xsl:use-attribute-sets="bibliography.titlepage.recto.style">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:bibliography[1]"/>
</xsl:call-template></div>
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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="bibliography.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="bibliography.titlepage.recto.style">
<xsl:apply-templates select="." mode="bibliography.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template name="glossary.titlepage.recto">
  <div xsl:use-attribute-sets="glossary.titlepage.recto.style">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:glossary[1]"/>
</xsl:call-template></div>
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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="glossary.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="glossary.titlepage.recto.style">
<xsl:apply-templates select="." mode="glossary.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template name="index.titlepage.recto">
  <div xsl:use-attribute-sets="index.titlepage.recto.style">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:index[1]"/>
</xsl:call-template></div>
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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="index.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="index.titlepage.recto.style">
<xsl:apply-templates select="." mode="index.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template name="setindex.titlepage.recto">
  <div xsl:use-attribute-sets="setindex.titlepage.recto.style">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:setindex[1]"/>
</xsl:call-template></div>
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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="setindex.titlepage.separator"/>
  </div>
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
<div xsl:use-attribute-sets="setindex.titlepage.recto.style">
<xsl:apply-templates select="." mode="setindex.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template name="sidebar.titlepage.recto">
  <div xsl:use-attribute-sets="sidebar.titlepage.recto.style">
<xsl:call-template name="formal.object.heading">
<xsl:with-param name="node" select="ancestor-or-self::d:sidebar[1]"/>
</xsl:call-template></div>
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
  <div class="titlepage">
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
      <div><xsl:copy-of select="$recto.content"/></div>
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
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="sidebar.titlepage.separator"/>
  </div>
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

<xsl:template match="d:subtitle" mode="sidebar.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="sidebar.titlepage.recto.style">
<xsl:apply-templates select="." mode="sidebar.titlepage.recto.mode"/>
</div>
</xsl:template>

</xsl:stylesheet>
