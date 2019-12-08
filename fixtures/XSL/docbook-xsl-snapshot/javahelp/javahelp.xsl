<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:d="http://docbook.org/ns/docbook"
		xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:ng="http://docbook.org/docbook-ng"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:exsl="http://exslt.org/common"
		version="1.0"
		exclude-result-prefixes="doc ng db exsl d">

<xsl:import href="../html/chunk.xsl"/>

<xsl:output method="html"/>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:variable name="with.namespace">
  <xsl:if test="$exsl.node.set.available != 0 and 
                namespace-uri(/*) != 'http://docbook.org/ns/docbook'">
      <xsl:apply-templates select="/*" mode="addNS"/>
  </xsl:if>
</xsl:variable>

<xsl:template match="/">
  <!-- * Get a title for current doc so that we let the user -->
  <!-- * know what document we are processing at this point. -->
  <xsl:variable name="doc.title">
    <xsl:call-template name="get.doc.title"/>
  </xsl:variable>
  <xsl:choose>
    <!-- fix namespace if necessary -->
    <xsl:when test="$exsl.node.set.available != 0 and 
                  namespace-uri(/*) != 'http://docbook.org/ns/docbook'">
      <xsl:call-template name="log.message">
        <xsl:with-param name="level">Note</xsl:with-param>
        <xsl:with-param name="source" select="$doc.title"/>
        <xsl:with-param name="context-desc">
          <xsl:text>namesp. add</xsl:text>
        </xsl:with-param>
        <xsl:with-param name="message">
          <xsl:text>added namespace before processing</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
      <!-- DEBUG: uncomment to save namespace-fixed document.
      <xsl:message>Saving namespace-fixed document.</xsl:message>
      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="'namespace-fixed.debug.xml'"/>
        <xsl:with-param name="method" select="'xml'"/>
        <xsl:with-param name="content">
          <xsl:copy-of select="exsl:node-set($with.namespace)"/>
        </xsl:with-param>
      </xsl:call-template>
      -->
      <xsl:apply-templates select="exsl:node-set($with.namespace)"/>
    </xsl:when>
    <!-- Can't process unless namespace fixed with exsl node-set()-->
    <xsl:when test="namespace-uri(/*) != 'http://docbook.org/ns/docbook'">
      <xsl:message terminate="yes">
        <xsl:text>Unable to add the namespace from DB4 document,</xsl:text>
        <xsl:text> cannot proceed.</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$rootid != ''">
          <xsl:choose>
            <xsl:when test="count(key('id',$rootid)) = 0">
              <xsl:message terminate="yes">
                <xsl:text>ID '</xsl:text>
                <xsl:value-of select="$rootid"/>
                <xsl:text>' not found in document.</xsl:text>
              </xsl:message>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>Formatting from <xsl:value-of select="$rootid"/></xsl:message>
              <xsl:apply-templates select="key('id',$rootid)" mode="process.root"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="/" mode="process.root"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:for-each select="/">    <!-- This is just a hook for building profiling stylesheets -->
        <xsl:call-template name="helpset"/>
        <xsl:call-template name="helptoc"/>
        <xsl:call-template name="helpmap"/>
        <xsl:call-template name="helpidx"/>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:param name="suppress.navigation" select="1"/>

<!-- ==================================================================== -->

<xsl:template name="helpset">
  <xsl:call-template name="write.chunk.with.doctype">
    <xsl:with-param name="filename" select="concat($chunk.base.dir,'jhelpset.hs')"/>
    <xsl:with-param name="method" select="'xml'"/>
    <xsl:with-param name="indent" select="'yes'"/>
    <xsl:with-param name="doctype-public" select="'-//Sun Microsystems Inc.//DTD JavaHelp HelpSet Version 1.0//EN'"/>
    <xsl:with-param name="doctype-system" select="'http://java.sun.com/products/javahelp/helpset_1_0.dtd'"/>
    <xsl:with-param name="content">
      <xsl:call-template name="helpset.content"/>
    </xsl:with-param>
    <xsl:with-param name="quiet" select="$chunk.quietly"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="helpset.content">
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <helpset version="1.0">
    <title>
      <xsl:value-of select="normalize-space($title)"/>
    </title>

    <!-- maps -->
    <maps>
      <homeID>top</homeID>
      <mapref location="jhelpmap.jhm"/>
    </maps>

    <!-- views -->
    <view>
      <name>TOC</name>
      <label>Table Of Contents</label>
      <type>javax.help.TOCView</type>
      <data>jhelptoc.xml</data>
    </view>

    <view>
      <name>Index</name>
      <label>Index</label>
      <type>javax.help.IndexView</type>
      <data>jhelpidx.xml</data>
    </view>

    <view>
      <name>Search</name>
      <label>Search</label>
      <type>javax.help.SearchView</type>
      <data engine="com.sun.java.help.search.DefaultSearchEngine">JavaHelpSearch</data>
    </view>
  </helpset>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="helptoc">
  <xsl:call-template name="write.chunk.with.doctype">
    <xsl:with-param name="filename" select="concat($chunk.base.dir,'jhelptoc.xml')"/>
    <xsl:with-param name="method" select="'xml'"/>
    <xsl:with-param name="indent" select="'yes'"/>
    <xsl:with-param name="doctype-public" select="'-//Sun Microsystems Inc.//DTD JavaHelp TOC Version 1.0//EN'"/>
    <xsl:with-param name="doctype-system" select="'http://java.sun.com/products/javahelp/toc_1_0.dtd'"/>
    <xsl:with-param name="encoding" select="$javahelp.encoding"/>
    <xsl:with-param name="content">
      <xsl:call-template name="helptoc.content"/>
    </xsl:with-param>
    <xsl:with-param name="quiet" select="$chunk.quietly"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="helptoc.content">
  <toc version="1.0">
    <xsl:choose>
      <xsl:when test="$rootid != ''">
        <xsl:apply-templates select="key('id',$rootid)" mode="jhtoc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="jhtoc"/>
      </xsl:otherwise>
    </xsl:choose>
  </toc>
</xsl:template>

<xsl:template match="d:set" mode="jhtoc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <tocitem target="{$id}">
    <xsl:attribute name="text">
      <xsl:value-of select="normalize-space($title)"/>
    </xsl:attribute>
    <xsl:apply-templates select="d:book" mode="jhtoc"/>
  </tocitem>
</xsl:template>

<xsl:template match="d:book" mode="jhtoc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <tocitem target="{$id}">
    <xsl:attribute name="text">
      <xsl:value-of select="normalize-space($title)"/>
    </xsl:attribute>
    <xsl:apply-templates select="d:part|d:reference|d:preface|d:chapter|d:appendix|d:article|d:colophon|d:glossary|d:bibliography"
                         mode="jhtoc"/>
  </tocitem>
</xsl:template>

<xsl:template match="d:part|d:reference|d:preface|d:chapter|d:appendix|d:article"
              mode="jhtoc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <tocitem target="{$id}">
    <xsl:attribute name="text">
      <xsl:value-of select="normalize-space($title)"/>
    </xsl:attribute>
    <xsl:apply-templates
      select="d:article|d:preface|d:chapter|d:appendix|d:refentry|d:section|d:sect1|d:glossary|d:bibliography"
      mode="jhtoc"/>
  </tocitem>
</xsl:template>

<xsl:template match="d:section" mode="jhtoc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <tocitem target="{$id}">
    <xsl:attribute name="text">
      <xsl:value-of select="normalize-space($title)"/>
    </xsl:attribute>
    <xsl:apply-templates select="d:section" mode="jhtoc"/>
  </tocitem>
</xsl:template>

<xsl:template match="d:sect1" mode="jhtoc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <tocitem target="{$id}">
    <xsl:attribute name="text">
      <xsl:value-of select="normalize-space($title)"/>
    </xsl:attribute>
    <xsl:apply-templates select="d:sect2" mode="jhtoc"/>
  </tocitem>
</xsl:template>

<xsl:template match="d:sect2" mode="jhtoc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <tocitem target="{$id}">
    <xsl:attribute name="text">
      <xsl:value-of select="normalize-space($title)"/>
    </xsl:attribute>
    <xsl:apply-templates select="d:sect3" mode="jhtoc"/>
  </tocitem>
</xsl:template>

<xsl:template match="d:sect3" mode="jhtoc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <tocitem target="{$id}">
    <xsl:attribute name="text">
      <xsl:value-of select="normalize-space($title)"/>
    </xsl:attribute>
    <xsl:apply-templates select="d:sect4" mode="jhtoc"/>
  </tocitem>
</xsl:template>

<xsl:template match="d:sect4" mode="jhtoc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <tocitem target="{$id}">
    <xsl:attribute name="text">
      <xsl:value-of select="normalize-space($title)"/>
    </xsl:attribute>
    <xsl:apply-templates select="d:sect5" mode="jhtoc"/>
  </tocitem>
</xsl:template>

<xsl:template match="d:sect5|d:colophon|d:refentry" mode="jhtoc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <tocitem target="{$id}">
    <xsl:attribute name="text">
      <xsl:value-of select="normalize-space($title)"/>
    </xsl:attribute>
  </tocitem>
</xsl:template>


<xsl:template match="d:glossary" mode="jhtoc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="title">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Glossary'"/>
    </xsl:call-template>
  </xsl:variable>

  <tocitem target="{$id}">
    <xsl:attribute name="text">
      <xsl:value-of select="$title"/>
    </xsl:attribute>
  </tocitem>

</xsl:template>

<xsl:template match="d:bibliography" mode="jhtoc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="title">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Bibliography'"/>
    </xsl:call-template>
  </xsl:variable>

  <tocitem target="{$id}">
    <xsl:attribute name="text">
      <xsl:value-of select="$title"/>
    </xsl:attribute>
    
  </tocitem>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="helpmap">
  <xsl:call-template name="write.chunk.with.doctype">
    <xsl:with-param name="filename" select="concat($chunk.base.dir, 'jhelpmap.jhm')"/>
    <xsl:with-param name="method" select="'xml'"/>
    <xsl:with-param name="indent" select="'yes'"/>
    <xsl:with-param name="doctype-public" select="'-//Sun Microsystems Inc.//DTD JavaHelp Map Version 1.0//EN'"/>
    <xsl:with-param name="doctype-system" select="'http://java.sun.com/products/javahelp/map_1_0.dtd'"/>
    <xsl:with-param name="encoding" select="$javahelp.encoding"/>
    <xsl:with-param name="content">
      <xsl:call-template name="helpmap.content"/>
    </xsl:with-param>
    <xsl:with-param name="quiet" select="$chunk.quietly"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="helpmap.content">
  <map version="1.0">
    <xsl:choose>
      <xsl:when test="$rootid != ''">
        <xsl:apply-templates select="key('id',$rootid)//d:set
                                     | key('id',$rootid)//d:book
                                     | key('id',$rootid)//d:part
                                     | key('id',$rootid)//d:reference
                                     | key('id',$rootid)//d:preface
                                     | key('id',$rootid)//d:chapter
                                     | key('id',$rootid)//d:appendix
                                     | key('id',$rootid)//d:article
                                     | key('id',$rootid)//d:colophon
                                     | key('id',$rootid)//d:refentry
                                     | key('id',$rootid)//d:section
                                     | key('id',$rootid)//d:sect1
                                     | key('id',$rootid)//d:sect2
                                     | key('id',$rootid)//d:sect3
                                     | key('id',$rootid)//d:sect4
                                     | key('id',$rootid)//d:sect5
                                     | key('id',$rootid)//d:indexterm
                                     | key('id',$rootid)//d:glossary
                                     | key('id',$rootid)//d:bibliography
				     | key('id',$rootid)//*[@id]"
                             mode="map"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="//d:set
                                     | //d:book
                                     | //d:part
                                     | //d:reference
                                     | //d:preface
                                     | //d:chapter
                                     | //d:appendix
                                     | //d:article
                                     | //d:colophon
                                     | //d:refentry
                                     | //d:section
                                     | //d:sect1
                                     | //d:sect2
                                     | //d:sect3
                                     | //d:sect4
                                     | //d:sect5
                                     | //d:indexterm
                                     | //d:glossary
                                     | //d:bibliography
				     | //*[@id]"
                             mode="map"/>
      </xsl:otherwise>
    </xsl:choose>
  </map>
</xsl:template>

<xsl:template match="d:set" mode="map">
  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <mapID target="{$id}">
    <xsl:attribute name="url">
      <xsl:call-template name="href.target.uri"/>
    </xsl:attribute>
  </mapID>
</xsl:template>

<xsl:template match="d:book" mode="map">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <mapID target="{$id}">
    <xsl:attribute name="url">
      <xsl:call-template name="href.target.uri"/>
    </xsl:attribute>
  </mapID>
</xsl:template>

<xsl:template match="d:part|d:reference|d:preface|d:chapter|d:appendix|d:refentry|d:article|d:glossary|d:bibliography"
              mode="map">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <mapID target="{$id}">
    <xsl:attribute name="url">
      <xsl:call-template name="href.target.uri"/>
    </xsl:attribute>
  </mapID>
</xsl:template>

<xsl:template match="d:section|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:colophon" mode="map">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <mapID target="{$id}">
    <xsl:attribute name="url">
      <xsl:call-template name="href.target.uri"/>
    </xsl:attribute>
  </mapID>
</xsl:template>

<xsl:template match="d:indexterm[@class='endofrange']" mode="map"/>

<xsl:template match="d:indexterm" mode="map">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <mapID target="{$id}">
    <xsl:attribute name="url">
      <xsl:call-template name="href.target.uri"/>
    </xsl:attribute>
  </mapID>
</xsl:template>

<xsl:template match="*[@id]" mode="map">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <mapID target="{$id}">
    <xsl:attribute name="url">
      <xsl:call-template name="href.target.uri"/>
    </xsl:attribute>
  </mapID>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="helpidx">
  <xsl:call-template name="write.chunk.with.doctype">
    <xsl:with-param name="filename" select="concat($chunk.base.dir, 'jhelpidx.xml')"/>
    <xsl:with-param name="method" select="'xml'"/>
    <xsl:with-param name="indent" select="'yes'"/>
    <xsl:with-param name="doctype-public" select="'-//Sun Microsystems Inc.//DTD JavaHelp Index Version 1.0//EN'"/>
    <xsl:with-param name="doctype-system" select="'http://java.sun.com/products/javahelp/index_1_0.dtd'"/>
    <xsl:with-param name="encoding" select="$javahelp.encoding"/>
    <xsl:with-param name="content">
      <xsl:call-template name="helpidx.content"/>
    </xsl:with-param>
    <xsl:with-param name="quiet" select="$chunk.quietly"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="helpidx.content">
  <index version="1.0">
    <xsl:choose>
      <xsl:when test="$rootid != ''">
        <xsl:apply-templates select="key('id',$rootid)//d:indexterm" mode="idx">
	  <xsl:sort select="d:primary"/>
	  <xsl:sort select="d:secondary"/>
	  <xsl:sort select="d:tertiary"/>
	</xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="//d:indexterm" mode="idx">
          <xsl:sort select="d:primary"/>
	  <xsl:sort select="d:secondary"/>
	  <xsl:sort select="d:tertiary"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </index>
</xsl:template>

<xsl:template match="d:indexterm[@class='endofrange']" mode="idx"/>

<xsl:template match="d:indexterm" mode="idx">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="text">
    <xsl:value-of select="normalize-space(d:primary)"/>
    <xsl:if test="d:secondary">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="normalize-space(d:secondary)"/>
    </xsl:if>
    <xsl:if test="d:tertiary">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="normalize-space(d:tertiary)"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="d:see">
      <xsl:variable name="see"><xsl:value-of select="normalize-space(d:see)"/></xsl:variable>
      <indexitem text="{$text} see '{$see}'"/>
    </xsl:when>
    <xsl:otherwise>
      <indexitem text="{$text}" target="{$id}"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->
<!-- Kludge for Xalan outputting &trade; which fails in javahelp -->
<xsl:template name="dingbat.characters">
  <!-- now that I'm using the real serializer, all that dingbat malarky -->
  <!-- isn't necessary anymore... -->
  <xsl:param name="dingbat">bullet</xsl:param>

  <xsl:choose>
    <xsl:when test="$dingbat='bullet'">&#x2022;</xsl:when>
    <xsl:when test="$dingbat='copyright'">&#x00A9;</xsl:when>
    <xsl:when test="$dingbat='trademark' or $dingbat='trade'">
      <xsl:choose>
        <xsl:when test="contains(system-property('xsl:vendor'),
                                 'Apache Software Foundation')">
          <sup>TM</sup>
        </xsl:when>
        <xsl:otherwise>&#x2122;</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$dingbat='registered'">&#x00AE;</xsl:when>
    <xsl:when test="$dingbat='service'">(SM)</xsl:when>
    <xsl:when test="$dingbat='nbsp'">&#x00A0;</xsl:when>
    <xsl:when test="$dingbat='ldquo'">&#x201C;</xsl:when>
    <xsl:when test="$dingbat='rdquo'">&#x201D;</xsl:when>
    <xsl:when test="$dingbat='lsquo'">&#x2018;</xsl:when>
    <xsl:when test="$dingbat='rsquo'">&#x2019;</xsl:when>
    <xsl:when test="$dingbat='em-dash'">&#x2014;</xsl:when>
    <xsl:when test="$dingbat='mdash'">&#x2014;</xsl:when>
    <xsl:when test="$dingbat='en-dash'">&#x2013;</xsl:when>
    <xsl:when test="$dingbat='ndash'">&#x2013;</xsl:when>
    <xsl:otherwise>
      <xsl:text>&#x2022;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
